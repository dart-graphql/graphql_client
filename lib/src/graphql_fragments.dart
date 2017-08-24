// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

abstract class Fragments implements GQLField {
  List<GQLFragment> get fragments => const [];
}
