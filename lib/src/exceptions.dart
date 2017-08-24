// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.errors;

class Location {
  final int line;
  final int column;

  Location.fromJSON(Map data)
      : line = data['line'],
        column = data['column'];

  @override
  String toString() => '{ line: $line, column: $column }';
}

class GQLError implements Exception {
  final String message;
  final List<Location> locations;
  final List<String> path;

  GQLError.fromJSON(Map data)
      : message = data['message'],
        locations = new List.from(
            (data['locations']).map((d) => new Location.fromJSON(d))),
        path = data['path'];

  @override
  String toString() =>
      '$message: ${locations.map((l) => '[${l.toString()}]').join('')}';
}

class GQLException implements Exception {
  final String message;
  final List<GQLError> gqlError;

  GQLException(this.message, List rawGQLError)
      : gqlError =
            new List.from(rawGQLError.map((d) => new GQLError.fromJSON(d)));

  @override
  String toString() =>
      '$message: ${gqlError.map((e) => '[${e.toString()}]').join('')}';
}
