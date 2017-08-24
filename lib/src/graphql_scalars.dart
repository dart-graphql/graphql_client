// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

abstract class Scalar<T> implements GQLField {
  T _value;

  T get value {
    if (_value == null) {
      throw new StateError("This Scalar resolver hasn't been resolved.");
    }

    return _value;
  }

  set value(T v) => _value = v;
}

abstract class ScalarCollection<T extends GQLField> implements GQLField {
  List<T> _nodes;

  GQLField get nodesResolver;

  List<T> get nodes {
    if (_nodes == null) {
      throw new StateError(
          "This ScalarCollection resolver hasn't been resolved.");
    }

    return _nodes;
  }

  set nodes(List<T> v) => _nodes = v;
}
