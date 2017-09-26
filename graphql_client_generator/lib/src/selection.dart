// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client_generator.parser;

abstract class SelectionSet implements Generable {
  List<SelectionSet> children = [];
  GQLFragmentGenerator parent;

  SelectionSetContext get selectionSetContext;
  GQLSettings get settings;
  Map<String, GQLFragmentGenerator> get fragmentsMap;

  bool get isNotEmpty =>
      selectionSetContext != null && selectionSetContext.selections.isNotEmpty;

  bool get isEmpty =>
      selectionSetContext == null || selectionSetContext.selections.isEmpty;

  List<Generable> get nestedGenerators =>
      []..addAll(fieldsGenerators)..addAll(fragmentSpreads);

  List<GQLFieldGenerator> get fieldsGenerators {
    if (isNotEmpty) {
      return selectionSetContext.selections
          .where((s) => s.field != null)
          .map((s) => new GQLFieldGenerator(s.field, fragmentsMap, settings))
          .toList();
    }

    return const [];
  }

  List<GQLFragmentGenerator> get fragmentSpreads {
    if (isNotEmpty) {
      return selectionSetContext.selections
          .where((s) => s.fragmentSpread != null)
          .map((s) => fragmentsMap[s.fragmentSpread.name])
          .toList();
    }

    return const [];
  }

  List<GQLFragmentGenerator> getNestedFragments(SelectionSet selectionsSet) {
    if (selectionsSet.isEmpty) {
      return [];
    }

    final res = selectionsSet.fragmentSpreads;

    selectionsSet.fragmentSpreads
        .forEach((f) => res.addAll(getNestedFragments(f)));

    return res;
  }

  List<Field> get fields => []
    ..addAll(fieldsGenerators
        .map((s) => new Field((b) => b
          ..name = s.alias ?? s.name
          ..type = new Reference(s.resolverName)
          ..assignment = new Code((b) => b..code = 'new ${s.resolverName}()')))
        .toList())
    ..addAll(getNestedFragments(this)
        .expand((f) => f.fieldsGenerators.map((field) => new Field((b) => b
          ..name = '${field.name}'
          ..type = new Reference(field.resolverName))))
        .toList())
    ..addAll(fragmentSpreads
        .map((f) => new Field((b) => b
          ..name = '_${f.assignmentName}'
          ..type = new Reference(f.fragmentName)
          ..assignment = new Code((b) => b..code = 'new ${f.fragmentName}()')))
        .toList())
    ..addAll(getNestedFragments(this)
        .where((f) => !fragmentSpreads.contains(f))
        .map((f) => new Field((b) => b
          ..name = '_${f.assignmentName}'
          ..type = new Reference(f.fragmentName)))
        .toList());

  List<Spec> parseSelections(List<Generable> generables, List<Spec> specs) {
    generables.forEach((g) {
      specs.addAll(g.generate());

      if (g.isNotEmpty) {
        specs.addAll(parseSelections(g.fieldsGenerators, []));
      }
    });

    return specs;
  }

  addChildren(List<SelectionSet> value) => children.addAll(value);
  addParent(SelectionSet value) => parent = value;

  void resolveFragmentsFamily(SelectionSet selection) {
    final nestedFragments = selection.fragmentSpreads;

    selection.addChildren(nestedFragments);
    nestedFragments.forEach((f) => f.addParent(selection));
  }
}
