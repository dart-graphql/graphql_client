// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.src.query_builder;

import 'dart:mirrors';

import 'annotations.dart';
import 'connection.dart';

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

  return '{ ${gqlQuery.trim()} }';
}

String queryBuilder<T>(T query) {
  InstanceMirror queryInstanceMirror = reflect(query);
  String gqlQuery = buildInstanceQuery(queryInstanceMirror);

  return gqlQuery;
}
