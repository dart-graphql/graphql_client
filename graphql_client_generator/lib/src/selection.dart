// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client_generator.parser;

abstract class Selection {
  SelectionSetContext get selectionSetContext;
  GQLSettings get settings;

  bool get isNotEmpty =>
      selectionSetContext != null && selectionSetContext.selections.isNotEmpty;

  bool get isEmpty =>
      selectionSetContext == null || selectionSetContext.selections.isEmpty;

  List<GQLFieldGenerator> get nestedFieldsGenerators {
    if (isNotEmpty) {
      return selectionSetContext.selections
          .map((s) => new GQLFieldGenerator(s.field, settings))
          .toList();
    }

    return const [];
  }

  List<Field> get fields => nestedFieldsGenerators
      .map((s) => new Field((b) => b
        ..name = s.alias ?? s.name
        ..type = new Reference(s.resolverName)
        ..assignment = new Code((b) => b..code = 'new ${s.resolverName}()')))
      .toList();
}
