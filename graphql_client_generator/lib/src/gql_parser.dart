// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';
import 'package:graphql_parser/graphql_parser.dart';

class GQLParser {
  List<Spec> parse(String gql) {
    final parser = new Parser(scan(gql));
    final document = parser.parseDocument();

    print(document);

    return [];
  }
}
