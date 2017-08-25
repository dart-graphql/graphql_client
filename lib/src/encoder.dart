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
      return operation.fields;
    }

    return const [];
  }

  List<GQLFragment> _extractFragments(GQLField operation) {
    if (operation is Fragments) {
      return operation.fragments;
    }
    return const [];
  }

  List<GQLFragment> _extractNestedFragments(GQLField operation) {
    final fragments = _extractFields(operation)
        .map(_extractNestedFragments)
        .expand((f) => f)
        .toList();

    if (operation is Fragments) {
      fragments.addAll(operation.fragments);
    }

    return fragments;
  }

  String _encodeOperation(GQLOperation operation) {
    final GQLField field = operation;
    final rootResolver = _encodeOperationResolvers(operation);
    final operationType =
        operation.type == OperationType.mutation ? 'mutation' : 'query';
    var args = '';

    if (field is Arguments) {
      args = '(${field.args})';
    }

    return '$operationType ${operation.name} $args { $rootResolver }';
  }

  String _encodeOperationResolvers(GQLField operation) =>
      _extractFields(operation).map(_encodeResolver).join(' ');

  String _encodeOperationInlineFragments(GQLField operation) =>
      _extractFragments(operation).map(_encodeInlineFragment).join(' ');

  String _encodeNestedOperationFragments(GQLField operation) =>
      _extractNestedFragments(operation).map(_encodeFragment).join('\n');

  String _encodeFragment(GQLFragment fragment) {
    final rootResolver = _encodeOperationResolvers(fragment);
    final fragmentsGQL = _encodeNestedOperationFragments(fragment);

    return 'fragment ${fragment.name} on ${fragment.onType} { $rootResolver }${fragmentsGQL.isNotEmpty ? fragmentsGQL : ''}';
  }

  String _encodeResolver(GQLField operation) {
    final childrenGQL = _encodeOperationResolvers(operation);
    final childrenFragment = _encodeOperationInlineFragments(operation);

    final alias = (operation is Alias) ? '${operation.alias}: ' : '';
    final name = operation.name != null ? '${operation.name} ' : '';
    final args = (operation is Arguments) ? '(${operation.args}) ' : '';
    final fields = (childrenGQL.isNotEmpty || childrenFragment.isNotEmpty)
        ? '{ $childrenGQL $childrenFragment }'
        : '';

    return '$alias$name$args$fields';
  }

  String _encodeInlineFragment(GQLFragment fragment) => '...${fragment.name}';
}
