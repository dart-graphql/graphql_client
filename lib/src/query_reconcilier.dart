// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.src.query_reconcilier;

import 'dart:mirrors';
import 'dart:convert';

T reconcileResponse<T>(T query, String response) {
  Map jsonResponse = JSON.decode(response);
  ClassMirror classMirror = reflect(query).type;

  return classMirror
      .newInstance(const Symbol('fromJSON'), [jsonResponse['data']]).reflectee;
}
