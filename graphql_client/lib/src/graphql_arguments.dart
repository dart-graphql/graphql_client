// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

/// A GraphQL argument.
///
/// It could be applied as a mixin on a [GQLField].
/// Eg.
/// A GQL query with a field using an argument.
/// ```
/// query MyQuery {
///   name(size: SMALL)
/// }
/// ```
abstract class Arguments implements GQLField {
  /// The GQL argument.
  String get args;
}
