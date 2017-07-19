// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.src.annotations;

import 'dart:mirrors';

/// Marks a GraphQL field with GraphQL arguments.
class GraphQLArguments {
  final String arguments;

  const GraphQLArguments(this.arguments);
}

/// Retrieves a GraphQL annotation on a field.
Object getAnnotation(VariableMirror declaration, Type annotation) {
  for (var instance in declaration.metadata) {
    if (instance.hasReflectee) {
      var reflectee = instance.reflectee;
      if (reflectee.runtimeType == annotation) {
        return reflectee;
      }
    }
  }

  return null;
}