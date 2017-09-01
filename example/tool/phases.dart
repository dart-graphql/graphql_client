// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:build_runner/build_runner.dart';
import 'package:graphql_client_generator/graphql_client_generator.dart';

final phases = [
  new BuildAction(
    new GQLBuilder(),
    new PackageGraph.forThisPackage().root.name,
    inputs: const ['**/*.graphql'],
  ),
];
