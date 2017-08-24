// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.converter;

class GraphQLEncoder extends Converter<GQLOperation, String> {
  const GraphQLEncoder();

  @override
  String convert(GQLOperation operation) {
    String gql;

    try {
      var operationGQL = _encodeOperation(operation);
      var fragmentsGQL = _encodeNestedOperationFragments(operation);

      gql = '$operationGQL\n$fragmentsGQL';
    } catch (e) {
      throw new EncoderError(
          'Error when encoding the given GQL query: ${e.toString()}');
    }

    return gql;
  }

  List<GQLField> _extractResolvers(GQLField operation) {
    return operation.fields;
  }

  List<GQLFragment> _extractFragments(GQLField operation) {
    return operation.fragments;
  }

  List<GQLFragment> _extractNestedFragments(GQLField operation) {
    var fragments = operation.fields
        .map(_extractNestedFragments)
        .expand((List<GQLFragment> f) => f)
        .toList();

    fragments.addAll(operation.fragments);

    return fragments;
  }

  String _encodeOperation(GQLOperation operation) {
    GQLField field = operation;
    var rootResolver = _encodeOperationResolvers(operation);
    var operationType =
        operation.type == OperationType.mutation ? 'mutation' : 'query';
    var args = '';

    if (field is Arguments) {
      args = '(${field.args})';
    }

    return '$operationType ${operation.name} $args { $rootResolver }';
  }

  String _encodeOperationResolvers(GQLField operation) {
    return _extractResolvers(operation).map(_encodeResolver).join(' ');
  }

  String _encodeOperationInlineFragments(GQLField operation) {
    return _extractFragments(operation).map(_encodeInlineFragment).join(' ');
  }

  String _encodeNestedOperationFragments(GQLField operation) {
    return _extractNestedFragments(operation).map(_encodeFragment).join('\n');
  }

  String _encodeFragment(GQLFragment fragment) {
    var rootResolver = _encodeOperationResolvers(fragment);
    var fragmentsGQL = _encodeNestedOperationFragments(fragment);

    return 'fragment ${fragment.name} on ${fragment.onType} { $rootResolver }${fragmentsGQL.isNotEmpty ? fragmentsGQL : ''}';
  }

  String _encodeResolver(GQLField operation) {
    var gql = '';
    var childrenGQL = _encodeOperationResolvers(operation);
    var childrenFragment = _encodeOperationInlineFragments(operation);

    if (operation is Alias) {
      gql += '${operation.alias}: ';
    }

    gql += operation.name != null ? '${operation.name} ' : '';

    if (operation is Arguments) {
      gql += '(${operation.args}) ';
    }

    gql += childrenGQL.isNotEmpty || childrenFragment.isNotEmpty
        ? '{ $childrenGQL $childrenFragment }'
        : '';

    return gql;
  }

  String _encodeInlineFragment(GQLFragment fragment) {
    return '...${fragment.name}';
  }
}
