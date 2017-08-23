// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.converter;

import 'dart:convert';

import 'graphql_definitions.dart';
import 'errors.dart';

part 'encoder.dart';
part 'decoder.dart';

class GraphQLConverter extends Codec<GQLOperation, String> {
  const GraphQLConverter();

  @override
  Converter<GQLOperation, String> get encoder => new GraphQLEncoder();

  @override
  Converter<String, GQLOperation> get decoder => new GraphQLDecoder();
}

const GraphQLConverter GRAPHQL = const GraphQLConverter();
