// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

abstract class Fields implements GQLField {
  List<GQLField> get fields => const [];
}
