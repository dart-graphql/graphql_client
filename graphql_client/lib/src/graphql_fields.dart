// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

/// GQL nested fields of a field.
///
/// It could be applied as a mixin on a [GQLField].
///
/// Eg.
/// You want to query a gist with its description. The following dart will
/// generate the following GQL query.
/// ```
/// class GistResolver extends Object with Fields implements GQLField {
///   DescriptionResolver description = new DescriptionResolver();
///   @override
///   String get name => 'gist';
///
///   @override
///   List<GQLField> get fields => [description];
/// }
/// ```
/// ```
/// query {
///   gist: {
///     description
///   }
/// }
/// ```
/// Description is a nested field of the `gist` field.
abstract class Fields implements GQLField {
  /// The list of nested fields of this field.
  List<GQLField> get fields => const [];
}
