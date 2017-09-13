// Copyright (c) 2017, Thomas Hourlier. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

@Component(
  selector: 'gql-error',
  styleUrls: const ['error_component.css'],
  templateUrl: 'error_component.html',
  directives: const [CORE_DIRECTIVES],
  providers: const [],
)
class ErrorComponent {
  @Input()
  String message;
}
