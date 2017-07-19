// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.src.client;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'query_builder.dart';
import 'query_reconcilier.dart';

class GraphQLClient {
  Client client;
  String endPoint;
  Logger logger;

  GraphQLClient({
    this.client,
    this.endPoint,
    this.logger,
  });

  Future<T> execute<T>(T query,
      {Map<String, String> headers = const {}}) async {
    String gqlQuery = queryBuilder<T>(query);

    logger.finest('Query: $gqlQuery');

    var response = await client.post(endPoint,
        headers: headers,
        body: JSON.encode(
          {'query': gqlQuery},
        ));

    logger.finest('Response: ${response.body}');

    T reconciliedQuery = reconcileResponse<T>(query, response.body);

    logger.finest('Result: \n$reconciliedQuery');

    return reconciliedQuery;
  }
}
