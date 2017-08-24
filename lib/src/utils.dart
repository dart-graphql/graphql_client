// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client.utils;

import 'dart:math';

import 'package:logging/logging.dart';

final _rng = new Random();

int getRandomInt([int max = 1000]) => _rng.nextInt(max);

void logMessage([Logger logger, Level logLevel, String message]) {
  if (logger != null) {
    logger.log(logLevel, message);
  }
}
