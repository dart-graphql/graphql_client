// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

/// A GQL scalar field.
///
/// It could be applied as a mixin on a [GQLField].
/// This mixin should be used on a field that has no nested field and is scalar.
abstract class Scalar<T> implements GQLField {
  T _value;

  /// Returns the scalar [GQLField] value.
  ///
  /// Throws a [StateError] if the value hasn't been set yet.
  T get value {
    if (_value == null) {
      throw new StateError("This Scalar resolver hasn't been resolved.");
    }

    return _value;
  }

  /// Sets the [GQLField] value.
  set value(T v) => _value = v;
}

/// A GQL collection field.
///
/// It could be applied as a mixin on a [GQLField].
/// This mixin should be used on a field that is a collection
/// (ie. has the GQL List type).
abstract class ScalarCollection<T extends GQLField> implements GQLField {
  List<T> _nodes;
  List<T> _edges;
  int _totalCount;

  /// Returns the node [GQLField] that will be used to resolve each list item.
  GQLField get nodesResolver => null;

  /// Returns the edge [GQLField] that will be used to resolve each list item.
  GQLField get edgesResolver => null;

  /// Returns the nodes collection of [GQLField].
  ///
  /// Throws a [StateError] if the value hasn't been set yet.
  List<T> get nodes {
    if (_nodes == null) {
      throw new StateError(
          "This ScalarCollection resolver hasn't been resolved.");
    }

    return _nodes;
  }

  /// Sets the nodes collection of [GQLField].
  set nodes(List<T> v) => _nodes = v;

  /// Returns the edges collection of [GQLField].
  ///
  /// Throws a [StateError] if the value hasn't been set yet.
  List<T> get edges {
    if (_edges == null) {
      throw new StateError(
          "This ScalarCollection resolver hasn't been resolved.");
    }

    return _edges;
  }

  /// Sets the edges collection of [GQLField].
  set edges(List<T> v) => _edges = v;

  /// Returns the number of resolved items.
  ///
  /// Throws a [StateError] if the value hasn't been set yet.
  int get totalCount {
    if (_totalCount == null) {
      throw new StateError(
          "This ScalarCollection resolver hasn't been resolved.");
    }

    return _totalCount;
  }

  /// Sets the number of resolved items.
  set totalCount(int v) => _totalCount = v;
}
