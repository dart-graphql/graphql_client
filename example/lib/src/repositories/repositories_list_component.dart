// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:graphql_client/graphql_client.dart';

import 'repository_item_component.dart';
import 'repository_service.dart';
import 'repository.dart';

@Component(
  selector: 'gql-repositories-list',
  styleUrls: const ['repositories_list_component.css'],
  templateUrl: 'repositories_list_component.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
    RepositoryItemComponent
  ],
  providers: const [RepositoryService],
)
class RepositoriesListComponent implements OnInit {
  RepositoryService _repositoryService;
  final _errorController = new StreamController<String>();
  final _selectRepositoryController = new StreamController<Repository>();

  List<Repository> repositories;

  RepositoriesListComponent(this._repositoryService);

  @override
  ngOnInit() async {
    try {
      repositories = await _repositoryService.getRepositoriesList(limit: 20);
    } on GQLException catch (e) {
      _errorController.add('${e.message}${e.gqlErrors.toString()}');
    }
  }

  @Output()
  Stream<String> get error => _errorController.stream;

  @Output()
  Stream<Repository> get select => _selectRepositoryController.stream;

  void selectRepository(Repository repository) {
    _selectRepositoryController.add(repository);
  }
}
