// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:graphql_client/graphql_client.dart';

import 'user_info.dart';
import 'fetch_user_info.g.dart';

@Injectable()
class UserService {
  GQLClient _gqlClient;

  UserService(this._gqlClient);

  Future<UserInfo> getUserInformation({int avatarSize = 200}) async {
    final res = await _gqlClient.execute(new FetchUserInfoQuery(), variables: {
      'avatarSize': avatarSize,
    });

    return new UserInfo()
      ..login = res.viewer.login.gqlValue
      ..bio = res.viewer.bio.gqlValue
      ..location = res.viewer.location.gqlValue
      ..avatarUrl = res.viewer.avatarUrl.gqlValue;
  }
}
