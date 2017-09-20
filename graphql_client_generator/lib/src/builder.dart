// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client_generator.builder;

import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'settings.dart';
import 'parser.dart';
import 'renderer.dart';

class GQLBuilder extends Builder {
  static const inputExtension = '.graphql';
  static const outputExtension = '.g.dart';

  final Renderer _renderer;
  final GQLParser _parser;

  GQLBuilder(GQLSettings settings)
      : _renderer = new Renderer(const DartEmitter(), new DartFormatter()),
        _parser = new GQLParser(settings);

  @override
  Future build(BuildStep buildStep) async {
    final id = buildStep.inputId;
    final outputId = id.changeExtension(GQLBuilder.outputExtension);

    final gql = await buildStep.readAsString(id);

    final gqlDefinitions = _parser.parse(gql);

    final code = _renderer.buildLibrary(
        outputId: outputId, gqlDefinitions: gqlDefinitions);

    return buildStep.writeAsString(outputId, code);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '${GQLBuilder.inputExtension}': const [outputExtension],
      };

  @override
  String toString() => 'GQLBuilder';
}
