// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client_generator.parser;

class GQLFieldGenerator extends Object with SelectionSet implements Generable {
  final FieldContext _fieldContext;
  final Map<String, GQLFragmentGenerator> _fragmentsMap;
  final GQLSettings _settings;

  GQLFieldGenerator(this._fieldContext, this._fragmentsMap, this._settings);

  @override
  SelectionSetContext get selectionSetContext => _fieldContext.selectionSet;

  @override
  GQLSettings get settings => _settings;

  @override
  Map<String, GQLFragmentGenerator> get fragmentsMap => _fragmentsMap;

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
        fragmentSpreads.isNotEmpty ? const Reference('Fragments') : null,
      ].where((r) => r != null).toList();

  List<Method> get methods {
    final resolverFields = fieldsGenerators;

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
    final fragmentFieldsNames =
        fragmentSpreads.map((f) => '_${f.assignmentName}');
    final fragmentFieldsDeclarations = fragmentFieldsNames.join(', ');

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
      fragmentSpreads.isNotEmpty
          ? new Method((b) => b
            ..name = 'gqlFragments'
            ..type = MethodType.getter
            ..lambda = true
            ..body = new Code((b) => b..code = "[$fragmentFieldsDeclarations]")
            ..returns = const Reference('List<GQLFragment>')
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

  List<Reference> get implements => [
        const Reference('GQLField'),
      ]..addAll(
          fragmentSpreads.map((f) => new Reference(f.fragmentResolverName)));

  List<Constructor> get constructors {
    final nestedFragments = getNestedFragments(this);
    final deeperNestedFragments =
        nestedFragments.where((f) => !fragmentSpreads.contains(f));

    if (nestedFragments.isEmpty) {
      return const [];
    }

    var constructorCode = '';

    if (deeperNestedFragments.isNotEmpty) {
      constructorCode = deeperNestedFragments
          .map((f) =>
              '_${f.assignmentName} = _${f.parent.assignmentName}._${f.assignmentName}')
          .join(';');
      constructorCode = '$constructorCode;';
    }

    constructorCode = '$constructorCode${nestedFragments
        .expand((f) => f.fieldsGenerators.map(
            (field) => '${field.name} = _${f.assignmentName}.${field.name}'))
        .join(';')}';

    constructorCode = '$constructorCode;';

    return [
      new Constructor(
          (b) => b..body = new Code((b) => b.code = constructorCode)),
    ];
  }

  @override
  List<Spec> generate() => [
        new Class((b) => b
          ..name = resolverName
          ..extend = const Reference('Object')
          ..mixins.addAll(mixin)
          ..implements.addAll(implements)
          ..constructors.addAll(constructors)
          ..methods.addAll(methods)
          ..fields.addAll(fields)),
      ];
}
