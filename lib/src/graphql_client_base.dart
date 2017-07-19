// Copyright (c) 2017, thomashourlier. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:core';
import 'dart:convert';
import 'dart:mirrors';

import 'package:logging/logging.dart';

final log = new Logger('graphql_client');

String _indentLine(String source, int size) {
  return source
      .split("\n")
      .map((String s) => "${new List.filled(size, ' ').join('')}$s")
      .join("\n");
}

class GraphQLString {
  String _value;

  GraphQLString([this._value]);

  String get value {
    if (_value == null) {
      throw new StateError("This value hasn't been requested");
    }

    return _value;
  }
}

class GraphQLArguments {
  final String arguments;

  const GraphQLArguments(this.arguments);
}

class GraphQLConnection<NodeType> {
  static ClassMirror classMirror = reflectClass(GraphQLConnection);

  List<NodeType> nodes;
  NodeType _nodesSchema;

  GraphQLConnection({NodeType nodes}) : _nodesSchema = nodes;
  GraphQLConnection.fromJSON(Map data) {
    ClassMirror nodeTypeMirror = reflectType(NodeType);

    nodes = new List<NodeType>.from(
      data['nodes'].map((Map n) =>
          nodeTypeMirror.newInstance(const Symbol('fromJSON'), [n]).reflectee),
    );
  }

  NodeType get nodesSchema => _nodesSchema;

  @override
  String toString() {
    return '''
      nodes:
${_indentLine(nodes.toString(), 2)}
    ''';
  }
}

class Query {
  Viewer viewer;

  Query({this.viewer});
  Query.fromJSON(Map data) : viewer = new Viewer.fromJSON(data['viewer']);

  @override
  String toString() {
    return '''
      query:
        viewer:
${_indentLine(viewer.toString(), 4)}
    ''';
  }
}

class Viewer {
  GraphQLString login;
  @GraphQLArguments('size: 200')
  GraphQLString avatarUrl;
  GraphQLString bio;
  @GraphQLArguments('last: 2')
  GraphQLConnection<Gist> gists;

  Viewer({this.login, this.avatarUrl, this.bio, this.gists});
  Viewer.fromJSON(Map data)
      : login = new GraphQLString(data['login']),
        avatarUrl = new GraphQLString(data['avatarUrl']),
        bio = new GraphQLString(data['bio']),
        gists = new GraphQLConnection<Gist>.fromJSON(data['gists']);

  @override
  String toString() {
    return '''
      login: $login
      avatarUrl: $avatarUrl
      bio: $bio,
      gists:
${_indentLine(gists.toString(), 2)}
    ''';
  }
}

class Gist {
  GraphQLString name;
  GraphQLString description;

  Gist({this.name, this.description});
  Gist.fromJSON(Map data)
      : name = new GraphQLString(data['name']),
        description = new GraphQLString(data['description']);

  @override
  String toString() {
    return '''
      name: $name
      description: $description
    ''';
  }
}

Object getAnnotation(DeclarationMirror declaration, Type annotation) {
  for (var instance in declaration.metadata) {
    if (instance.hasReflectee) {
      var reflectee = instance.reflectee;
      if (reflectee.runtimeType == annotation) {
        return reflectee;
      }
    }
  }

  return null;
}

String buildInstanceQuery(InstanceMirror instanceMirror) {
  ClassMirror classMirror = instanceMirror.type;
  var classDeclarations = classMirror.declarations;

  if (classDeclarations == null) {
    return '';
  }

  var ownVariablesMirrorSymbols = classDeclarations.keys
      .where((Symbol s) => classDeclarations[s] is VariableMirror)
      .where((Symbol s) => !classDeclarations[s].isPrivate)
      .where((Symbol s) => instanceMirror.getField(s).reflectee != null);

  if (ownVariablesMirrorSymbols.isEmpty) {
    return '';
  }

  var gqlQuery = '';

  ownVariablesMirrorSymbols.forEach((Symbol s) {
    var ownVariableInstance = instanceMirror.getField(s);

    // the field has been instantiated in the query
    var childQuery = '';
    log.finest('Current symbol: $s');

    // retrieve GraphQL arguments
    VariableMirror ownVariableMirror = classDeclarations[s];
    GraphQLArguments argumentsAnnotation =
        getAnnotation(ownVariableMirror, GraphQLArguments);

    // GraphQL connections
    ClassMirror ownVariableClass = ownVariableInstance.type;
    if (ownVariableClass.isSubclassOf(GraphQLConnection.classMirror)) {
      var nodesSchemaInstance =
          ownVariableInstance.getField(const Symbol('nodesSchema'));

      childQuery += '{ nodes ${buildInstanceQuery(nodesSchemaInstance)} }';
    } else {
      childQuery += buildInstanceQuery(ownVariableInstance);
    }

    gqlQuery += '${
            MirrorSystem.getName(s)
        }${
            argumentsAnnotation != null ? '(${argumentsAnnotation.arguments})' : ''
        } $childQuery';
  });

  log.finest(
      'Query computed for ${instanceMirror.type.reflectedType}: $gqlQuery');

  return '{ ${gqlQuery.trim()} }';
}

String queryBuilder(Query query) {
  InstanceMirror queryInstanceMirror = reflect(query);

  String gqlQuery = buildInstanceQuery(queryInstanceMirror);

  return gqlQuery;
}

Query reconcileResponse(String response) {
  Map jsonResponse = JSON.decode(response);

  return new Query.fromJSON(jsonResponse['data']);
}
