// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:graphql_client/graphql_client.dart';

import 'user_service.dart';
import 'user_info.dart';

@Component(
  selector: 'gql-user-profile',
  styleUrls: const ['user_profile_component.css'],
  templateUrl: 'user_profile_component.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [UserService],
)
class UserProfileComponent implements OnInit {
  UserService _userService;
  final _errorController = new StreamController<String>();

  UserInfo userInfo;

  UserProfileComponent(this._userService);

  @override
  ngOnInit() async {
    try {
      userInfo = await _userService.getUserInformation();
    } on GQLException catch (e) {
      _errorController.add('${e.message}${e.gqlErrors.toString()}');
    }
  }

  @Output()
  Stream<String> get error => _errorController.stream;
}
