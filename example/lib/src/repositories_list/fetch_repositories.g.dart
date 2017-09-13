// GENERATED CODE - DO NOT MODIFY BY HAND

// File fetch_repositories.g.dart

// ignore_for_file: public_member_api_docs
// ignore_for_file: slash_for_doc_comments

library example.src.repositories_list.fetch_repositories;

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
  String get gqlArguments => r'($limit:Int=5,$nextID:String)';
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
    with Fields, ScalarCollection<NodesResolver, EdgesResolver>, Arguments
    implements GQLField {
  @override
  NodesResolver nodesResolver = new NodesResolver();
  @override
  EdgesResolver edgesResolver = new EdgesResolver();
  @override
  String get gqlName => 'repositories';
  @override
  String get gqlArguments => r'(first:$limit, after:$nextID)';
  @override
  List<GQLField> get gqlFields => [nodesResolver, edgesResolver];
  @override
  RepositoriesResolver gqlClone() => new RepositoriesResolver()
    ..nodesResolver = nodesResolver.gqlClone()
    ..edgesResolver = edgesResolver.gqlClone();
}

class NodesResolver extends Object with Fields implements GQLField {
  NameResolver name = new NameResolver();
  DescriptionResolver description = new DescriptionResolver();
  UrlResolver url = new UrlResolver();
  @override
  String get gqlName => 'nodes';
  @override
  List<GQLField> get gqlFields => [name, description, url];
  @override
  NodesResolver gqlClone() => new NodesResolver()
    ..name = name.gqlClone()
    ..description = description.gqlClone()
    ..url = url.gqlClone();
}

class NameResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'name';
  @override
  NameResolver gqlClone() => new NameResolver();
}

class DescriptionResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'description';
  @override
  DescriptionResolver gqlClone() => new DescriptionResolver();
}

class UrlResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'url';
  @override
  UrlResolver gqlClone() => new UrlResolver();
}

class EdgesResolver extends Object with Fields implements GQLField {
  CursorResolver cursor = new CursorResolver();
  @override
  String get gqlName => 'edges';
  @override
  List<GQLField> get gqlFields => [cursor];
  @override
  EdgesResolver gqlClone() => new EdgesResolver()..cursor = cursor.gqlClone();
}

class CursorResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'cursor';
  @override
  CursorResolver gqlClone() => new CursorResolver();
}
