// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.src.connection;

import 'dart:mirrors';

import 'utils.dart';

/// Represents a GraphQL standard connection.
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
${indentLines(nodes.toString(), 2)}
    ''';
  }
}
