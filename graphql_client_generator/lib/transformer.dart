// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client_generator.transformer;

import 'package:barback/barback.dart';
import 'package:build_barback/build_barback.dart';

import 'package:graphql_client_generator/src/settings.dart';
import 'package:graphql_client_generator/src/builder.dart';

class GQLTransformer extends BuilderTransformer {
  GQLTransformer.asPlugin(BarbackSettings settings)
      : super(new GQLBuilder(new GQLSettings(
          collectionFields: settings.configuration['collectionFields'],
        )));
}
