// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.utils;

import 'dart:math';

import 'package:logging/logging.dart';

final _rng = new Random();

/// Returns a random number.
///
/// The number will be between 0 and [max] - 1.
int getRandomInt([int max = 1000]) => _rng.nextInt(max);

/// Logs a string according to a log level.
///
/// If [logger] is defined, it will log the [message] to the output
/// with the log [logLevel].
void logMessage(Level logLevel, String message, [Logger logger]) {
  if (logger != null) {
    logger.log(logLevel, message);
  }
}
