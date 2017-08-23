// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

enum OperationType { query, mutation }

abstract class GQLOperation {
  String get name;
  OperationType get type;
  List<GQLOperation> get resolvers;
  List<Fragment> get fragments;

  GQLOperation selfFactory();
}

abstract class Fragment extends GQLOperation {
  String get onType;
}
