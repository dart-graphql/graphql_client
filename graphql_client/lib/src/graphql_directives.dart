// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of graphql_client.definitions;

/// The GQL directive: `include`
const String includeDirective = 'include';

/// The GQL directive: `skip`
const String skipDirective = 'skip';

/// A GraphQL directive.
///
/// It could be applied as a mixin on a [GQLField].
/// Eg.
/// A GQL query with a field using an directive.
/// ```
/// query MyQuery {
///   name @include(if: true)
/// }
/// ```
abstract class Directives implements GQLField {
  /// The directive type.
  ///
  /// Should be [includeDirective] or [skipDirective]
  String get directive;

  /// The GQL directive.
  String get directiveValue;
}
