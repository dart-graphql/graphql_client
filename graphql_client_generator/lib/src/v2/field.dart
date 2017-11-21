// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client_generator.visitor;

class GQLField implements Node {
  final FieldContext _ctx;
  final GeneratorSettings _settings;

  @override
  Node parent;

  @override
  List<Node> children;

  @override
  List<Fragment> fragments;

  GQLField(this._ctx, this._settings)
      : children = [],
        fragments = [];

  String get name => _ctx.fieldName.alias?.name ?? _ctx.fieldName.name;

  String get alias => _ctx.fieldName.alias?.alias;

  String get arguments {
    final innerValue = _ctx.arguments.map((a) => a.toSource()).join(', ');

    return innerValue.isNotEmpty ? '($innerValue)' : '';
  }

  String get directives => _ctx.directives.map((d) => d.toSource()).join(', ');

  bool get isList => _settings.collectionFields.contains(name);
  bool get isNonNull => !_settings.collectionFields.contains(name);
  bool get isEmpty =>
      _ctx.selectionSet == null || _ctx.selectionSet.selections.isEmpty;
  bool get isNotEmpty =>
      _ctx.selectionSet != null && _ctx.selectionSet.selections.isNotEmpty;
}
