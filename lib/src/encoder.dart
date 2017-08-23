// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.converter;

class GraphQLEncoder extends Converter<GQLOperation, String> {
  const GraphQLEncoder();

  @override
  String convert(GQLOperation operation) {
    var operationGQL = _encodeOperation(operation);
    var fragmentsGQL =
        _extractFragments(operation).map(_encodeFragment).join('\n');

    var gql = '$operationGQL\n$fragmentsGQL';

    return gql;
  }

  String _encodeResolver(GQLOperation operation) {
    var gql = '';
    var childrenGQL = operation.resolvers.map(_encodeResolver).join(' ');
    var childrenFragment =
        operation.fragments.map(_encodeInlineFragment).join(' ');

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

  String _encodeInlineFragment(Fragment f) {
    return '...${f.name}';
  }

  String _encodeOperation(GQLOperation operation) {
    var rootResolver =
        _extractResolvers(operation).map(_encodeResolver).join(' ');
    var operationType =
        operation.type == OperationType.mutation ? 'mutation' : 'query';
    var args = '';

    if (operation is Arguments) {
      args = '(${operation.args})';
    }

    return '$operationType ${operation.name} $args { $rootResolver }';
  }

  String _encodeFragment(Fragment fragment) {
    var rootResolver = fragment.resolvers.map(_encodeResolver).join(' ');

    return 'fragment ${fragment.name} on ${fragment.onType} { $rootResolver }';
  }

  List<GQLOperation> _extractResolvers(GQLOperation operation) {
    return operation.resolvers;
  }

  List<Fragment> _extractFragments(GQLOperation operation) {
    var fragments = operation.resolvers
        .map(_extractFragments)
        .expand((List<Fragment> f) => f)
        .toList();

    fragments.addAll(operation.fragments);

    return fragments;
  }
}
