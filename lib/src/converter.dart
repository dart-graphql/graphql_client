// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.converter;

import 'dart:convert';

import 'graphql.dart';

part 'encoder.dart';

/// A GQL converter.
///
/// It only support [GQLOperation] encoding.
class GQLConverter extends Codec<GQLOperation, String> {
  /// Creates an immutable [GQLConverter].
  const GQLConverter();

  /// Encodes a [GQLOperation] into a [String].
  @override
  Converter<GQLOperation, String> get encoder => const GQLEncoder();

  /// Throws a [StateError] as this is not supported.
  @override
  Converter<String, GQLOperation> get decoder =>
      throw new StateError("Not supported. You can't decode a GraphQL query.");
}

/// An immutable [GQLConverter] instance.
///
/// ignore: constant_identifier_names
const GQLConverter GRAPHQL = const GQLConverter();
