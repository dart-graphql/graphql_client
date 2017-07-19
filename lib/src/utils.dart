// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.src.utils;

/// Indents each line of multi-lines text
String indentLines(String source, int size) {
  const delimiter = '\n';
  return source
      .split(delimiter)
      .map((String s) => "${new List.filled(size, ' ').join('')}$s")
      .join(delimiter);
}
