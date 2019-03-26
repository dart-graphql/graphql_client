// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.client;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'converter.dart';
import 'exceptions.dart';
import 'graphql.dart';
import 'utils.dart';

/// A GQL client.
class GQLClient {
  /// The HTTP [Client] that the [GQLClient] will use.
  final Client client;

  /// A [Logger] that the [GQLClient] could use to report query execution status.
  final Logger logger;

  /// The GQL endpoint.
  final String endPoint;

  final Map<String, String> defaultHeaders;

  /// Creates a [GQLClient].
  ///
  /// A [client] and a [endPoint] are required.
  GQLClient({
    @required this.client,
    @required this.endPoint,
    this.logger,
    this.defaultHeaders = const {},
  });

  /// Executes and returns the [GQLOperation].
  ///
  /// It sends the query through the network using the [client].
  /// It waits for the response and throw a [GQLException] if the query has errors.
  /// Else, it resolves the query and return it.
  Future<T> execute<T extends GQLOperation>(T operation,
      {Map variables = const {}, Map headers = const {}}) async {
    try {
      final requestBody = {
        'query': GRAPHQL.encode(operation),
        'variables': variables,
        'operationName': operation.gqlName,
      };

      logMessage(
          Level.INFO,
          'Posting GQL query to $endPoint with operation ${operation.gqlName}',
          logger);
      logMessage(Level.FINE, 'with body GQL request to $requestBody', logger);

      final res = await client.post(
        endPoint,
        headers: {}..addAll(defaultHeaders)..addAll(headers),
        body: json.encode(requestBody),
      );

      final data = _parseResponse(res);

      logMessage(Level.INFO, 'Receive response', logger);
      logMessage(Level.FINE, 'with body $data', logger);

      _resolveQuery(operation, data);

      logMessage(Level.INFO, 'GQL query resolved', logger);

      return operation;
    } on ClientException {
      logMessage(Level.INFO, 'Error during the HTTP request', logger);
      rethrow;
    } on GQLException {
      logMessage(
          Level.INFO, 'Error returned by the server in the query', logger);
      rethrow;
    }
  }

  /// Executes and returns one [GQLOperation] from a list of [GQLOperation].
  ///
  /// The [operationName] will determine which query to execute.
  Future<T> executeOperations<T extends GQLOperation>(
      Map<String, GQLOperation> operations, String operationName,
      {Map variables = const <String, dynamic>{},
      Map<String, String> headers}) async {
    final T operation = operations[operationName] as T;

    return execute<T>(operation, headers: headers, variables: variables);
  }

  Map _parseResponse(Response response) {
    final statusCode = response.statusCode;
    final reasonPhrase = response.reasonPhrase;

    if (statusCode < 200 || statusCode >= 400) {
      throw new ClientException('Network Error: $statusCode $reasonPhrase');
    }

    final dynamic jsonResponse = json.decode(response.body);
    if (!(jsonResponse is Map)) {
      // @todo more debug data
      throw Exception('Malformed response from server');
    }

    if (jsonResponse['errors'] != null) {
      final dynamic errors = jsonResponse['errors'];
      if (errors is List) {
        throw GQLException('Error returned by the server in the query', errors.cast<Map>());
      }
      // @todo more debug data
      throw Exception('Malformed response from server');
    }

    if(jsonResponse['data'] != null) {
      final dynamic data = jsonResponse['data'];
      if(data is Map) {
        return data;
      }
    }
    // @todo more debug data
    throw Exception('Malformed response from server');
  }

  void _resolveQuery(GQLField operation, Map data) {
    _resolveFields(operation, data);
    _resolveFragments(operation, data);
  }

  void _resolveFields(GQLField operation, Map data) {
    if (operation is Fields) {
      for (var field in operation.gqlFields) {
        _resolve(field, data);
      }
    }
  }

  void _resolveFragments(GQLField operation, Map data) {
    if (operation is Fragments) {
      for (var fragment in operation.gqlFragments) {
        _resolveFields(fragment, data);
      }
    }
  }

  void _resolve(GQLField resolver, Map data) {
    final key = (resolver is Alias) ? resolver.gqlAlias : resolver.gqlName;
    final fieldData = data[key];

    if (resolver is Scalar) {
      resolver.gqlValue = fieldData;
    } else if (resolver is Collection) {
      final List listValue = fieldData;

      resolver.gqlValue = new List.generate(listValue.length, (index) {
        final clonedResolver = resolver.gqlClone();
        _resolveQuery(clonedResolver, listValue[index]);

        return clonedResolver;
      });
    } else {
      _resolveQuery(resolver, fieldData);
    }
  }
}
