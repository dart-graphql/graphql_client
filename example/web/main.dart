// Copyright (c) 2017, Thomas Hourlier. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:http/browser_client.dart';
import 'package:graphql_client/graphql_client.dart';

import 'package:example/app_component.dart';

void main() {
  const endPoint = 'https://api.github.com/graphql';

  final client = new BrowserClient();

  bootstrap(AppComponent, [
    provide(GQLClient,
        useFactory: () => new GQLClient(client: client, endPoint: endPoint))
  ]);
}
