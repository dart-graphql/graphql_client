// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client_generator.visitor;

enum OperationType { query, mutation }

String renderOperationType(OperationType type) {
  switch (type) {
    case OperationType.query:
      return 'query';
      break;
    case OperationType.mutation:
      return 'mutation';
      break;
  }
}

class Operation implements Node {
  final OperationDefinitionContext _ctx;

  @override
  Node parent;

  @override
  List<Node> children;

  @override
  List<Fragment> fragments;

  Operation(this._ctx)
      : parent = null,
        children = [],
        fragments = [];

  String get name => _ctx.name;

  OperationType get type {
    if (_ctx.isQuery) {
      return OperationType.query;
    }
    if (_ctx.isMutation) {
      return OperationType.mutation;
    }
    throw new StateError('Unknow Opration Type');
  }

  String get typeToString => renderOperationType(type);

  String get arguments => _ctx.variableDefinitions != null
      ? _ctx.variableDefinitions.toSource()
      : '';

  String get directives => _ctx.directives.map((d) => d.toSource()).join(', ');
}
