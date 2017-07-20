// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:graphql_client/graphql_client.dart';

class GithubGraphQLSchema implements Schema {
  Viewer viewer;

  GithubGraphQLSchema.fromJSON(Map data)
      : viewer = new Viewer.fromJSON(data['viewer']);

  @override
  String toString() {
    return '''
      query:
        viewer:
${indentLines(viewer.toString(), 4)}
    ''';
  }
}

class Viewer implements Schema {
  GraphQLString login;
  GraphQLString avatarUrl;
  GraphQLString bio;
  GraphQLConnection<Gist> gists;

  Viewer.fromJSON(Map data)
      : login = new GraphQLString(data['login']),
        avatarUrl = new GraphQLString(data['avatarUrl']),
        bio = new GraphQLString(data['bio']),
        gists = new GraphQLConnection<Gist>.fromJSON(data['gists']);

  @override
  String toString() {
    return '''
      login: $login
      avatarUrl: $avatarUrl
      bio: $bio,
      gists:
${indentLines(gists.toString(), 2)}
    ''';
  }
}

class Gist implements Schema {
  GraphQLString name;
  GraphQLString description;

  Gist.fromJSON(Map data)
      : name = new GraphQLString(data['name']),
        description = new GraphQLString(data['description']);

  @override
  String toString() {
    return '''
      name: $name
      description: $description
    ''';
  }
}
