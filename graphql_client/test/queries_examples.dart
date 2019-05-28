// Copyright Thomas Hourlier. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:graphql_client/graphql_dsl.dart';

// ignore_for_file: public_member_api_docs
// ignore_for_file: slash_for_doc_comments

const String readRepositories = r'''
  query ReadRepositories($nRepositories: Int!) {
    viewer {
      repositories(last: $nRepositories) {
        nodes {
          __typename
          id
          name
          viewerHasStarred
        }
      }
    }
  }
''';
/**
 * ************************
 * ************************
 * ************************
 * **** GQL OPERATIONS ****
 * ************************
 * ************************
 * ************************
 */

class ReadRepositoriesQuery extends Object
    with Arguments, Fields
    implements GQLOperation {
  ViewerResolver viewer = ViewerResolver();

  @override
  String get type => queryType;

  @override
  String get name => 'ReadRepositories';

  @override
  List<GQLField> get fields => [viewer];

  @override
  ReadRepositoriesQuery clone() =>
      ReadRepositoriesQuery()..viewer = viewer.clone();

  @override
  String get args => '\$nRepositories: Int!';
}

const String addStar = r'''
  mutation AddStar($starrableId: ID!) {
    action: addStar(input: {starrableId: $starrableId}) {
      starrable {
        viewerHasStarred
      }
    }
  }
''';

class AddStarMutation extends Object
    with Arguments, Fields
    implements GQLOperation {
  ActionMutation action = ActionMutation();

  @override
  String get type => mutationType;

  @override
  String get name => 'AddStar';

  @override
  String get args => '\$starrableId: ID!';

  @override
  List<GQLField> get fields => [action];

  @override
  AddStarMutation clone() =>
      AddStarMutation()..action = action.clone();
}

class AddTestCommentMutation extends Object
    with Arguments, Fields
    implements GQLOperation {
  ActionMutation addComment = ActionMutation();

  @override
  String get type => mutationType;

  @override
  String get name => 'AddTestCommentMutation';

  @override
  String get args => '\$issueId: ID!, \$body: String!';

  @override
  List<GQLField> get fields => [addComment];

  @override
  AddTestCommentMutation clone() =>
      AddTestCommentMutation()..addComment = addComment.clone();
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
  String get onType => 'Repository';
}

class RepositoryIdFragment extends RepositoryIdFragmentResolver
    implements GQLFragment {
  @override
  String get onType => 'Repository';
}

class GistDescriptiveFragment extends GistDescriptiveFragmentResolver
    implements GQLFragment {
  @override
  String get onType => 'Gist';
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

class ActionMutation extends Object
    with Fields
    implements GQLField {
  CommentEdgeResolver commentEdge = CommentEdgeResolver();

  @override
  String get name => 'action';

  @override
  List<GQLField> get fields => [commentEdge];

  @override
  ActionMutation clone() =>
      ActionMutation()..commentEdge = commentEdge.clone();
}

class CommentEdgeResolver extends Object
    with Arguments, Fields
    implements GQLField {
  ViewerHasStarredResolver viewerHasStarred = ViewerHasStarredResolver();

  @override
  String get args => r'input: {starrableId: $starrableId}';

  @override
  String get name => 'starrable';

  @override
  List<GQLField> get fields => [viewerHasStarred];

  @override
  CommentEdgeResolver clone() => CommentEdgeResolver()
    ..viewerHasStarred = viewerHasStarred.clone();
}

class NodeResolver extends Object with Fields, Alias implements GQLField {
  BodyResolver body = BodyResolver();

  @override
  String get name => 'node';

  @override
  List<GQLField> get fields => [body];

  @override
  NodeResolver clone() => NodeResolver()
    ..aliasId = aliasId
    ..body = body.clone();
}

class ViewerResolver extends Object with Fields implements GQLField {
  RepositoriesResolver repositories = RepositoriesResolver();

  @override
  String get name => 'viewer';

  @override
  List<GQLField> get fields => [repositories];

  @override
  ViewerResolver clone() =>
      ViewerResolver()..repositories = repositories.clone();
}

class NodesResolver extends Object with Fields implements GQLField {
  RepoTypeNameResolver repoTypeName = RepoTypeNameResolver();
  RepoNameResolver repoName = RepoNameResolver();
  RepoIdResolver repoId = RepoIdResolver();
  RepoViewerHasStarredResolver viewerHasStarred =
      RepoViewerHasStarredResolver();

  @override
  String get name => 'nodes';

  @override
  List<GQLField> get fields =>
      <GQLField>[repoTypeName, repoId, repoName, viewerHasStarred];

  @override
  NodesResolver clone() => NodesResolver()..repoName = repoName.clone();
}

class RepositoryResolver extends Object
    with Arguments, Fields
    implements
        RepositoryDescriptiveFragmentResolver,
        RepositoryIdFragmentResolver,
        GQLField {
  final RepositoryDescriptiveFragment _descriptiveRepositoryFragment =
      RepositoryDescriptiveFragment();
  final RepositoryIdFragment _idRepositoryFragment = RepositoryIdFragment();

  CreatedAtResolver createdAt = CreatedAtResolver();

  @override
  DescriptionResolver description;

  @override
  RepoNameResolver repoName;

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

  RepositoryResolver clone() => RepositoryResolver()
    ..description = description.clone()
    ..repoName = repoName.clone()
    ..id = id.clone()
    ..createdAt = createdAt.clone();
}

class GistResolver extends Object
    with Arguments, Alias, Fields, Fragments
    implements GistDescriptiveFragmentResolver, GQLField {
  final GistDescriptiveFragment _descriptiveGistFragment =
      GistDescriptiveFragment();

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
  GistResolver clone() => GistResolver()
    ..aliasId = aliasId
    ..description = description.clone();
}

class GistDescriptiveFragmentResolver extends Object
    with Fields
    implements GQLField {
  DescriptionResolver description = DescriptionResolver();

  @override
  String get name => 'GistDescriptiveFragment';

  @override
  List<GQLField> get fields => [description];

  @override
  GistDescriptiveFragmentResolver clone() =>
      GistDescriptiveFragmentResolver()..description = description.clone();
}

class RepositoryDescriptiveFragmentResolver extends Object
    with Fields
    implements GQLField {
  DescriptionResolver description = DescriptionResolver();
  RepoNameResolver repoName = RepoNameResolver();

  @override
  String get name => 'RepositoryDescriptiveFragment';

  @override
  List<GQLField> get fields => [description, repoName];

  @override
  RepositoryDescriptiveFragmentResolver clone() =>
      RepositoryDescriptiveFragmentResolver()
        ..description = description.clone()
        ..repoName = repoName.clone();
}

class RepositoryIdFragmentResolver extends Object
    with Fields
    implements GQLField {
  IdResolver id = IdResolver();

  @override
  String get name => 'RepositoryIdFragment';

  @override
  List<GQLField> get fields => [id];

  @override
  RepositoryIdFragmentResolver clone() =>
      RepositoryIdFragmentResolver()..id = id.clone();
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
    with Arguments, ScalarCollection<NodesResolver>, Fields
    implements GQLField {
  @override
  NodesResolver nodesResolver = NodesResolver();

  @override
  String get name => 'repositories';

  @override
  String get args => r'last: $nRepositories';

  @override
  List<GQLField> get fields => [nodesResolver];

  @override
  RepositoriesResolver clone() =>
      RepositoriesResolver()..nodesResolver = nodesResolver.clone();
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
  String get name => 'login';

  @override
  String get directive => includeDirective;

  @override
  String get directiveValue => 'false';

  @override
  LoginResolver clone() => LoginResolver()..aliasId = aliasId;
}

class ViewerHasStarredResolver extends Object
    with Scalar<bool>
    implements GQLField {
  @override
  String get name => 'viewerHasStarred';

  @override
  ViewerHasStarredResolver clone() => ViewerHasStarredResolver();
}
class BioResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get name => 'bio';

  @override
  BioResolver clone() => BioResolver()..aliasId = aliasId;
}

class DescriptionResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get name => 'description';

  @override
  DescriptionResolver clone() => DescriptionResolver()..aliasId = aliasId;
}

class RepoViewerHasStarredResolver extends Object
    with Scalar<bool>
    implements GQLField {
  @override
  String get name => 'viewerHasStarred';

  @override
  RepoViewerHasStarredResolver clone() => RepoViewerHasStarredResolver();
}

class RepoIdResolver extends Object with Scalar<String> implements GQLField {
  @override
  String get name => 'id';

  @override
  RepoIdResolver clone() => RepoIdResolver();
}

class RepoTypeNameResolver extends Object
    with Scalar<String>
    implements GQLField {
  @override
  String get name => '__typename';

  @override
  RepoTypeNameResolver clone() => RepoTypeNameResolver();
}

class RepoNameResolver extends Object with Scalar<String> implements GQLField {
  @override
  String get name => 'name';

  @override
  RepoNameResolver clone() => RepoNameResolver();
}

class CreatedAtResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get name => 'createdAt';

  @override
  CreatedAtResolver clone() => CreatedAtResolver()..aliasId = aliasId;
}

class IdResolver extends Object with Scalar<String>, Alias implements GQLField {
  @override
  String get name => 'id';

  @override
  IdResolver clone() => IdResolver()..aliasId = aliasId;
}

class BodyResolver extends Object
    with Scalar<String>, Alias
    implements GQLField {
  @override
  String get name => 'body';

  @override
  BodyResolver clone() => BodyResolver()..aliasId = aliasId;
}
