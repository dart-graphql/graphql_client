// GENERATED CODE - DO NOT MODIFY BY HAND

// File fetch_repositories.g.dart

// ignore_for_file: public_member_api_docs
// ignore_for_file: slash_for_doc_comments

library example.src.repositories.fetch_repositories;

import 'package:graphql_client/graphql_dsl.dart';

class FetchUserRepositoriesQuery extends Object
    with Fields, Arguments
    implements GQLOperation {
  ViewerResolver viewer = new ViewerResolver();
  @override
  String get gqlType => queryType;
  @override
  String get gqlName => 'FetchUserRepositories';
  @override
  String get gqlArguments => r'($limit:Int=5,$offset:String)';
  @override
  List<GQLField> get gqlFields => [viewer];
  @override
  FetchUserRepositoriesQuery gqlClone() =>
      new FetchUserRepositoriesQuery()..viewer = viewer.gqlClone();
}

class ViewerResolver extends Object with Fields implements GQLField {
  RepositoriesResolver repositories = new RepositoriesResolver();
  @override
  String get gqlName => 'viewer';
  @override
  List<GQLField> get gqlFields => [repositories];
  @override
  ViewerResolver gqlClone() =>
      new ViewerResolver()..repositories = repositories.gqlClone();
}

class RepositoriesResolver extends Object
    with Fields, Arguments
    implements GQLField {
  NodesResolver nodes = new NodesResolver();
  @override
  String get gqlName => 'repositories';
  @override
  String get gqlArguments => r'(first:$limit, after:$offset)';
  @override
  List<GQLField> get gqlFields => [nodes];
  @override
  RepositoriesResolver gqlClone() =>
      new RepositoriesResolver()..nodes = nodes.gqlClone();
}

class NodesResolver extends Object
    with Fields, Collection<NodesResolver>
    implements GQLField {
  IdResolver id = new IdResolver();
  NameResolver name = new NameResolver();
  @override
  String get gqlName => 'nodes';
  @override
  List<GQLField> get gqlFields => [id, name];
  @override
  NodesResolver gqlClone() => new NodesResolver()
    ..id = id.gqlClone()
    ..name = name.gqlClone();
}

class IdResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'id';
  @override
  IdResolver gqlClone() => new IdResolver();
}

class NameResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'name';
  @override
  NameResolver gqlClone() => new NameResolver();
}
