// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client_generator.setting;

class GeneratorSettings {
  final List<String> collectionFields;

  GeneratorSettings({this.collectionFields = const ['nodes', 'edges']});
}
