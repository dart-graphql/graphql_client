// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

//ignore_for_file: avoid_setters_without_getters

part of graphql_client.definitions;

/// A GQL alias.
///
/// It could be applied as a mixin on a [GQLField].
/// The alias has a unique random ID. It is used to avoid collision during query.
///
/// Eg.
/// You want to query the name 2 times but with 2 different fonts. You could use
/// whatever alias you want in you GQL query / dart query but the generated query
/// will look like:
/// ```
/// query MyQuery {
///   name_37: name(size: SMALL)
///   name_87: name(font: BIG)
/// }
/// ```
abstract class Alias implements GQLField {
  /// The unique random ID of the alias.
  ///
  /// We would prefer to make it private but it seems not possible.
  int aliasId = getRandomInt();

  /// The GQL alias.
  String get alias => '${name}_$aliasId';
}
