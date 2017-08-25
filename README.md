# graphql_client [![Build Status](https://travis-ci.org/hourliert/graphql_client.svg?branch=master)](https://travis-ci.org/hourliert/graphql_client)

GraphQL Client written in Dart 🎯.

It relies on the [dart http client][http] to send GQL queries. As the **http** client, tt's platform-independent, 
and can be used on the command-line, browser and flutter.
It has a custom DSL to write GQL queries and will have soon a code generator converting GQL queries to this DSL.
Stay tuned 🎤. If you want to help, please check [this doc][code_generator].

## Usage

For now, you have to write your GQL queries with the `graphql_client` DSL. You will be able to
convert GQL queries into this DSL soon using a dart transformer.

The following code sample allows you to retrieve the current github user bio using the Github
GraphQL API v4.

```dart
import 'dart:async';
import 'dart:io'; // Optional because I am reading env variables.

import 'package:http/http.dart';
import 'package:logging/logging.dart'; // Optional
import 'package:graphql_client/graphql_client.dart';
import 'package:graphql_client/graphql_dsl.dart';

/**
 * Define a custom GQL query.
 *
 * The corresponding GQL is :
 * query ViewerBioQuery {
 *   viewer {
 *     bio
 *   }
 * }
 */

class ViewerBioQuery extends Object with Fields implements GQLOperation {
  ViewerResolver viewer = new ViewerResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'ViewerBioQuery';

  @override
  List<GQLField> get fields => [viewer];

  @override
  ViewerBioQuery clone() => new ViewerBioQuery()..viewer = viewer.clone();
}

class ViewerResolver extends Object with Fields implements GQLField {
  BioResolver bio = new BioResolver();

  @override
  String get name => 'viewer';

  @override
  List<GQLField> get fields => [bio];

  @override
  ViewerResolver clone() => new ViewerResolver()..bio = bio.clone();
}

class BioResolver extends Object with Scalar<String> implements GQLField {
  @override
  String get name => 'bio';

  @override
  BioResolver clone() => new BioResolver();
}

Future main() async {
  Logger.root // Optional
    ..level = Level.ALL
    ..onRecord.listen((rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    
  const endPoint = 'https://api.github.com/graphql';
  final apiToken = Platform.environment['GITHUBQL_TOKEN'];

  final client = new Client();
  final logger = new Logger('GQLClient'); // Optional.
  final graphQLClient = new GQLClient(
    client: client,
    logger: logger,
    endPoint: endPoint,
  );

  final query = new ViewerBioQuery();

  try {
    final queryRes = await graphQLClient.execute(
      query,
      variables: {},
      headers: {
        'Authorization': 'bearer $apiToken',
      },
    );

    print(queryRes.viewer.bio.value); // => 'My awesome Github Bio!'
  } on GQLException catch (e) {
    print(e.message);
    print(e.gqlErrors);
  }
}

```

## Roadmap

You can find it [here][roadmap].

[roadmap]: https://github.com/hourliert/graphql_client/blob/master/ROADMAP.md
[http]: https://pub.dartlang.org/packages/http
[code_generator]: https://github.com/hourliert/graphql_client/blob/master/doc/code_generator.md