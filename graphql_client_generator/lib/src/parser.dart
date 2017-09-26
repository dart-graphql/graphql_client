// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client_generator.parser;

import 'package:code_builder/code_builder.dart';
import 'package:graphql_parser/graphql_parser.dart';

import 'constants.dart';
import 'settings.dart';

part 'field.dart';
part 'fragment.dart';
part 'operation.dart';
part 'selection.dart';

abstract class Generable {
  List<Spec> generate();
  bool get isNotEmpty;
  bool get isEmpty;
  List<Generable> get nestedGenerators;
  List<GQLFieldGenerator> get fieldsGenerators;
  List<GQLFragmentGenerator> get fragmentSpreads;
}

class GQLParser {
  final GQLSettings _settings;

  GQLParser(this._settings);

  List<Spec> parse(String gql) {
    final parser = new Parser(scan(gql));
    final document = parser.parseDocument();

    final Map<String, GQLFragmentGenerator> fragmentsMap = {};
    final specs = [];

    // extract fragments
    document.definitions.where((d) => d is FragmentDefinitionContext).map((d) {
      final fragment = new GQLFragmentGenerator(d, fragmentsMap, _settings);
      fragmentsMap[fragment.name] = fragment;

      return fragment;
    }).toList()
      ..forEach((f) => f.resolveFragmentsFamily(f))
      ..forEach((f) => specs.addAll(f.generate()));

    document.definitions
        .where((d) => d is OperationDefinitionContext)
        .map((d) => new GQLOperationGenerator(d, fragmentsMap, _settings))
        .toList()
          ..forEach((o) => specs.addAll(o.generate()));

    return specs;
  }
}
