// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:graphql_client/graphql_client.dart';

/**
 * ************************
 * ************************
 * ************************
 * ** QUERIES START HERE **
 * ************************
 * ************************
 * ************************
 */

class AddTestCommentMutation extends Object
    with Arguments, Fields
    implements GQLOperation {
  AddCommentMutation addComment = new AddCommentMutation();

  @override
  OperationType get type => OperationType.mutation;

  @override
  String get name => 'AddTestCommentMutation';

  @override
  String get args => '\$issueId: ID!, \$body: String!';

  @override
  List<GQLField> get fields => [addComment];

  @override
  AddTestCommentMutation clone() =>
      new AddTestCommentMutation()..addComment = addComment.clone();
}

class AddCommentMutation extends Object
    with Arguments, Fields
    implements GQLField {
  CommentEdgeResolver commentEdge = new CommentEdgeResolver();

  @override
  String get name => 'addComment';

  @override
  String get args => 'input: {subjectId: \$issueId, body: \$body}';

  @override
  List<GQLField> get fields => [commentEdge];

  @override
  AddCommentMutation clone() =>
      new AddCommentMutation()..commentEdge = commentEdge.clone();
}

class CommentEdgeResolver extends Object
    with Alias, Fields
    implements GQLField {
  NodeResolver node = new NodeResolver();

  @override
  String get name => 'commentEdge';

  @override
  List<GQLField> get fields => [node];

  @override
  CommentEdgeResolver clone() => new CommentEdgeResolver()
    ..aliasSeed = aliasSeed
    ..node = node.clone();
}

class NodeResolver extends Object with Alias, Fields implements GQLField {
  BodyResolver body = new BodyResolver();

  @override
  String get name => 'node';

  @override
  List<GQLField> get fields => [body];

  @override
  NodeResolver clone() => new NodeResolver()
    ..aliasSeed = aliasSeed
    ..body = body.clone();
}

class BodyResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get name => 'body';

  @override
  BodyResolver clone() => new BodyResolver()..aliasSeed = aliasSeed;
}

class LoginQuery extends Object with Fields implements GQLOperation {
  ViewerResolver viewer = new ViewerResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'LoginQuery';

  @override
  List<GQLField> get fields => [viewer];

  @override
  LoginQuery clone() => new LoginQuery()..viewer = viewer.clone();
}

class ViewerResolver extends Object with Alias, Fields implements GQLField {
  GistResolver gist = new GistResolver();
  RepositoryResolver repository = new RepositoryResolver();
  RepositoriesResolver repositories = new RepositoriesResolver();
  LoginResolver login = new LoginResolver();
  BioResolver bio = new BioResolver();
  BioResolver bio2 = new BioResolver();

  @override
  String get name => 'viewer';

  @override
  List<GQLField> get fields =>
      [repositories, gist, repository, login, bio, bio2];

  @override
  ViewerResolver clone() => new ViewerResolver()
    ..aliasSeed = aliasSeed
    ..gist = gist.clone()
    ..repository = repository.clone()
    ..repositories = repositories.clone()
    ..login = login.clone()
    ..bio = bio.clone()
    ..bio2 = bio2.clone();
}

class RepositoriesResolver extends Object
    with Arguments, Alias, ScalarCollection<NodesResolver>, Fields
    implements GQLField {
  @override
  NodesResolver nodesResolver = new NodesResolver();

  @override
  String get name => 'repositories';

  @override
  String get args => 'first: 5';

  @override
  List<GQLField> get fields => [nodesResolver];

  @override
  RepositoriesResolver clone() => new RepositoriesResolver()
    ..aliasSeed = aliasSeed
    ..nodesResolver = nodesResolver.clone();
}

class NodesResolver extends Object with Fields implements GQLField {
  NameResolver repoName = new NameResolver();

  @override
  String get name => 'nodes';

  @override
  List<GQLField> get fields => [repoName];

  @override
  NodesResolver clone() => new NodesResolver()..repoName = repoName.clone();
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
  String get name => 'repository';

  @override
  String get args => 'name: "graphql_client"';

  @override
  List<GQLField> get fields => [createdAt];

  @override
  List<GQLFragment> get fragments =>
      [_descriptiveRepositoryFragment, _idRepositoryFragment];

  RepositoryResolver clone() => new RepositoryResolver()
    ..aliasSeed = aliasSeed
    ..description = description.clone()
    ..repoName = repoName.clone()
    ..id = id.clone()
    ..createdAt = createdAt.clone();
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
  String get name => 'gist';

  @override
  String get args => 'name: "e675723fc16a5b9bd4d1"';

  @override
  List<GQLFragment> get fragments => [_descriptiveGistFragment];

  @override
  GistResolver clone() => new GistResolver()
    ..aliasSeed = aliasSeed
    ..description = description.clone();
}

class LoginResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get name => 'login';

  @override
  LoginResolver clone() => new LoginResolver()..aliasSeed = aliasSeed;
}

class BioResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get name => 'bio';

  @override
  BioResolver clone() => new BioResolver()..aliasSeed = aliasSeed;
}

class DescriptionResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get name => 'description';

  @override
  DescriptionResolver clone() =>
      new DescriptionResolver()..aliasSeed = aliasSeed;
}

class NameResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get name => 'name';

  @override
  NameResolver clone() => new NameResolver()..aliasSeed = aliasSeed;
}

class CreatedAtResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get name => 'createdAt';

  @override
  CreatedAtResolver clone() => new CreatedAtResolver()..aliasSeed = aliasSeed;
}

class IdResolver extends Object with Scalar<String>, Alias implements GQLField {
  @override
  String get name => 'id';

  @override
  IdResolver clone() => new IdResolver()..aliasSeed = aliasSeed;
}

class GistDescriptiveFragmentResolver extends Object
    with Fields
    implements GQLField {
  DescriptionResolver description = new DescriptionResolver();

  @override
  String get name => 'GistDescriptiveFragment';

  @override
  List<GQLField> get fields => [description];

  @override
  GistDescriptiveFragmentResolver clone() =>
      new GistDescriptiveFragmentResolver()..description = description.clone();
}

class GistDescriptiveFragment extends GistDescriptiveFragmentResolver
    implements GQLFragment {
  @override
  String get onType => 'Gist';
}

class RepositoryDescriptiveFragmentResolver extends Object
    with Fields
    implements GQLField {
  DescriptionResolver description = new DescriptionResolver();
  NameResolver repoName = new NameResolver();

  @override
  String get name => 'RepositoryDescriptiveFragment';

  @override
  List<GQLField> get fields => [description, repoName];

  @override
  RepositoryDescriptiveFragmentResolver clone() =>
      new RepositoryDescriptiveFragmentResolver()
        ..description = description.clone()
        ..repoName = repoName.clone();
}

class RepositoryDescriptiveFragment
    extends RepositoryDescriptiveFragmentResolver implements GQLFragment {
  @override
  String get onType => 'Repository';
}

class RepositoryIdFragmentResolver extends Object
    with Fields
    implements GQLField {
  IdResolver id = new IdResolver();

  @override
  String get name => 'RepositoryIdFragment';

  @override
  List<GQLField> get fields => [id];

  @override
  RepositoryIdFragmentResolver clone() =>
      new RepositoryIdFragmentResolver()..id = id.clone();
}

class RepositoryIdFragment extends RepositoryIdFragmentResolver
    implements GQLFragment {
  @override
  String get onType => 'Repository';
}
