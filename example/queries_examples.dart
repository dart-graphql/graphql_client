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
    with Arguments
    implements GQLOperation {
  AddCommentMutation addComment = new AddCommentMutation();

  @override
  OperationType get type => OperationType.mutation;

  @override
  String get name => 'AddTestCommentMutation';

  @override
  String get args => '\$issueId: ID!, \$body: String!';

  @override
  List<GQLOperation> get resolvers => [addComment];

  @override
  List<Fragment> get fragments => const [];

  @override
  AddTestCommentMutation selfFactory() =>
      new AddTestCommentMutation()..addComment = addComment.selfFactory();
}

class AddCommentMutation extends Object with Arguments implements GQLOperation {
  CommentEdgeResolver commentEdge = new CommentEdgeResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'addComment';

  @override
  String get args => 'input: {subjectId: \$issueId, body: \$body}';

  @override
  List<GQLOperation> get resolvers => [commentEdge];

  @override
  List<Fragment> get fragments => const [];

  @override
  AddCommentMutation selfFactory() =>
      new AddCommentMutation()..commentEdge = commentEdge.selfFactory();
}

class CommentEdgeResolver extends Object with Alias implements GQLOperation {
  NodeResolver node = new NodeResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'commentEdge';

  @override
  List<GQLOperation> get resolvers => [node];

  @override
  List<Fragment> get fragments => const [];

  @override
  CommentEdgeResolver selfFactory() => new CommentEdgeResolver()
    ..aliasSeed = aliasSeed
    ..node = node.selfFactory();
}

class NodeResolver extends Object with Alias implements GQLOperation {
  BodyResolver body = new BodyResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'node';

  @override
  List<GQLOperation> get resolvers => [body];

  @override
  List<Fragment> get fragments => const [];

  @override
  NodeResolver selfFactory() => new NodeResolver()
    ..aliasSeed = aliasSeed
    ..body = body.selfFactory();
}

class BodyResolver extends Object
    with Scalar<String>, Alias
    implements GQLOperation {
  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'body';

  @override
  List<GQLOperation> get resolvers => const [];

  @override
  List<Fragment> get fragments => const [];

  @override
  BodyResolver selfFactory() => new BodyResolver()..aliasSeed = aliasSeed;
}

class LoginQuery implements GQLOperation {
  ViewerResolver viewer = new ViewerResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'LoginQuery';

  @override
  List<GQLOperation> get resolvers => [viewer];

  @override
  List<Fragment> get fragments => const [];

  @override
  LoginQuery selfFactory() => new LoginQuery()..viewer = viewer.selfFactory();
}

class ViewerResolver extends Object with Alias implements GQLOperation {
  GistResolver gist = new GistResolver();
  RepositoryResolver repository = new RepositoryResolver();
  RepositoriesResolver repositories = new RepositoriesResolver();

  LoginResolver login = new LoginResolver();
  BioResolver bio = new BioResolver();
  BioResolver bio2 = new BioResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'viewer';

  @override
  List<GQLOperation> get resolvers =>
      [repositories, gist, repository, login, bio, bio2];

  @override
  List<Fragment> get fragments => const [];

  @override
  ViewerResolver selfFactory() => new ViewerResolver()
    ..aliasSeed = aliasSeed
    ..gist = gist.selfFactory()
    ..repository = repository.selfFactory()
    ..repositories = repositories.selfFactory()
    ..login = login.selfFactory()
    ..bio = bio.selfFactory()
    ..bio2 = bio2.selfFactory();
}

class RepositoriesResolver extends Object
    with Arguments, Alias, ScalarCollection<NodesResolver>
    implements GQLOperation {
  @override
  NodesResolver nodesResolver = new NodesResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'repositories';

  @override
  String get args => 'first: 5';

  @override
  List<GQLOperation> get resolvers => [nodesResolver];

  @override
  List<Fragment> get fragments => const [];

  @override
  RepositoriesResolver selfFactory() => new RepositoriesResolver()
    ..aliasSeed = aliasSeed
    ..nodesResolver = nodesResolver.selfFactory();
}

class NodesResolver extends Object implements GQLOperation {
  NameResolver repoName = new NameResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'nodes';

  @override
  List<GQLOperation> get resolvers => [repoName];

  @override
  List<Fragment> get fragments => const [];

  @override
  NodesResolver selfFactory() =>
      new NodesResolver()..repoName = repoName.selfFactory();
}

class RepositoryResolver extends Object
    with Arguments, Alias
    implements
        RepositoryDescriptiveFragmentResolver,
        RepositoryIdFragmentResolver,
        GQLOperation {
  final RepositoryDescriptiveFragment descriptiveRepositoryFragment =
      new RepositoryDescriptiveFragment();
  final RepositoryIdFragment idRepositoryFragment = new RepositoryIdFragment();

  CreatedAtResolver createdAt = new CreatedAtResolver();

  @override
  DescriptionResolver description;

  @override
  NameResolver repoName;

  @override
  IdResolver id;

  RepositoryResolver() {
    description = descriptiveRepositoryFragment.description;
    repoName = descriptiveRepositoryFragment.repoName;
    id = idRepositoryFragment.id;
  }

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'repository';

  @override
  String get args => 'name: "graphql_client"';

  @override
  List<GQLOperation> get resolvers => [createdAt];

  @override
  List<Fragment> get fragments =>
      [descriptiveRepositoryFragment, idRepositoryFragment];

  RepositoryResolver selfFactory() => new RepositoryResolver()
    ..aliasSeed = aliasSeed
    ..description = description
    ..repoName = repoName
    ..id = id
    ..createdAt = createdAt.selfFactory();
}

class GistResolver extends Object
    with Arguments, Alias
    implements GistDescriptiveFragmentResolver, GQLOperation {
  final GistDescriptiveFragment descriptiveGistFragment =
      new GistDescriptiveFragment();

  @override
  DescriptionResolver description;

  GistResolver() {
    description = descriptiveGistFragment.description;
  }

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'gist';

  @override
  String get args => 'name: "e675723fc16a5b9bd4d1"';

  @override
  List<GQLOperation> get resolvers => [];

  @override
  List<Fragment> get fragments => [descriptiveGistFragment];

  @override
  GistResolver selfFactory() => new GistResolver()
    ..aliasSeed = aliasSeed
    ..description = description;
}

class LoginResolver extends Object
    with Scalar<String>, Alias
    implements GQLOperation {
  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'login';

  @override
  List<GQLOperation> get resolvers => const [];

  @override
  List<Fragment> get fragments => const [];

  @override
  LoginResolver selfFactory() => new LoginResolver()..aliasSeed = aliasSeed;
}

class BioResolver extends Object
    with Scalar<String>, Alias
    implements GQLOperation {
  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'bio';

  @override
  List<GQLOperation> get resolvers => const [];

  @override
  List<Fragment> get fragments => const [];

  @override
  BioResolver selfFactory() => new BioResolver()..aliasSeed = aliasSeed;
}

class DescriptionResolver extends Object
    with Scalar<String>, Alias
    implements GQLOperation {
  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'description';

  @override
  List<GQLOperation> get resolvers => const [];

  @override
  List<Fragment> get fragments => const [];

  @override
  DescriptionResolver selfFactory() =>
      new DescriptionResolver()..aliasSeed = aliasSeed;
}

class NameResolver extends Object
    with Scalar<String>, Alias
    implements GQLOperation {
  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'name';

  @override
  List<GQLOperation> get resolvers => const [];

  @override
  List<Fragment> get fragments => const [];

  @override
  NameResolver selfFactory() => new NameResolver()..aliasSeed = aliasSeed;
}

class CreatedAtResolver extends Object
    with Scalar<String>, Alias
    implements GQLOperation {
  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'createdAt';

  @override
  List<GQLOperation> get resolvers => const [];

  @override
  List<Fragment> get fragments => const [];

  @override
  CreatedAtResolver selfFactory() =>
      new CreatedAtResolver()..aliasSeed = aliasSeed;
}

class IdResolver extends Object
    with Scalar<String>, Alias
    implements GQLOperation {
  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'id';

  @override
  List<GQLOperation> get resolvers => const [];

  @override
  List<Fragment> get fragments => const [];

  @override
  IdResolver selfFactory() => new IdResolver()..aliasSeed = aliasSeed;
}

class GistDescriptiveFragmentResolver implements GQLOperation {
  DescriptionResolver description = new DescriptionResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'GistDescriptiveFragment';

  @override
  List<GQLOperation> get resolvers => [description];

  @override
  List<Fragment> get fragments => const [];

  @override
  GistDescriptiveFragmentResolver selfFactory() =>
      new GistDescriptiveFragmentResolver()..description = description;
}

class GistDescriptiveFragment extends GistDescriptiveFragmentResolver
    implements Fragment {
  @override
  String get onType => 'Gist';
}

class RepositoryDescriptiveFragmentResolver implements GQLOperation {
  DescriptionResolver description = new DescriptionResolver();
  NameResolver repoName = new NameResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'RepositoryDescriptiveFragment';

  @override
  List<GQLOperation> get resolvers => [description, repoName];

  @override
  List<Fragment> get fragments => const [];

  @override
  RepositoryDescriptiveFragmentResolver selfFactory() =>
      new RepositoryDescriptiveFragmentResolver()
        ..description = description
        ..repoName = repoName;
}

class RepositoryDescriptiveFragment
    extends RepositoryDescriptiveFragmentResolver implements Fragment {
  @override
  String get onType => 'Repository';
}

class RepositoryIdFragmentResolver implements GQLOperation {
  IdResolver id = new IdResolver();

  @override
  OperationType get type => OperationType.query;

  @override
  String get name => 'RepositoryIdFragment';

  @override
  List<GQLOperation> get resolvers => [id];

  @override
  List<Fragment> get fragments => const [];

  @override
  RepositoryIdFragmentResolver selfFactory() =>
      new RepositoryIdFragmentResolver()..id = id;
}

class RepositoryIdFragment extends RepositoryIdFragmentResolver
    implements Fragment {
  @override
  String get onType => 'Repository';
}
