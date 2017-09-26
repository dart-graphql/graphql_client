// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client_generator.parser;

class GQLFragmentGenerator extends Object
    with SelectionSet
    implements Generable, Comparable<GQLFragmentGenerator> {
  final FragmentDefinitionContext _fragmentContext;
  final Map<String, GQLFragmentGenerator> _fragmentsMap;
  final GQLSettings _settings;

  GQLFragmentGenerator(
      this._fragmentContext, this._fragmentsMap, this._settings);

  @override
  SelectionSetContext get selectionSetContext => _fragmentContext.selectionSet;

  @override
  GQLSettings get settings => _settings;

  @override
  Map<String, GQLFragmentGenerator> get fragmentsMap => _fragmentsMap;

  String get name => _fragmentContext.name;

  String get fragmentName =>
      '${name[0].toUpperCase()}${name.substring(1)}$fragmentSuffix';

  String get fragmentResolverName => '$fragmentName$resolverSuffix';

  String get assignmentName =>
      '${fragmentName[0].toLowerCase()}${fragmentName.substring(1)}';

  String get type => _fragmentContext.typeCondition.typeName.name;

  List<Method> get methods => [
        new Method((b) => b
          ..name = 'gqlOnType'
          ..type = MethodType.getter
          ..lambda = true
          ..returns = const Reference('String')
          ..body = new Code((b) => b..code = "'$type'")
          ..annotations.add(new Annotation(
              (b) => b..code = new Code((b) => b..code = 'override')))),
      ].toList();

  @override
  int compareTo(GQLFragmentGenerator other) {
    print('Comparing $name to ${other.name}');

    final nestedFragments = getNestedFragments(this);
    final otherNestedFragments = getNestedFragments(other);

    final thisContainsOther = nestedFragments.contains(other);
    final otherContainsThis = otherNestedFragments.contains(this);

    if (otherContainsThis && thisContainsOther) {
      throw new StateError('Cyclic dependency in query');
    }

    if (otherContainsThis) {
      return -1;
    }

    if (thisContainsOther) {
      return 1;
    }

    return 0;
  }

  @override
  List<Spec> generate() {
    final fragmentFieldGenerator = new GQLFieldGenerator(
      new FieldContext(
        new FieldNameContext(new Token(TokenType.NAME, fragmentName)),
        selectionSetContext,
      ),
      _fragmentsMap,
      _settings,
    );

    return [
      new Class((b) => b
        ..name = fragmentName
        ..extend = new Reference(fragmentResolverName)
        ..implements.add(const Reference('GQLFragment'))
        ..methods.addAll(methods)),
    ]
      ..addAll(fragmentFieldGenerator.generate())
      ..addAll(parseSelections(fieldsGenerators, []));
  }

  @override
  String toString() => 'GQLFragmentGenerator: $name';
}
