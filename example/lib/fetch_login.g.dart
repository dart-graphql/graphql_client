// GENERATED CODE - DO NOT MODIFY BY HAND

// File fetch_login.g.dart

// ignore_for_file: public_member_api_docs
// ignore_for_file: slash_for_doc_comments

library example.fetch_login;

import 'package:graphql_client/graphql_dsl.dart';

class FetchLoginQuery extends Object with Fields implements GQLOperation {
  ViewerResolver viewer = new ViewerResolver();
  @override
  String get type => queryType;
  @override
  String get name => 'FetchLogin';
  @override
  List<GQLField> get fields => [viewer];
  @override
  FetchLoginQuery clone() => new FetchLoginQuery()..viewer = viewer.clone();
}

class ViewerResolver extends Object with Fields implements GQLField {
  LoginResolver login = new LoginResolver();
  @override
  String get name => 'viewer';
  @override
  List<GQLField> get fields => [login];
  @override
  ViewerResolver clone() => new ViewerResolver()..login = login.clone();
}

class LoginResolver extends Object with Scalar implements GQLField {
  @override
  String get name => 'login';
  @override
  LoginResolver clone() => new LoginResolver();
}
