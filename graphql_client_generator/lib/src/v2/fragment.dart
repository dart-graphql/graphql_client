// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client_generator.visitor;

class Fragment implements Node {
  final FragmentDefinitionContext _ctx;

  @override
  Node parent;

  @override
  List<Node> children;

  @override
  List<Fragment> fragments;

  Fragment(this._ctx)
      : children = [],
        fragments = [];

  String get name => _ctx.name;

  String get type => _ctx.typeCondition.typeName.name;
}
