// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

/// A GQL scalar field.
///
/// It could be applied as a mixin on a [GQLField].
/// This mixin should be used on a field that has no nested field and is scalar.
abstract class Scalar<T> implements GQLField {
  /// The scalar [GQLField] value.
  T value;
}

/// A GQL collection field.
///
/// It could be applied as a mixin on a [GQLField].
/// This mixin should be used on a field that is a collection
/// (ie. has the GQL List type).
abstract class ScalarCollection<T extends GQLField> implements GQLField {
  /// The nodes collection of [GQLField].
  // List<T> nodes;
  // @todo try to have List<T> nodes; back
  List<GQLField> nodes;

  /// The edges collection of [GQLField].
  List<T> edges;

  /// The collection length of [GQLField].
  int totalCount;

  /// Returns the node [GQLField] that will be used to resolve each list item.
  GQLField get nodesResolver => null;

  /// Returns the edge [GQLField] that will be used to resolve each list item.
  GQLField get edgesResolver => null;
}
