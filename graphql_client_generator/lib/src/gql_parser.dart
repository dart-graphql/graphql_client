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

  List<Spec> parseOperation(OperationDefinitionContext query) {
    final gqlDefinitions = parseSelections(query.selectionSet.selections, []);

    return []..addAll(gqlDefinitions);
  }

  List<Spec> parseSelections(
      List<SelectionContext> selections, List<Spec> specs) {
    selections.forEach((s) {
      final field = s.field;

      if (isScalarFieldResolver(field)) {
        specs.add(parseField(field));
      } else {
        specs
          ..add(parseField(field))
          ..addAll(parseSelections(field.selectionSet.selections, []));
      }
    });

    return specs;
  }

  Spec parseField(FieldContext field) {
    final resolverName = getResolverName(field);
    final resolverMixin = getResolverMixin(field);
    final resolverMethods = getResolverMethods(field);
    final resolverFields = getResolverFields(field);

    return new Class((b) => b
      ..name = resolverName
      ..extend = const Reference('Object')
      ..mixins.addAll(resolverMixin)
      ..implements.add(const Reference('GQLField'))
      ..methods.addAll(resolverMethods)
      ..fields.addAll(resolverFields));
  }

  bool isScalarFieldResolver(FieldContext field) =>
      field.selectionSet == null || field.selectionSet.selections.isEmpty;

  String getFieldName(FieldContext field) =>
      field.fieldName.alias?.name ?? field.fieldName.name;
  String getFieldAlias(FieldContext field) => field.fieldName.alias?.alias;
  String getFieldArguments(FieldContext field) =>
      field.arguments.map((a) => a.toSource()).join(', ');
  String getFieldDirectives(FieldContext field) =>
      field.directives.map((d) => d.toSource()).join(', ');

  String getResolverName(FieldContext field) {
    final name = field.fieldName.alias?.name ?? field.fieldName.name;

    return '${name[0].toUpperCase()}${name.substring(1)}Resolver';
  }

  Iterable<Field> getResolverFields(FieldContext field) {
    if (!isScalarFieldResolver(field)) {
      return field.selectionSet.selections.map((s) {
        final nestedField = s.field;
        final nestedResolverName = getResolverName(nestedField);

        return new Field((b) => b
          ..name = getFieldAlias(nestedField) ?? getFieldName(nestedField)
          ..type = new Reference(nestedResolverName)
          ..assignment =
              new Code((b) => b..code = 'new $nestedResolverName()'));
      });
    }

    return const [];
  }

  Iterable<Reference> getResolverMixin(FieldContext field) {
    final alias = getFieldAlias(field);
    final arguments = getFieldArguments(field);
    final directives = getFieldDirectives(field);

    return [
      isScalarFieldResolver(field)
          ? const Reference('Scalar')
          : const Reference('Fields'),
      alias != null ? const Reference('Alias') : null,
      arguments.isNotEmpty ? const Reference('Arguments') : null,
      directives.isNotEmpty ? const Reference('Directives') : null,
    ].where((r) => r != null);
  }

  Iterable<Method> getResolverMethods(FieldContext field) {
    final name = getFieldName(field);
    final alias = getFieldAlias(field);
    final arguments = getFieldArguments(field);
    final directives = getFieldDirectives(field);
    final resolverName = getResolverName(field);
    final resolverFields = getResolverFields(field);

    final resolverFieldsNames = resolverFields.map((f) => f.name);
    final resolverFieldsDeclarations = resolverFieldsNames.join(', ');
    final cloneMethodFields = 'new $resolverName()${
        alias != null ?
        '..aliasId = aliasId' :
        ''
    }${
        resolverFieldsNames.isNotEmpty ?
        '..${resolverFieldsNames.map((n) => '$n = $n.clone()').join('..')}' :
        ''
    }';

    return [
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
      !isScalarFieldResolver(field)
          ? new Method((b) => b
            ..name = 'fields'
            ..type = MethodType.getter
            ..lambda = true
            ..returns = const Reference('List<GQLField>')
            ..body = new Code((b) => b..code = "[$resolverFieldsDeclarations]")
            ..annotations.add(new Annotation(
                (b) => b..code = new Code((b) => b..code = 'override'))))
          : null,
      new Method((b) => b
        ..name = 'clone'
        ..returns = new Reference(resolverName)
        ..lambda = true
        ..body = new Code((b) => b..code = cloneMethodFields)
        ..annotations.add(new Annotation(
            (b) => b..code = new Code((b) => b..code = 'override')))),
    ].where((m) => m != null);
  }
}
