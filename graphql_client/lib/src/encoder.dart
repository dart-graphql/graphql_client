// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.converter;

/// A GQL query encoder.
///
/// It converts a [GQLOperation] into a [String].
/// The output string is GQL compliant.
class GQLEncoder extends Converter<GQLOperation, String> {
  /// Creates an [GQLEncoder].
  const GQLEncoder();

  @override
  String convert(GQLOperation operation) {
    final operationGQL = _encodeOperation(operation);
    final fragmentsGQL = _encodeNestedOperationFragments(operation);

    return '$operationGQL\n$fragmentsGQL';
  }

  List<GQLField> _extractFields(GQLField operation) {
    if (operation is Fields) {
      return operation.gqlFields;
    }

    return const [];
  }

  List<GQLFragment> _extractFragments(GQLField operation) {
    if (operation is Fragments) {
      return operation.gqlFragments;
    }
    return const [];
  }

  List<GQLFragment> _extractNestedFragments(GQLField operation) {
    final fragments = _extractFields(operation)
        .map(_extractNestedFragments)
        .expand((f) => f)
        .toList();

    if (operation is Fragments) {
      fragments.addAll(operation.gqlFragments);
    }

    return fragments;
  }

  String _encodeOperation(GQLOperation operation) {
    final GQLField field = operation;
    final rootField = _encodeOperationFields(operation);
    final args = (field is Arguments) ? field.gqlArguments : '';

    return '${operation.gqlType} ${operation.gqlName} $args { $rootField }';
  }

  String _encodeOperationFields(GQLField operation) =>
      _extractFields(operation).map(_encodeField).join(' ');

  String _encodeOperationInlineFragments(GQLField operation) =>
      _extractFragments(operation).map(_encodeInlineFragment).join(' ');

  String _encodeNestedOperationFragments(GQLField operation) =>
      _extractNestedFragments(operation).map(_encodeFragment).join('\n');

  String _encodeFragment(GQLFragment fragment) {
    final rootField = _encodeOperationFields(fragment);
    final fragmentsGQL = _encodeNestedOperationFragments(fragment);

    return 'fragment ${fragment.gqlName} on ${fragment.gqlOnType} { $rootField }${fragmentsGQL.isNotEmpty ? fragmentsGQL : ''}';
  }

  String _encodeField(GQLField operation) {
    final childrenGQL = _encodeOperationFields(operation);
    final childrenFragment = _encodeOperationInlineFragments(operation);

    final alias = (operation is Alias) ? '${operation.gqlAlias}: ' : '';
    final name = operation.gqlName != null ? '${operation.gqlName} ' : '';
    final args = (operation is Arguments) ? '${operation.gqlArguments} ' : '';
    final directive =
        (operation is Directives) ? '${operation.gqlDirectives} ' : '';
    final fields = (childrenGQL.isNotEmpty || childrenFragment.isNotEmpty)
        ? '{ $childrenGQL $childrenFragment }'
        : '';

    return '$alias$name$args$directive$fields';
  }

  String _encodeInlineFragment(GQLFragment fragment) => '...${fragment.gqlName}';
}
