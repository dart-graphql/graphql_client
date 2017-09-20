// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client_generator.parser;

import 'package:code_builder/code_builder.dart';
import 'package:graphql_parser/graphql_parser.dart';

import 'constants.dart';
import 'settings.dart';

part 'field.dart';
part 'operation.dart';
part 'selection.dart';

class GQLParser {
  final GQLSettings _settings;

  GQLParser(this._settings);

  List<Spec> parse(String gql) {
    final parser = new Parser(scan(gql));
    final document = parser.parseDocument();

    final specs = [];

    document.definitions.forEach((d) {
      if (d is OperationDefinitionContext) {
        final operationGenerator = new GQLOperationGenerator(d, _settings);

        specs.addAll(parseOperation(operationGenerator));
      } else if (d is FragmentDefinitionContext) {
        print(d);
      }
    });

    return specs;
  }

  List<Spec> parseOperation(GQLOperationGenerator operationGenerator) {
    final operationName = operationGenerator.operationName;
    final operationFields = operationGenerator.fields;
    final operationMixin = operationGenerator.mixin;
    final operationMethods = operationGenerator.methods;

    final gqlDefinitions =
        parseSelections(operationGenerator.nestedFieldsGenerators, []);

    return [
      new Class((b) => b
        ..name = operationName
        ..extend = const Reference('Object')
        ..mixins.addAll(operationMixin)
        ..implements.add(const Reference('GQLOperation'))
        ..methods.addAll(operationMethods)
        ..fields.addAll(operationFields))
    ]..addAll(gqlDefinitions);
  }

  List<Spec> parseSelections(
      List<GQLFieldGenerator> fieldGenerators, List<Spec> specs) {
    fieldGenerators.forEach((f) {
      specs.add(parseField(f));

      if (f.isNotEmpty) {
        specs.addAll(parseSelections(f.nestedFieldsGenerators, []));
      }
    });

    return specs;
  }

  Spec parseField(GQLFieldGenerator fieldGenerator) {
    final resolverName = fieldGenerator.resolverName;
    final resolverMixin = fieldGenerator.mixin;
    final resolverMethods = fieldGenerator.methods;
    final resolverFields = fieldGenerator.fields;

    return new Class((b) => b
      ..name = resolverName
      ..extend = const Reference('Object')
      ..mixins.addAll(resolverMixin)
      ..implements.add(const Reference('GQLField'))
      ..methods.addAll(resolverMethods)
      ..fields.addAll(resolverFields));
  }
}
