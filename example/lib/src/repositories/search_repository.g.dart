// GENERATED CODE - DO NOT MODIFY BY HAND

// File search_repository.g.dart

// ignore_for_file: public_member_api_docs
// ignore_for_file: slash_for_doc_comments

library example.src.repositories.search_repository;

import 'package:graphql_client/graphql_dsl.dart';

class RepositoryNameFragment extends RepositoryNameFragmentResolver
    implements GQLFragment {
  @override
  String get gqlOnType => 'Repository';
}

class RepositoryNameFragmentResolver extends Object
    with Fields
    implements GQLField {
  NameResolver name = new NameResolver();
  CreatedAtResolver createdAt = new CreatedAtResolver();
  DescriptionResolver description = new DescriptionResolver();
  @override
  String get gqlName => 'RepositoryNameFragment';
  @override
  List<GQLField> get gqlFields => [name, createdAt, description];
  @override
  RepositoryNameFragmentResolver gqlClone() =>
      new RepositoryNameFragmentResolver()
        ..name = name.gqlClone()
        ..createdAt = createdAt.gqlClone()
        ..description = description.gqlClone();
}

class NameResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'name';
  @override
  NameResolver gqlClone() => new NameResolver();
}

class CreatedAtResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'createdAt';
  @override
  CreatedAtResolver gqlClone() => new CreatedAtResolver();
}

class DescriptionResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'description';
  @override
  DescriptionResolver gqlClone() => new DescriptionResolver();
}

class SearchRepositoryQuery extends Object
    with Fields, Arguments
    implements GQLOperation {
  NodeResolver node = new NodeResolver();
  @override
  String get gqlType => queryType;
  @override
  String get gqlName => 'SearchRepository';
  @override
  String get gqlArguments => r'($id:ID!)';
  @override
  List<GQLField> get gqlFields => [node];
  @override
  SearchRepositoryQuery gqlClone() =>
      new SearchRepositoryQuery()..node = node.gqlClone();
}

class NodeResolver extends Object
    with Fields, Arguments, Fragments
    implements GQLField, RepositoryNameFragmentResolver {
  NodeResolver() {
    name = _repositoryNameFragment.name;
    createdAt = _repositoryNameFragment.createdAt;
    description = _repositoryNameFragment.description;
  }
  IdResolver id = new IdResolver();
  NameResolver name;
  CreatedAtResolver createdAt;
  DescriptionResolver description;
  RepositoryNameFragment _repositoryNameFragment = new RepositoryNameFragment();
  @override
  String get gqlName => 'node';
  @override
  String get gqlArguments => r'(id:$id)';
  @override
  List<GQLField> get gqlFields => [id];
  @override
  List<GQLFragment> get gqlFragments => [_repositoryNameFragment];
  @override
  NodeResolver gqlClone() => new NodeResolver()..id = id.gqlClone();
}

class IdResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'id';
  @override
  IdResolver gqlClone() => new IdResolver();
}
