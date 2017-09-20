// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client_generator.parser;

class GQLFieldGenerator extends Object with Selection {
  final FieldContext _fieldContext;
  final GQLSettings _settings;

  GQLFieldGenerator(this._fieldContext, this._settings);

  @override
  SelectionSetContext get selectionSetContext => _fieldContext.selectionSet;

  @override
  GQLSettings get settings => _settings;

  String get name =>
      _fieldContext.fieldName.alias?.name ?? _fieldContext.fieldName.name;

  String get alias => _fieldContext.fieldName.alias?.alias;

  String get arguments {
    final innerValue =
        _fieldContext.arguments.map((a) => a.toSource()).join(', ');

    return innerValue.isNotEmpty ? '($innerValue)' : '';
  }

  String get directives =>
      _fieldContext.directives.map((d) => d.toSource()).join(', ');

  String get resolverName =>
      '${name[0].toUpperCase()}${name.substring(1)}$resolverSuffix';

  bool get isCollectionField => _settings.collectionFields.contains(name);

  bool get isCollectionResolver => isNotEmpty && isCollectionField;

  List<Reference> get mixin => [
        isEmpty ? const Reference('Scalar') : const Reference('Fields'),
        isCollectionResolver
            ? new Reference('Collection<${resolverName}>')
            : null,
        alias != null ? const Reference('Alias') : null,
        arguments.isNotEmpty ? const Reference('Arguments') : null,
        directives.isNotEmpty ? const Reference('Directives') : null,
      ].where((r) => r != null).toList();

  List<Method> get methods {
    final resolverFields = nestedFieldsGenerators;

    final resolverFieldsNames = resolverFields.map((f) => f.name);
    final resolverFieldsDeclarations = resolverFieldsNames.join(', ');
    final cloneMethodFields = 'new $resolverName()${
        alias != null ?
        '..gqlAliasId = gqlAliasId' :
        ''
    }${
        resolverFieldsNames.isNotEmpty ?
        '..${resolverFieldsNames.map((n) => '$n = $n.gqlClone()').join('..')}' :
        ''
    }';

    return [
      new Method((b) => b
        ..name = 'gqlName'
        ..type = MethodType.getter
        ..lambda = true
        ..returns = const Reference('String')
        ..body = new Code((b) => b..code = "'$name'")
        ..annotations.add(new Annotation(
            (b) => b..code = new Code((b) => b..code = 'override')))),
      arguments.isNotEmpty
          ? new Method((b) => b
            ..name = 'gqlArguments'
            ..type = MethodType.getter
            ..lambda = true
            ..returns = const Reference('String')
            ..body = new Code((b) => b..code = "r'$arguments'")
            ..annotations.add(new Annotation(
                (b) => b..code = new Code((b) => b..code = 'override'))))
          : null,
      directives.isNotEmpty
          ? new Method((b) => b
            ..name = 'gqlDirectives'
            ..type = MethodType.getter
            ..lambda = true
            ..returns = const Reference('String')
            ..body = new Code((b) => b..code = "'$directives'")
            ..annotations.add(new Annotation(
                (b) => b..code = new Code((b) => b..code = 'override'))))
          : null,
      isNotEmpty
          ? new Method((b) => b
            ..name = 'gqlFields'
            ..type = MethodType.getter
            ..lambda = true
            ..returns = const Reference('List<GQLField>')
            ..body = new Code((b) => b..code = "[$resolverFieldsDeclarations]")
            ..annotations.add(new Annotation(
                (b) => b..code = new Code((b) => b..code = 'override'))))
          : null,
      new Method((b) => b
        ..name = 'gqlClone'
        ..returns = new Reference(resolverName)
        ..lambda = true
        ..body = new Code((b) => b..code = cloneMethodFields)
        ..annotations.add(new Annotation(
            (b) => b..code = new Code((b) => b..code = 'override')))),
    ].where((m) => m != null).toList();
  }
}
