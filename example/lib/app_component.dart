// Copyright (c) 2017, Thomas Hourlier. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'src/user_info/user_profile_component.dart';
import 'src/repositories/repositories_list_component.dart';
import 'src/repositories/repository_detail_component.dart';
import 'src/error/error_component.dart';

import 'src/repositories/repository.dart';

@Component(
  selector: 'gql-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [
    CORE_DIRECTIVES,
    UserProfileComponent,
    RepositoriesListComponent,
    RepositoryDetailComponent,
    ErrorComponent,
  ],
  providers: const [materialProviders],
)
class AppComponent {
  Repository selectedRepository;
  List<String> errorMessages = [];

  void onSelectRepository(Repository repository) {
    selectedRepository = repository;
  }

  void onErrorMessage(String message) {
    errorMessages.add(message);
  }
}
