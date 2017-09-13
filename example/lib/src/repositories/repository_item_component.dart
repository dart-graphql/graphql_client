// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'repository.dart';

@Component(
  selector: 'gql-repository-item',
  styleUrls: const ['repository_item_component.css'],
  templateUrl: 'repository_item_component.html',
  directives: const [materialDirectives],
  providers: const [],
)
class RepositoryItemComponent {
  @Input()
  Repository repository;

  RepositoryItemComponent();
}
