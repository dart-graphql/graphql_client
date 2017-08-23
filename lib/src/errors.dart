// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.errors;

class EncoderError extends ArgumentError {
  EncoderError(String message) : super(message);
}

class DecoderError extends StateError {
  DecoderError(String message) : super(message);
}

class ResolverError extends StateError {
  ResolverError(String message) : super(message);
}
