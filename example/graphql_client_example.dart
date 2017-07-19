// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:http/http.dart';

import 'package:graphql_client/graphql_client.dart';

main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  const endpoint = 'https://api.github.com/graphql';
  const apiToken = '3471ce3702656663ccdbe71a5868da59d344e783';

  final log = new Logger('graphql_client_example');
  final client = new Client();
  Response response;

  log.finest('Starting POST request on $endpoint');

  Query queryBuilt = new Query(
    viewer: new Viewer(
      avatarUrl: new GraphQLString(),
      login: new GraphQLString(),
      bio: new GraphQLString(),
      gists: new GraphQLConnection<Gist>(
        nodes: new Gist(
          name: new GraphQLString(),
          description: new GraphQLString(),
        ),
      ),
    ),
  );

  String gqlQuery = queryBuilder(queryBuilt);

  log.finest('Query sent: $gqlQuery');

  response = await client.post(endpoint,
      headers: {'Authorization': 'bearer $apiToken'},
      body: JSON.encode({'query': gqlQuery}));

  log
    ..finest('Response status: ${response.statusCode}')
    ..finest('Response body: ${response.body}');

  Query resolvedResponse = reconcileResponse(response.body);

  log.finest('Resolved response: \n$resolvedResponse');
  log.finest('Viewer login: ${resolvedResponse.viewer.login.value}');
  log.finest('Viewer avatarUrl: ${resolvedResponse.viewer.bio.value}');
}
