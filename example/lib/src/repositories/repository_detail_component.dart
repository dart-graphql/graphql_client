// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:graphql_client/graphql_client.dart';

import 'repository.dart';
import 'repository_service.dart';

@Component(
  selector: 'gql-repository-detail',
  styleUrls: const ['repository_detail_component.css'],
  templateUrl: 'repository_detail_component.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [RepositoryService],
)
class RepositoryDetailComponent implements OnInit, OnChanges {
  RepositoryService _repositoryService;
  final _errorController = new StreamController<String>();

  @Input()
  Repository repository;

  RepositoryDetailComponent(this._repositoryService);

  @override
  ngOnInit() async {
    _fetchSelectedRepository(repository);
  }

  @override
  ngOnChanges(Map<String, SimpleChange> changes) async {
    Repository rep = changes['repository'].currentValue;

    _fetchSelectedRepository(rep);
  }

  Future<Repository> _fetchSelectedRepository(Repository repo) async {
    try {
      repository = await _repositoryService.getRepository(repo.id);
    } on GQLException catch (e) {
      _errorController.add('${e.message}${e.gqlErrors.toString()}');
    }

    return repository;
  }

  @Output()
  Stream<String> get error => _errorController.stream;
}
