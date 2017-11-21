// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client_generator.generator;

import 'package:code_builder/code_builder.dart';
import 'package:graphql_parser/graphql_parser.dart';

import 'visitor.dart';
import 'settings.dart';

part 'constants.dart';
part 'field_generator.dart';
part 'generable.dart';

class GQLGenerator {
  final GQLVisitor _visitor;

  GQLGenerator(this._visitor);

  List<Spec> generate(String gql) {
    _visitor.execute(gql);

    return [];
  }
}
