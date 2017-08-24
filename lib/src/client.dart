// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.client;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'converter.dart';
import 'exceptions.dart';
import 'graphql.dart';
import 'utils.dart';

class GraphQLClient {
  final Client _client;

  final Logger logger;
  final String endPoint;

  GraphQLClient(this._client, {this.logger, this.endPoint});

  Future<T> execute<T extends GQLOperation>(T operation,
      {Map variables = const {}, Map headers}) async {
    try {
      final requestBody = {
        'query': GRAPHQL.encode(operation),
        'variables': variables,
        'operationName': operation.name,
      };

      logMessage(logger, Level.INFO,
          'Posting GQL query to $endPoint with operation ${operation.name}');
      logMessage(logger, Level.FINE, 'with body GQL request to $requestBody');

      final res = await _client.post(
        endPoint,
        headers: headers,
        body: JSON.encode(requestBody),
      );

      final data = _parseResponse(res.body);

      logMessage(logger, Level.INFO, 'Receive response');
      logMessage(logger, Level.FINE, 'with body $data');

      _resolveQuery(operation, data);

      logMessage(logger, Level.INFO, 'GQL query resolved');

      return operation;
    } on ClientException {
      logMessage(logger, Level.INFO, 'Error during the HTTP request');
      rethrow;
    } on GQLException {
      logMessage(
          logger, Level.INFO, 'Error returned by the server in the query');
      rethrow;
    }
  }

  Future<T> executeOperations<T extends GQLOperation>(
      Map<String, GQLOperation> operations, String operationName,
      {Map variables = const {}, Map headers}) async {
    final operation = operations[operationName];

    return execute(operation, headers: headers, variables: variables);
  }

  Map _parseResponse(String body) {
    try {
      final jsonResponse = JSON.decode(body);
      if (jsonResponse['errors'] != null) {
        throw new GQLException('Error returned by the server in the query',
            jsonResponse['errors']);
      }

      return jsonResponse['data'];
    } on GQLException {
      rethrow;
    }
  }

  void _resolveQuery(GQLField operation, Map data) {
    _resolveFields(operation, data);
    _resolveFragments(operation, data);
  }

  void _resolveFields(GQLField operation, Map data) {
    if (operation is Fields) {
      for (var field in operation.fields) {
        _resolve(field, data);
      }
    }
  }

  void _resolveFragments(GQLField operation, Map data) {
    if (operation is Fragments) {
      for (var fragment in operation.fragments) {
        _resolveFields(fragment, data);
      }
    }
  }

  void _resolve(GQLField resolver, Map data) {
    final key = (resolver is Alias) ? resolver.alias : resolver.name;

    if (resolver is Scalar) {
      resolver.value = data[key];
    } else if (resolver is ScalarCollection) {
      final nodeResolver = resolver.nodesResolver;
      final nodesData = data[key]['nodes'];

      resolver.nodes =
          new List.generate(nodesData.length, (_) => nodeResolver.clone());

      for (var i = 0; i < nodesData.length; i++) {
        _resolveQuery(resolver.nodes[i], nodesData[i]);
      }
    } else {
      _resolveQuery(resolver, data[key]);
    }
  }
}
