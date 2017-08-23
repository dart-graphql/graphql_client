// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.converter;

class GraphQLDecoder extends Converter<String, GQLOperation> {
  const GraphQLDecoder();

  /// Converts a string into a GQL query.
  ///
  /// This is not supported yet. An easy way would be to parse the query and
  /// use mirror.
  /// We plan to use code generation instead.
  @override
  GQLOperation convert(String input) {
    throw new StateError("Not supported. You can't decode a GraphQL query.");
  }
}
