// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'package:graphql_client/graphql_client.dart';

void main() {
  test('build a basic GQL query', () {
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

    expect(queryBuilt, new isInstanceOf<Query>());
  });
}
