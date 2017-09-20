// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

class GQLSettings {
  final List<String> collectionFields;

  GQLSettings({this.collectionFields = const ['nodes', 'edges']});
}
