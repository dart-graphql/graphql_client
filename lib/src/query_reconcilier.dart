// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.src.query_reconcilier;

import 'dart:mirrors';
import 'dart:convert';

reconcileResponse<T>(ClassMirror schemaMirror, String response) {
  Map jsonResponse = JSON.decode(response);

  return schemaMirror
      .newInstance(const Symbol('fromJSON'), [jsonResponse['data']]).reflectee;
}
