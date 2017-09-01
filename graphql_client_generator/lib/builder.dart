// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

library graphql_client_generator.generator;

import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

class GQLBuilder extends Builder {
  final DartEmitter _emitter = const DartEmitter();
  final DartFormatter _formatter = new DartFormatter();

  @override
  Future build(BuildStep buildStep) async {
    final id = buildStep.inputId;
    final gql = await buildStep.readAsString(id);

    final animal = new Class((b) => b
      ..name = 'Animal'
      ..extend = const Reference('Organism').toType()
      ..methods.add(new Method.returnsVoid((b) => b
        ..name = 'eat'
        ..lambda = true
        ..body = new Code((b) => b..code = 'print(\'Yum\')'))));
    final code = _formatter.format('${animal.accept(_emitter)}');

    print(gql);

    return buildStep.writeAsString(_copiedAssetId(id), code);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.graphql': const ['.g.dart'],
      };

  @override
  String toString() => 'GQLBuilder';
}

AssetId _copiedAssetId(AssetId inputId) => inputId.changeExtension('.g.dart');
