// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:graphql_client/graphql_dsl.dart';

// ignore_for_file: public_member_api_docs
// ignore_for_file: slash_for_doc_comments

/**
 * ************************
 * ************************
 * ************************
 * **** GQL OPERATIONS ****
 * ************************
 * ************************
 * ************************
 */

class LoginQuery extends Object with Fields implements GQLOperation {
  ViewerResolver viewer = new ViewerResolver();

  @override
  String get gqlType => queryType;

  @override
  String get gqlName => 'LoginQuery';

  @override
  List<GQLField> get gqlFields => [viewer];

  @override
  LoginQuery gqlClone() => new LoginQuery()..viewer = viewer.gqlClone();
}

class AddTestCommentMutation extends Object
    with Arguments, Fields
    implements GQLOperation {
  AddCommentMutation addComment = new AddCommentMutation();

  @override
  String get gqlType => mutationType;

  @override
  String get gqlName => 'AddTestCommentMutation';

  @override
  String get gqlArguments => '(\$issueId: ID!, \$body: String!)';

  @override
  List<GQLField> get gqlFields => [addComment];

  @override
  AddTestCommentMutation gqlClone() =>
      new AddTestCommentMutation()..addComment = addComment.gqlClone();
}

/**
 * ************************
 * ************************
 * ************************
 * ****** FRAGMENTS *******
 * ************************
 * ************************
 * ************************
 */

class RepositoryDescriptiveFragment
    extends RepositoryDescriptiveFragmentResolver implements GQLFragment {
  @override
  String get gqlOnType => 'Repository';
}

class RepositoryIdFragment extends RepositoryIdFragmentResolver
    implements GQLFragment {
  @override
  String get gqlOnType => 'Repository';
}

class GistDescriptiveFragment extends GistDescriptiveFragmentResolver
    implements GQLFragment {
  @override
  String get gqlOnType => 'Gist';
}

/**
 * ************************
 * ************************
 * ************************
 * ******** FIELDS ********
 * ************************
 * ************************
 * ************************
 */

class AddCommentMutation extends Object
    with Arguments, Fields
    implements GQLField {
  CommentEdgeResolver commentEdge = new CommentEdgeResolver();

  @override
  String get gqlName => 'addComment';

  @override
  String get gqlArguments => '(input: {subjectId: \$issueId, body: \$body})';

  @override
  List<GQLField> get gqlFields => [commentEdge];

  @override
  AddCommentMutation gqlClone() =>
      new AddCommentMutation()..commentEdge = commentEdge.gqlClone();
}

class CommentEdgeResolver extends Object
    with Alias, Fields
    implements GQLField {
  NodeResolver node = new NodeResolver();

  @override
  String get gqlName => 'commentEdge';

  @override
  List<GQLField> get gqlFields => [node];

  @override
  CommentEdgeResolver gqlClone() => new CommentEdgeResolver()
    ..gqlAliasId = gqlAliasId
    ..node = node.gqlClone();
}

class NodeResolver extends Object with Alias, Fields implements GQLField {
  BodyResolver body = new BodyResolver();

  @override
  String get gqlName => 'node';

  @override
  List<GQLField> get gqlFields => [body];

  @override
  NodeResolver gqlClone() => new NodeResolver()
    ..gqlAliasId = gqlAliasId
    ..body = body.gqlClone();
}

class ViewerResolver extends Object with Alias, Fields implements GQLField {
  GistResolver gist = new GistResolver();
  RepositoryResolver repository = new RepositoryResolver();
  RepositoriesResolver repositories = new RepositoriesResolver();
  LoginResolver login = new LoginResolver();
  BioResolver bio = new BioResolver();
  BioResolver bio2 = new BioResolver();

  @override
  String get gqlName => 'viewer';

  @override
  List<GQLField> get gqlFields =>
      [repositories, gist, repository, login, bio, bio2];

  @override
  ViewerResolver gqlClone() => new ViewerResolver()
    ..gqlAliasId = gqlAliasId
    ..gist = gist.gqlClone()
    ..repository = repository.gqlClone()
    ..repositories = repositories.gqlClone()
    ..login = login.gqlClone()
    ..bio = bio.gqlClone()
    ..bio2 = bio2.gqlClone();
}

class NodesResolver extends Object with Fields implements GQLField {
  NameResolver repoName = new NameResolver();

  @override
  String get gqlName => 'nodes';

  @override
  List<GQLField> get gqlFields => [repoName];

  @override
  NodesResolver gqlClone() =>
      new NodesResolver()..repoName = repoName.gqlClone();
}

class RepositoryResolver extends Object
    with Arguments, Alias, Fields, Fragments
    implements
        RepositoryDescriptiveFragmentResolver,
        RepositoryIdFragmentResolver,
        GQLField {
  final RepositoryDescriptiveFragment _descriptiveRepositoryFragment =
      new RepositoryDescriptiveFragment();
  final RepositoryIdFragment _idRepositoryFragment = new RepositoryIdFragment();

  CreatedAtResolver createdAt = new CreatedAtResolver();

  @override
  DescriptionResolver description;

  @override
  NameResolver repoName;

  @override
  IdResolver id;

  RepositoryResolver() {
    description = _descriptiveRepositoryFragment.description;
    repoName = _descriptiveRepositoryFragment.repoName;
    id = _idRepositoryFragment.id;
  }

  @override
  String get gqlName => 'repository';

  @override
  String get gqlArguments => '(name: "graphql_client")';

  @override
  List<GQLField> get gqlFields => [createdAt];

  @override
  List<GQLFragment> get gqlFragments =>
      [_descriptiveRepositoryFragment, _idRepositoryFragment];

  RepositoryResolver gqlClone() => new RepositoryResolver()
    ..gqlAliasId = gqlAliasId
    ..description = description.gqlClone()
    ..repoName = repoName.gqlClone()
    ..id = id.gqlClone()
    ..createdAt = createdAt.gqlClone();
}

class GistResolver extends Object
    with Arguments, Alias, Fields, Fragments
    implements GistDescriptiveFragmentResolver, GQLField {
  final GistDescriptiveFragment _descriptiveGistFragment =
      new GistDescriptiveFragment();

  @override
  DescriptionResolver description;

  GistResolver() {
    description = _descriptiveGistFragment.description;
  }

  @override
  String get gqlName => 'gist';

  @override
  String get gqlArguments => '(name: "e675723fc16a5b9bd4d1")';

  @override
  List<GQLFragment> get gqlFragments => [_descriptiveGistFragment];

  @override
  GistResolver gqlClone() => new GistResolver()
    ..gqlAliasId = gqlAliasId
    ..description = description.gqlClone();
}

class GistDescriptiveFragmentResolver extends Object
    with Fields
    implements GQLField {
  DescriptionResolver description = new DescriptionResolver();

  @override
  String get gqlName => 'GistDescriptiveFragment';

  @override
  List<GQLField> get gqlFields => [description];

  @override
  GistDescriptiveFragmentResolver gqlClone() =>
      new GistDescriptiveFragmentResolver()
        ..description = description.gqlClone();
}

class RepositoryDescriptiveFragmentResolver extends Object
    with Fields
    implements GQLField {
  DescriptionResolver description = new DescriptionResolver();
  NameResolver repoName = new NameResolver();

  @override
  String get gqlName => 'RepositoryDescriptiveFragment';

  @override
  List<GQLField> get gqlFields => [description, repoName];

  @override
  RepositoryDescriptiveFragmentResolver gqlClone() =>
      new RepositoryDescriptiveFragmentResolver()
        ..description = description.gqlClone()
        ..repoName = repoName.gqlClone();
}

class RepositoryIdFragmentResolver extends Object
    with Fields
    implements GQLField {
  IdResolver id = new IdResolver();

  @override
  String get gqlName => 'RepositoryIdFragment';

  @override
  List<GQLField> get gqlFields => [id];

  @override
  RepositoryIdFragmentResolver gqlClone() =>
      new RepositoryIdFragmentResolver()..id = id.gqlClone();
}

/**
 * *****************************
 * *****************************
 * *****************************
 * *** COLLECTIONS RESOLVERS ***
 * *****************************
 * *****************************
 * *****************************
 */

class RepositoriesResolver extends Object
    with Arguments, Alias, ScalarCollection<NodesResolver, Null>, Fields
    implements GQLField {
  @override
  NodesResolver nodesResolver = new NodesResolver();

  @override
  String get gqlName => 'repositories';

  @override
  String get gqlArguments => '(first: 5)';

  @override
  List<GQLField> get gqlFields => [nodesResolver];

  @override
  RepositoriesResolver gqlClone() => new RepositoriesResolver()
    ..gqlAliasId = gqlAliasId
    ..nodesResolver = nodesResolver.gqlClone();
}

/**
 * ************************
 * ************************
 * ************************
 * *** SCALAR RESOLVERS ***
 * ************************
 * ************************
 * ************************
 */

class LoginResolver extends Object
    with Scalar<String>, Alias, Directives
    implements GQLField {
  @override
  String get gqlName => 'login';

  @override
  String get gqlDirectives => '@include(if: false)';

  @override
  LoginResolver gqlClone() => new LoginResolver()..gqlAliasId = gqlAliasId;
}

class BioResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get gqlName => 'bio';

  @override
  BioResolver gqlClone() => new BioResolver()..gqlAliasId = gqlAliasId;
}

class DescriptionResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get gqlName => 'description';

  @override
  DescriptionResolver gqlClone() =>
      new DescriptionResolver()..gqlAliasId = gqlAliasId;
}

class NameResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get gqlName => 'name';

  @override
  NameResolver gqlClone() => new NameResolver()..gqlAliasId = gqlAliasId;
}

class CreatedAtResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get gqlName => 'createdAt';

  @override
  CreatedAtResolver gqlClone() =>
      new CreatedAtResolver()..gqlAliasId = gqlAliasId;
}

class IdResolver extends Object with Scalar<String>, Alias implements GQLField {
  @override
  String get gqlName => 'id';

  @override
  IdResolver gqlClone() => new IdResolver()..gqlAliasId = gqlAliasId;
}

class BodyResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get gqlName => 'body';

  @override
  BodyResolver gqlClone() => new BodyResolver()..gqlAliasId = gqlAliasId;
}
