// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.client;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'converter.dart';
import 'exceptions.dart';
import 'graphql.dart';
import 'utils.dart';

/// A GQL client.
class GQLClient {
  /// The HTTP [Client] the the [GQLClient] will use.
  final Client client;

  /// A [Logger] that the [GQLClient] could use to report query execution status.
  final Logger logger;

  /// The GQL endpoint.
  final String endPoint;

  /// Creates a [GQLClient].
  ///
  /// A [client] and a [endPoint] are required.
  GQLClient({
    @required this.client,
    @required this.endPoint,
    this.logger,
  });

  /// Executes and returns the [GQLOperation].
  ///
  /// It sends the query through the network using the [client].
  /// It waits for the response and throw a [GQLException] if the query has errors.
  /// Else, it resolves the query and return it.
  Future<T> execute<T extends GQLOperation>(T operation,
      {Map variables = const <String, dynamic>{},
      Map<String, String> headers}) async {
    try {
      final requestBody = <String, dynamic>{
        'operationName': operation.name,
        'variables': variables,
        'query': GRAPHQL.encode(operation),
      };

      logMessage(
          Level.INFO,
          'Posting GQL query to $endPoint with operation ${operation.name}',
          logger);
      logMessage(Level.FINE, 'with body GQL request to $requestBody', logger);


      final Request httpReq = Request('post', Uri.parse(endPoint));
      httpReq.headers.addAll(<String, String>{
        'accept': '*/*',
        'content-type': 'application/json; charset=utf-8',
      });
      httpReq.headers.addAll(headers);
      httpReq.body = json.encode(requestBody);

      final StreamedResponse res = await client.send(httpReq);

      final data = await _parseResponse(res);
      assert(data != null);

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

  Future<Map> _parseResponse(StreamedResponse response) async {
    final statusCode = response.statusCode;
    final reasonPhrase = response.reasonPhrase;

    if (statusCode < 200 || statusCode >= 400) {
      throw ClientException('Network Error: $statusCode $reasonPhrase');
    }

    // @todo limit bodyBytes
    final Encoding encoding = _determineEncodingFromResponse(response);
    final Uint8List responseByte = await response.stream.toBytes();
    final String decodedBody = encoding.decode(responseByte);
    final dynamic jsonResponse = json.decode(decodedBody);
    if (jsonResponse is! Map) {
      // @todo more debug data
      throw Exception('Malformed response from server');
    }

    if (jsonResponse['errors'] != null) {
      final dynamic errors = jsonResponse['errors'];
      if (errors is List) {
        throw GQLException(
            'Error returned by the server in the query', errors.cast<Map>());
      }
      // @todo more debug data
      throw Exception('Malformed response from server');
    }

    if (jsonResponse['data'] != null) {
      final dynamic data = jsonResponse['data'];
      if (data is Map) {
        return data;
      }
    }
    // @todo more debug data
    throw Exception('Malformed response from server');
  }

  void _resolveQuery(GQLField operation, Map data) {
    assert(data != null);
    _resolveFields(operation, data);
    _resolveFragments(operation, data);
  }

  void _resolveFields(GQLField operation, Map data) {
    assert(data != null);
    if (operation is Fields) {
      for (var field in operation.fields) {
        _resolve(field, data);
      }
    }
  }

  void _resolveFragments(GQLField operation, Map data) {
    assert(data != null);
    if (operation is Fragments) {
      for (var fragment in operation.fragments) {
        _resolveFields(fragment, data);
      }
    }
  }

  void _resolve(GQLField resolver, Map data) {
    final key = (resolver is Alias) ? resolver.alias : resolver.name;
    final dynamic fieldData = data[key];

    if (resolver is Scalar) {
      resolver.value = fieldData;
    } else if (fieldData != null && resolver is ScalarCollection) {
      final nodeResolver = resolver.nodesResolver;
      final edgeResolver = resolver.edgesResolver;
      final nodesData = (fieldData['nodes'] as List<dynamic>);
      final edgesData = (fieldData['edges'] as List<dynamic>);
      final totalCountData = fieldData['totalCount'] as int;

      resolver.totalCount = totalCountData;

      if (nodeResolver != null) {
        resolver.nodes =
            List.generate(nodesData.length, (_) => nodeResolver.clone());

        for (int i = 0; i < nodesData.length; i++) {
          final data = nodesData[i] as Map;
          assert(data != null);
          final rNodes = resolver.nodes[i];
          _resolveQuery(rNodes, data);
        }
      }

      if (edgeResolver != null) {
        resolver.edges =
            List.generate(edgesData.length, (_) => edgeResolver.clone());

        for (var i = 0; i < edgesData.length; i++) {
          final data = edgesData[i] as Map;
          assert(data != null);
          _resolveQuery(resolver.edges[i], data);
        }
      }
    } else if (fieldData != null && fieldData is Map && resolver is Fields) {
        _resolveQuery(resolver, fieldData);
    } else {
      throw Exception('nooooo');
      // @todo what else
    }
  }
}

/// Returns the charset encoding for the given response.
///
/// The default fallback encoding is set to UTF-8 according to the IETF RFC4627 standard
/// which specifies the application/json media type:
///   "JSON text SHALL be encoded in Unicode. The default encoding is UTF-8."
Encoding _determineEncodingFromResponse(BaseResponse response,
    [Encoding fallback = utf8]) {
  final String contentType = response.headers['content-type'];

  if (contentType == null) {
    return fallback;
  }

  final MediaType mediaType = MediaType.parse(contentType);
  final String charset = mediaType.parameters['charset'];

  if (charset == null) {
    return fallback;
  }

  final Encoding encoding = Encoding.getByName(charset);

  return encoding == null ? fallback : encoding;
}
