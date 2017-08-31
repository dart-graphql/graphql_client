#!/bin/bash

# Copyright Thomas Hourlier. All rights reserved.
# Use of this source code is governed by a MIT-style license
# that can be found in the LICENSE file.

# Fast fail the script on failures.
set -e

pushd $PKG
pub upgrade

dartanalyzer --fatal-warnings lib
dartfmt --dry-run --set-exit-if-changed .