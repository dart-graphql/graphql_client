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
  String toString() {
    return '{ line: $line, column: $column }';
  }
}

class GQLError implements Exception {
  final String message;
  final List<Location> locations;
  final List<String> path;

  GQLError.fromJSON(Map data)
      : message = data['message'],
        locations = new List.from((data['locations'] as List)
            .map((Map d) => new Location.fromJSON(d))),
        path = data['path'];

  @override
  String toString() {
    return '$message: ${locations.map((Location l) => '[${l.toString()}]').join('')}';
  }
}

class GQLException implements Exception {
  final String message;
  final List<GQLError> gqlError;

  GQLException(this.message, List rawGQLError)
      : gqlError =
            new List.from(rawGQLError.map((Map d) => new GQLError.fromJSON(d)));

  @override
  String toString() {
    return '$message: ${gqlError.map((GQLError e) => '[${e.toString()}]').join('')}';
  }
}

class EncoderError extends StateError {
  EncoderError(String message) : super(message);
}

class DecoderError extends StateError {
  DecoderError(String message) : super(message);
}

class ResolverError extends StateError {
  ResolverError(String message) : super(message);
}
