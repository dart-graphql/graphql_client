// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';
import 'package:graphql_parser/graphql_parser.dart';

class GQLParser {
  List<Spec> parse(String gql) {
    final parser = new Parser(scan(gql));
    final document = parser.parseDocument();

    return parseOperation(document.definitions.first);
  }

  List<Spec> parseOperation(OperationDefinitionContext query,
      [List<Spec> specs = const []]) {
    List<Spec> gqlDefinitions = [];

    return parseSelection(query.selectionSet.selections);
  }

  List<Spec> parseSelection(List<SelectionContext> selections,
      [List<Spec> specs = const []]) {
    return selections.map((s) => parseFinalResolver(s.field)).toList();
  }

  Spec parseFinalResolver(FieldContext field) {
    if (field.selectionSet != null &&
        field.selectionSet.selections.isNotEmpty) {
      throw new StateError('The given field is not scalar');
    }

    final name = field.fieldName.alias?.name ?? field.fieldName.name;
    final alias = field.fieldName.alias?.alias;
    final arguments = field.arguments.map((a) => a.toSource()).join(', ');
    final directives = field.directives.map((d) => d.toSource()).join(', ');

    final resolverName = '${name[0].toUpperCase()}${name.substring(1)}Resolver';
    final resolverMixin = [
      const Reference('Scalar<String>'),
      alias != null ? const Reference('Alias') : null,
      arguments.isNotEmpty ? const Reference('Arguments') : null,
      directives.isNotEmpty ? const Reference('Directives') : null,
    ].where((r) => r != null);
    final resolverMethods = [
      new Method((b) => b
        ..name = 'name'
        ..type = MethodType.getter
        ..lambda = true
        ..returns = const Reference('String')
        ..body = new Code((b) => b..code = "'$name'")
        ..annotations.add(new Annotation(
            (b) => b..code = new Code((b) => b..code = 'override')))),
      arguments.isNotEmpty
          ? new Method((b) => b
            ..name = 'args'
            ..type = MethodType.getter
            ..lambda = true
            ..returns = const Reference('String')
            ..body = new Code((b) => b..code = "'($arguments)'")
            ..annotations.add(new Annotation(
                (b) => b..code = new Code((b) => b..code = 'override'))))
          : null,
      directives.isNotEmpty
          ? new Method((b) => b
            ..name = 'directives'
            ..type = MethodType.getter
            ..lambda = true
            ..returns = const Reference('String')
            ..body = new Code((b) => b..code = "'$directives'")
            ..annotations.add(new Annotation(
                (b) => b..code = new Code((b) => b..code = 'override'))))
          : null,
      new Method((b) => b
        ..name = 'clone'
        ..returns = new Reference(resolverName)
        ..lambda = true
        ..body = new Code((b) => b
          ..code =
              'new $resolverName()${alias != null ? '..aliasId = aliasId' : ''}')
        ..annotations.add(new Annotation(
            (b) => b..code = new Code((b) => b..code = 'override')))),
    ].where((m) => m != null);

    return new Class((b) => b
      ..name = resolverName
      ..extend = const Reference('Object')
      ..mixins.addAll(resolverMixin)
      ..implements.add(const Reference('GQLField'))
      ..methods.addAll(resolverMethods));
  }
}
