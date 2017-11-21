// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client_generator.visitor;

import 'package:graphql_parser/graphql_parser.dart';

import 'settings.dart';

part 'field.dart';
part 'fragment.dart';
part 'operation.dart';
part 'node.dart';

class FragmentSpreadResolution {
  final String name;
  final Node parent;

  FragmentSpreadResolution(this.name, this.parent);
}

class GQLVisitor {
  final GeneratorSettings _settings;

  final Map<String, Operation> operations;
  final Map<String, Fragment> fragments;

  final List<FragmentSpreadResolution> _spreadResolutions;

  GQLVisitor(this._settings)
      : operations = {},
        fragments = {},
        _spreadResolutions = [];

  execute(String gql) {
    final parser = new Parser(scan(gql));
    final document = parser.parseDocument();

    _visitDocument(document);
  }

  void _resolveFragmentSpreads() {
    _spreadResolutions.forEach(_resolveFragmentSpread);
  }

  void _resolveFragmentSpread(FragmentSpreadResolution f) {
    final fragment = fragments[f.name];

    f.parent.fragments.add(fragment);
  }

  void _visitDocument(DocumentContext ctx) {
    ctx.definitions
        .where((ctx) => ctx is FragmentDefinitionContext)
        .forEach(_visitFragmentDefinition);
    ctx.definitions
        .where((ctx) => ctx is OperationDefinitionContext)
        .forEach(_visitOperationDefinition);

    _resolveFragmentSpreads();
  }

  void _visitOperationDefinition(OperationDefinitionContext ctx) {
    final operation = new Operation(ctx);

    operations[operation.name] = operation;

    _visitSelectionSet(ctx.selectionSet, operation);
  }

  void _visitFragmentDefinition(FragmentDefinitionContext ctx) {
    final fragment = new Fragment(ctx);

    fragments[fragment.name] = fragment;

    _visitSelectionSet(ctx.selectionSet, fragment);
  }

  void _visitSelectionSet(SelectionSetContext ctx, Node parent) {
    if (ctx != null && ctx.selections.isNotEmpty) {
      ctx.selections.forEach((s) => _visitSelection(s, parent));
    }
  }

  void _visitSelection(SelectionContext ctx, Node parent) {
    if (ctx.field != null) {
      _visitField(ctx.field, parent);
    }
    if (ctx.fragmentSpread != null) {
      _visitFragmentSpread(ctx.fragmentSpread, parent);
    }
  }

  void _visitField(FieldContext ctx, Node parent) {
    final field = new GQLField(ctx, _settings)..parent = parent;

    parent.children.add(field);

    _visitSelectionSet(ctx.selectionSet, field);
  }

  void _visitFragmentSpread(FragmentSpreadContext ctx, Node parent) {
    _spreadResolutions.add(new FragmentSpreadResolution(ctx.name, parent));
  }
}
