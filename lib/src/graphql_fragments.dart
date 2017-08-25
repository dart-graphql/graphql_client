// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

/// GQL fragments of a field.
///
/// It could be applied as a mixin on a [GQLField].
///
/// Eg.
/// You want to query a gist with its description. The following dart will
/// generate the following GQL query.
/// ```
/// class GistResolver extends Object with Fragments implements GQLField {
///   DescriptionFragment descriptionFragment = new DescriptionFragment();
///   @override
///   String get name => 'gist';
///
///   @override
///   List<GQLField> get fragments => [descriptionFragment];
/// }
/// ```
/// ```
/// query {
///   gist: {
///     ...descriptionFragment
///   }
/// }
/// ```
/// DescriptionFragment is a nested fragment of the `gist` field.
abstract class Fragments implements GQLField {
  /// The list of nested fragments of this field.
  List<GQLFragment> get fragments => const [];
}
