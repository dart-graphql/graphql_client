// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.src.scalar_types;

/// Represents the String GraphQL type.
class GraphQLString {
  String _value;

  GraphQLString([this._value]);

  String get value {
    if (_value == null) {
      throw new StateError("This value hasn't been requested");
    }

    return _value;
  }
}
