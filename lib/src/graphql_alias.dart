// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

//ignore_for_file: avoid_setters_without_getters

part of graphql_client.definitions;

abstract class Alias implements GQLField {
  int _aliasId = getRandomInt();

  set aliasId(String alias) => _aliasId = int.parse(alias.split('_').last);
  String get alias => '${name}_$_aliasId';
}
