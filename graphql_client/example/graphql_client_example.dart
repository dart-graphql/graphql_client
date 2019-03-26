// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'package:graphql_client/graphql_client.dart';

import 'queries_examples.dart';

Future main() async {
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen((rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });

  const endPoint = 'https://api.github.com/graphql';
  final apiToken = Platform.environment['GQL_GITHUB_TOKEN'];

  final client = new Client();
  final logger = new Logger('GQLClient');
  final graphQLClient = new GQLClient(
    client: client,
    logger: logger,
    endPoint: endPoint,
  );

  final query = new LoginQuery();
  final mutation = new AddTestCommentMutation();

  try {
    print('\n\n===================== TEST 1 =====================');

    final queryRes = await graphQLClient.execute(
      query,
      variables: <String, String>{'issueId': 'MDU6SXNzdWUyNDQzNjk1NTI', 'body': 'Test issue 2'},
      headers: <String, String>{
        'Authorization': 'bearer $apiToken',
      },
    );

    print('=== . ===');
    print(queryRes.viewer.login.gqlValue);
    print(queryRes.viewer.bio.gqlValue);
    print(queryRes.viewer.bio2.gqlValue);

    print('=== .repository ===');
    print(queryRes.viewer.repository.createdAt.gqlValue);
    print(queryRes.viewer.repository.description.gqlValue);
    print(queryRes.viewer.repository.id.gqlValue);
    print(queryRes.viewer.repository.repoName.gqlValue);

    print('=== .gist ===');
    print(queryRes.viewer.gist.description.gqlValue);

    print('=== .repositories ===');
    // @todo get rid of `cast()`
    for (NodesResolver n in queryRes.viewer.repositories.nodes.gqlValue.cast()) {
      print(n.repoName.gqlValue);
    }
  } on GQLException catch (e) {
    print(e.message);
    print(e.gqlErrors);
  } finally {
    print('=================== END TEST 1 ===================\n\n');
  }

  try {
    print('\n\n===================== TEST 2 =====================');

    final mutationRes = await graphQLClient.execute(
      mutation,
      variables: <String, String>{'issueId': 'MDU6SXNzdWUyNDQzNjk1NTI', 'body': 'Test issue '},
      headers: <String, String>{
        'Authorization': 'bearer $apiToken',
      },
    );

    print('=== .body ===');
    print(mutationRes.addComment.commentEdge.node.body.gqlValue);
  } on GQLException catch (e) {
    print(e.message);
    print(e.gqlErrors);
  } finally {
    print('=================== END TEST 2 ===================\n\n');
  }

  try {
    print('\n\n===================== TEST 3 =====================');

    await graphQLClient.execute(
      mutation,
      variables: <String, String>{'issueId': 'efwef', 'body': 'Test issue'},
      headers: <String, String>{
        'Authorization': 'bearer $apiToken',
      },
    );
  } on GQLException catch (e) {
    print(e.message);
    print(e.gqlErrors);
    print(e.gqlErrors.first);
  } finally {
    print('=================== END TEST 3 ===================\n\n');
  }
}
