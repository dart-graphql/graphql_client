// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client_generator.parser;

import 'package:code_builder/code_builder.dart';
import 'package:graphql_parser/graphql_parser.dart';

import 'constants.dart';
import 'settings.dart';

import 'v2/visitor.dart' show GQLVisitor;
import 'v2/generator.dart' show GQLGenerator;
import 'v2/settings.dart' show GeneratorSettings;

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
    final visitor = new GQLVisitor(
        new GeneratorSettings(collectionFields: _settings.collectionFields));
    final generator = new GQLGenerator(visitor);

    return generator.generate(gql);
  }
}
