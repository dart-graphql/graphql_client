// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client_generator.parser;

class GQLOperationGenerator extends Object with Selection {
  final OperationDefinitionContext _operationContext;
  final GQLSettings _settings;

  GQLOperationGenerator(this._operationContext, this._settings);

  @override
  SelectionSetContext get selectionSetContext => _operationContext.selectionSet;

  @override
  GQLSettings get settings => _settings;

  String get name => _operationContext.name;

  String get type {
    if (_operationContext.isQuery) {
      return 'query';
    }
    if (_operationContext.isMutation) {
      return 'mutation';
    }
    throw new StateError('Unknow Opration Type');
  }

  String get arguments => _operationContext.variableDefinitions != null
      ? _operationContext.variableDefinitions.toSource()
      : '';

  String get operationName =>
      '${name[0].toUpperCase()}${name.substring(1)}${type[0].toUpperCase()}${type.substring(1)}';

  String get operationType {
    if (_operationContext.isQuery) {
      return 'queryType';
    }
    if (_operationContext.isMutation) {
      return 'mutationType';
    }
    throw new StateError('Unknow Opration Type');
  }

  List<Reference> get mixin => [
        isNotEmpty ? const Reference('Fields') : null,
        arguments.isNotEmpty ? const Reference('Arguments') : null,
      ].where((r) => r != null).toList();

  List<Method> get methods {
    final operationFieldsNames = fields.map((f) => f.name);
    final operationFieldsDeclarations = operationFieldsNames.join(', ');
    final cloneMethodFields = 'new $operationName()${
        operationFieldsNames.isNotEmpty ?
        '..${operationFieldsNames.map((n) => '$n = $n.gqlClone()').join('..')}' :
        ''
    }';

    return [
      new Method((b) => b
        ..name = 'gqlType'
        ..type = MethodType.getter
        ..lambda = true
        ..returns = const Reference('String')
        ..body = new Code((b) => b..code = "$operationType")
        ..annotations.add(new Annotation(
            (b) => b..code = new Code((b) => b..code = 'override')))),
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
      isNotEmpty
          ? new Method((b) => b
            ..name = 'gqlFields'
            ..type = MethodType.getter
            ..lambda = true
            ..returns = const Reference('List<GQLField>')
            ..body = new Code((b) => b..code = "[$operationFieldsDeclarations]")
            ..annotations.add(new Annotation(
                (b) => b..code = new Code((b) => b..code = 'override'))))
          : null,
      new Method((b) => b
        ..name = 'gqlClone'
        ..returns = new Reference(operationName)
        ..lambda = true
        ..body = new Code((b) => b..code = cloneMethodFields)
        ..annotations.add(new Annotation(
            (b) => b..code = new Code((b) => b..code = 'override')))),
    ].where((m) => m != null).toList();
  }
}
