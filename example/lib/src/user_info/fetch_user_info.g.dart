// GENERATED CODE - DO NOT MODIFY BY HAND

// File fetch_user_info.g.dart

// ignore_for_file: public_member_api_docs
// ignore_for_file: slash_for_doc_comments

library example.src.user_info.fetch_user_info;

import 'package:graphql_client/graphql_dsl.dart';

class FetchUserInfoQuery extends Object
    with Fields, Arguments
    implements GQLOperation {
  ViewerResolver viewer = new ViewerResolver();
  @override
  String get gqlType => queryType;
  @override
  String get gqlName => 'FetchUserInfo';
  @override
  String get gqlArguments => r'($avatarSize:Int)';
  @override
  List<GQLField> get gqlFields => [viewer];
  @override
  FetchUserInfoQuery gqlClone() =>
      new FetchUserInfoQuery()..viewer = viewer.gqlClone();
}

class ViewerResolver extends Object with Fields implements GQLField {
  LoginResolver login = new LoginResolver();
  BioResolver bio = new BioResolver();
  LocationResolver location = new LocationResolver();
  AvatarUrlResolver avatarUrl = new AvatarUrlResolver();
  @override
  String get gqlName => 'viewer';
  @override
  List<GQLField> get gqlFields => [login, bio, location, avatarUrl];
  @override
  ViewerResolver gqlClone() => new ViewerResolver()
    ..login = login.gqlClone()
    ..bio = bio.gqlClone()
    ..location = location.gqlClone()
    ..avatarUrl = avatarUrl.gqlClone();
}

class LoginResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'login';
  @override
  LoginResolver gqlClone() => new LoginResolver();
}

class BioResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'bio';
  @override
  BioResolver gqlClone() => new BioResolver();
}

class LocationResolver extends Object with Scalar implements GQLField {
  @override
  String get gqlName => 'location';
  @override
  LocationResolver gqlClone() => new LocationResolver();
}

class AvatarUrlResolver extends Object
    with Scalar, Arguments
    implements GQLField {
  @override
  String get gqlName => 'avatarUrl';
  @override
  String get gqlArguments => r'(size:$avatarSize)';
  @override
  AvatarUrlResolver gqlClone() => new AvatarUrlResolver();
}
