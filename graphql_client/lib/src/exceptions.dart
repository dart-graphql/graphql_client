// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.errors;

/// A location where a [GQLError] appears.
class Location {
  /// The line of the error in the query.
  final int line;

  /// The column of the error in the query.
  final int column;

  /// Constructs a [Location] from a JSON map.
  Location.fromJSON(Map data)
      : line = data['line'] as int,
        column = data['column'] as int;

  @override
  String toString() => '{ line: $line, column: $column }';
}

/// A GQL error (returned by a GQL server).
class GQLError {
  /// The message of the error.
  final String message;

  /// Locations where the error appear.
  final List<Location> locations;

  /// The path of the field in error.
  final List<String> path;

  /// Constructs a [GQLError] from a JSON map.
  GQLError.fromJSON(Map data)
      : message = data['message'] as String,
        locations = List<Location>.from(
          (data['locations'] as List<dynamic>).cast<Map>().map<Location>((d) => Location.fromJSON(d)),
        ),
        path = (data['path'] as List<dynamic>).cast<String>();

  @override
  String toString() =>
      '$message: ${locations.map((l) => '[${l.toString()}]').join('')}';
}

/// A Exception that is raised if the GQL response has a [GQLError].
class GQLException implements Exception {
  /// The Exception message.
  final String message;

  /// The list of [GQLError] in the response.
  final List<GQLError> gqlErrors;

  /// Creates a [GQLException].
  ///
  /// It requires a message and a JSON list from a GQL response
  /// (returned by a GQL server).
  GQLException(this.message, List<Map<dynamic, dynamic>> rawGQLError)
      : gqlErrors =
            List<GQLError>.from(rawGQLError.map<GQLError>((d) => GQLError.fromJSON(d)));

  @override
  String toString() =>
      '$message: ${gqlErrors.map((e) => '[${e.toString()}]').join('')}';
}
