// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

/// The GQL type: `query`,
const String queryType = 'query';

/// The GQL type: `mutation`,
const String mutationType = 'mutation';

/// The GQL type: `subscription`,
///
/// WARNING: This is not supported.
const String subscriptionType = 'subscription';

/// A GQL field.
///
/// Eg.
/// In the following query, `name` is a GQL field.
/// query {
///   name
/// }
///
/// It could be "pimped" with mixin: [Fields], [Fragments], [Arguments] and [Alias].
abstract class GQLField {
  /// The GQL field name.
  String get name;

  /// Returns a perfect copy of the field.
  ///
  /// This is mandatory when doing query resolving using GQL collections.
  GQLField clone();
}

/// A GQL operation.
///
/// This could be whether a: [queryType], [mutationType] or [subscriptionType].
abstract class GQLOperation extends GQLField {
  /// The query type.
  String get type;
}

/// A GQL Fragment.
///
/// Eg.
/// The following dart code will generate a GQL fragment.
/// ```
/// /// class DescriptionFragmentResolver extends Object
///     with Fields
///     implements GQLField {
///   DescriptionResolver description = new DescriptionResolver();
///
///   @override
///   String get name => 'GistDescriptionFragment';
///
///   @override
///   List<GQLField> get fields => [description];
/// }
/// class DescriptionFragment extends DescriptionFragmentResolver implements GQLFragment {
///   @override
///   String get onType => 'Gist';
/// }
/// ```
/// ```
/// fragment GistDescriptionFragment on Gist {
///   description
/// }
/// ```
abstract class GQLFragment extends GQLField {
  /// The type the fragment depends on.
  String get onType;
}
