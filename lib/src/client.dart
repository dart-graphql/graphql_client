// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.src.client;

import 'dart:async';
import 'dart:convert';
import 'dart:mirrors';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'query_reconcilier.dart';
import 'schema.dart';

class GraphQLClient {
  Client client;
  String endPoint;
  Logger logger;
  ClassMirror _schemaMirror;

  GraphQLClient({
    this.client,
    this.endPoint,
    this.logger,
  });

  void loadSchema(Type schemaClass) {
    _schemaMirror = reflectClass(schemaClass);
  }

  Future<T> execute<T extends Schema>(
      String gqlQuery, Map<String, dynamic> variables,
      {Map<String, String> headers = const {}}) async {
    if (_schemaMirror == null) {
      throw new StateError("You must load a schema before executing a query");
    }

    logger.finest('Query: $gqlQuery');

    var response = await client.post(
      endPoint,
      headers: headers,
      body: JSON.encode(
        {
          'query': gqlQuery,
          'variables': variables,
        },
      ),
    );

    logger.finest('Response: ${response.body}');

    T reconciliedQuery = reconcileResponse<T>(_schemaMirror, response.body);

    logger.finest('Result: \n$reconciliedQuery');

    return reconciliedQuery;
  }
}
