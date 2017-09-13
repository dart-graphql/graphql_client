// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:graphql_client/graphql_client.dart';

import 'repository.dart';
import 'fetch_repositories.g.dart';
//import 'search_repository.g.dart';

@Injectable()
class RepositoryService {
  GQLClient _gqlClient;

  RepositoryService(this._gqlClient);

//  Future<Repository> getRepository(String id) async {
//    final res =
//        await _gqlClient.execute(new SearchRepositoryQuery(), variables: {
//      'id': id,
//    });
//
//    return new Repository()
//      ..id = res.node.id.gqlValue
//      ..name = res.node.name.gqlValue
//      ..createdAt = res.node.createdAt.gqlValue
//      ..description = res.node.description.gqlValue;
//  }

  Future<List<Repository>> getRepositoriesList(
      {int limit, String offset}) async {
    final res =
        await _gqlClient.execute(new FetchUserRepositoriesQuery(), variables: {
      'limit': limit,
      'offset': offset,
    });
    final repositoriesList = res.viewer.repositories.nodes.gqlValue;

    return new List.generate(
        repositoriesList.length,
        (index) => new Repository()
          ..id = repositoriesList[index].id.gqlValue
          ..name = repositoriesList[index].name.gqlValue);
  }
}
