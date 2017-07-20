// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'package:graphql_client/graphql_client.dart';

import 'github_declarations.dart';

main() async {
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });

  const endPoint = 'https://api.github.com/graphql';
  var apiToken = Platform.environment['GITHUBQL_TOKEN'];

  final client = new Client();
  final logger = new Logger('GraphQLClient');
  final graphQLClient = new GraphQLClient(
    client: client,
    logger: logger,
    endPoint: endPoint,
    schema: new GithubGraphQLSchema(),
  );

  //language=GraphQL
  String gqlQuery = '''
    query {
      viewer {
        avatarUrl(size: 200)
        login
        bio
        gists(first: 5) {
          nodes {
            name
            description
          }
        }
      }
    }
  ''';

  GithubGraphQLSchema res = await graphQLClient.execute(
    gqlQuery,
    headers: {'Authorization': 'bearer $apiToken'},
  );

  print(res.viewer.avatarUrl.value);
}
