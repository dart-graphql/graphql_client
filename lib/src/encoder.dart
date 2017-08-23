// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.converter;

class GraphQLEncoder extends Converter<GQLOperation, String> {
  const GraphQLEncoder();

  @override
  String convert(GQLOperation operation) {
    var operationGQL = _encodeOperation(operation);
    var fragmentsGQL = _encodeNestedOperationFragments(operation);

    var gql = '$operationGQL\n$fragmentsGQL';

    return gql;
  }

  List<GQLOperation> _extractResolvers(GQLOperation operation) {
    return operation.resolvers;
  }

  List<GQLOperation> _extractFragments(GQLOperation operation) {
    return operation.fragments;
  }

  List<Fragment> _extractNestedFragments(GQLOperation operation) {
    var fragments = operation.resolvers
        .map(_extractNestedFragments)
        .expand((List<Fragment> f) => f)
        .toList();

    fragments.addAll(operation.fragments);

    return fragments;
  }

  String _encodeOperationResolvers(GQLOperation operation) {
    return _extractResolvers(operation).map(_encodeResolver).join(' ');
  }

  String _encodeOperationInlineFragments(GQLOperation operation) {
    return _extractFragments(operation).map(_encodeInlineFragment).join(' ');
  }

  String _encodeNestedOperationFragments(GQLOperation operation) {
    return _extractNestedFragments(operation).map(_encodeFragment).join('\n');
  }

  String _encodeOperation(GQLOperation operation) {
    var rootResolver = _encodeOperationResolvers(operation);
    var operationType =
        operation.type == OperationType.mutation ? 'mutation' : 'query';
    var args = '';

    if (operation is Arguments) {
      args = '(${operation.args})';
    }

    return '$operationType ${operation.name} $args { $rootResolver }';
  }

  String _encodeFragment(Fragment fragment) {
    var rootResolver = _encodeOperationResolvers(fragment);
    var fragmentsGQL = _encodeNestedOperationFragments(fragment);

    return 'fragment ${fragment.name} on ${fragment.onType} { $rootResolver }${fragmentsGQL.isNotEmpty ? fragmentsGQL : ''}';
  }

  String _encodeResolver(GQLOperation operation) {
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

  String _encodeInlineFragment(Fragment fragment) {
    return '...${fragment.name}';
  }
}
