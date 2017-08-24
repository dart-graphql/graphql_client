// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

enum OperationType { query, mutation, subscription }

abstract class GQLField {
  String get name;
  GQLField clone();
}

abstract class GQLOperation extends GQLField {
  OperationType get type;
}

abstract class GQLFragment extends GQLField {
  String get onType;
}
