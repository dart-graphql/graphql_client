// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.client;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'converter.dart';
import 'graphql_definitions.dart';
import 'utils.dart';

class GraphQLClient {
  final Client _client;

  final Logger logger;
  final String endPoint;

  GraphQLClient(this._client, {this.logger, this.endPoint});

  Future<T> execute<T extends GQLOperation>(GQLOperation operation,
      {Map variables = const {}, Map headers}) async {
    var requestBody = {
      'query': GRAPHQL.encode(operation),
      'variables': variables,
      'operationName': operation.name,
    };

    logMessage(logger, Level.INFO,
        'Posting GQL request to $endPoint with operation ${operation.name}');
    logMessage(logger, Level.FINE, 'with body GQL request to $requestBody');

    var res = await _client.post(
      endPoint,
      headers: headers,
      body: JSON.encode(requestBody),
    );

    var data = JSON.decode(res.body)['data'];

    logMessage(logger, Level.INFO, 'Receive response');
    logMessage(logger, Level.FINE, 'with body $data');

    _resolveQuery(operation, data);

    logMessage(logger, Level.INFO, 'GQL query resolved');

    return operation;
  }

  Future<T> executeOperations<T extends GQLOperation>(
      Map<String, GQLOperation> operations, String operationName,
      {Map variables = const {}, Map headers}) async {
    var operation = operations[operationName];

    return execute(operation, headers: headers, variables: variables);
  }

  void _resolve(GQLOperation resolver, Map data) {
    var key = (resolver is Alias) ? resolver.alias : resolver.name;

    if (resolver is Scalar) {
      resolver.value = data[key];
    } else if (resolver is ScalarCollection) {
      var nodeResolver = resolver.nodesResolver;
      List nodesData = data[key]['nodes'];

      resolver.nodes = new List.generate(
          nodesData.length, (_) => nodeResolver.selfFactory());

      for (int i = 0; i < nodesData.length; i++) {
        _resolveQuery(resolver.nodes[i], nodesData[i]);
      }
    } else {
      _resolveQuery(resolver, data[key]);
    }
  }

  void _resolveQuery(GQLOperation operation, Map data) {
    operation.resolvers.forEach((GQLOperation r) => _resolve(r, data));
    operation.fragments.forEach((Fragment f) =>
        f.resolvers.forEach((GQLOperation o) => _resolve(o, data)));
  }
}
