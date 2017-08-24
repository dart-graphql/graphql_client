// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.client;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'graphql_definitions.dart';
import 'converter.dart';
import 'errors.dart';
import 'utils.dart';

class GraphQLClient {
  final Client _client;

  final Logger logger;
  final String endPoint;

  GraphQLClient(this._client, {this.logger, this.endPoint});

  Future<T> execute<T extends GQLOperation>(T operation,
      {Map variables = const {}, Map headers}) async {
    try {
      var requestBody = {
        'query': GRAPHQL.encode(operation),
        'variables': variables,
        'operationName': operation.name,
      };

      logMessage(logger, Level.INFO,
          'Posting GQL query to $endPoint with operation ${operation.name}');
      logMessage(logger, Level.FINE, 'with body GQL request to $requestBody');

      var res = await _client.post(
        endPoint,
        headers: headers,
        body: JSON.encode(requestBody),
      );

      var data = _parseResponse(res.body);

      logMessage(logger, Level.INFO, 'Receive response');
      logMessage(logger, Level.FINE, 'with body $data');

      _resolveQuery(operation, data);

      logMessage(logger, Level.INFO, 'GQL query resolved');

      return operation;
    } on EncoderError {
      logMessage(logger, Level.SHOUT, 'Error when encoding GQL query');
      rethrow;
    } on ClientException {
      logMessage(logger, Level.SHOUT, 'Error during the HTTP request');
      rethrow;
    } on DecoderError {
      logMessage(logger, Level.SHOUT, 'Error when decoding GQL response');
      rethrow;
    } on GQLException {
      logMessage(
          logger, Level.INFO, 'Error returned by the server in the query');
      rethrow;
    } on ResolverError {
      logMessage(logger, Level.SHOUT, 'Error when resolving GQL response');
      rethrow;
    } catch (_) {
      logMessage(logger, Level.SHOUT, 'Unknow error');
      rethrow;
    }
  }

  Future<T> executeOperations<T extends GQLOperation>(
      Map<String, GQLOperation> operations, String operationName,
      {Map variables = const {}, Map headers}) async {
    var operation = operations[operationName];

    return execute(operation, headers: headers, variables: variables);
  }

  Map _parseResponse(String body) {
    try {
      var jsonResponse = JSON.decode(body);
      if (jsonResponse['errors'] != null) {
        throw new GQLException('Error returned by the server in the query',
            jsonResponse['errors']);
      }

      return jsonResponse['data'];
    } on GQLException {
      rethrow;
    } catch (e) {
      throw new DecoderError(
          'Error when decoding the GQL response: ${e.toString()}');
    }
  }

  void _resolveQuery(GQLField operation, Map data) {
    try {
      operation.fields.forEach((GQLField r) => _resolve(r, data));
      operation.fragments.forEach((GQLFragment f) =>
          f.fields.forEach((GQLField o) => _resolve(o, data)));
    } catch (e) {
      throw new ResolverError(
          'Error when resolving the GQL response: ${e.toString()}');
    }
  }

  void _resolve(GQLField resolver, Map data) {
    var key = (resolver is Alias) ? resolver.alias : resolver.name;

    if (resolver is Scalar) {
      resolver.value = data[key];
    } else if (resolver is ScalarCollection) {
      var nodeResolver = resolver.nodesResolver;
      List nodesData = data[key]['nodes'];

      resolver.nodes = new List.generate(
          nodesData.length, (_) => nodeResolver.clone());

      for (int i = 0; i < nodesData.length; i++) {
        _resolveQuery(resolver.nodes[i], nodesData[i]);
      }
    } else {
      _resolveQuery(resolver, data[key]);
    }
  }
}
