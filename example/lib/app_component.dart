// Copyright (c) 2017, Thomas Hourlier. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:graphql_client/graphql_client.dart';

import 'fetch_login.g.dart';

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [materialDirectives],
  providers: const [materialProviders],
)
class AppComponent implements OnInit {
  GQLClient _gqlClient;

  String username;

  AppComponent(this._gqlClient);

  @override
  ngOnInit() async {
    final res = await _gqlClient.execute(
      new FetchLoginQuery(),
      headers: {
        'Authorization': 'bearer 032617f107dbefc84035adb7cf9c404c86d4013e',
      },
    );

    username = res.viewer.login.value;
  }
}
