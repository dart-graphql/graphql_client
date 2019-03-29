import 'dart:convert';
import 'dart:io' show File, Platform;
import 'dart:typed_data' show Uint8List;

import 'package:graphql_client/graphql_dsl.dart';
import 'package:path/path.dart' show dirname, join;
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:graphql_client/graphql_client.dart';
import 'queries_examples.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  GQLClient graphQLClient;
  MockHttpClient mockHttpClient;
  const String apiToken = 'my-special-bearer-token';
  group('simple json', () {
    setUp(() {
      mockHttpClient = MockHttpClient();
      graphQLClient = GQLClient(
        client: mockHttpClient,
        endPoint: 'https://api.github.com/graphql',
        // logger: null,
      );
    });
    group('query', () {
      test('successful query', () async {
        when(
          mockHttpClient.send(any),
        ).thenAnswer((Invocation a) async {
          const String body = '''
{
  "data": {
    "viewer": {
      "repositories": {
        "nodes": [
          {
            "__typename": "Repository",
            "id": "MDEwOlJlcG9zaXRvcnkyNDgzOTQ3NA==",
            "name": "pq",
            "viewerHasStarred": false
          },
          {
            "__typename": "Repository",
            "id": "MDEwOlJlcG9zaXRvcnkzMjkyNDQ0Mw==",
            "name": "go-evercookie",
            "viewerHasStarred": false
          },
          {
            "__typename": "Repository",
            "id": "MDEwOlJlcG9zaXRvcnkzNTA0NjgyNA==",
            "name": "watchbot",
            "viewerHasStarred": false
          }
        ]
      }
    }
  }
}
        ''';

          final List<int> bytes = utf8.encode(body);
          final Stream<List<int>> stream =
              Stream<List<int>>.fromIterable([bytes]);

          final http.StreamedResponse r = http.StreamedResponse(stream, 200);

          return r;
        });

        final ReadRepositoriesQuery queryRes = await graphQLClient.execute(
          ReadRepositoriesQuery(),
          // @todo type-sfe
          variables: <String, dynamic>{
            'nRepositories': 42,
          },
          headers: <String, String>{
            'Authorization': 'bearer $apiToken',
          },
        );

        final dynamic captured = verify(mockHttpClient.send(captureAny))
            .captured
            .first;
        expect(captured, isA<http.Request>());
        http.Request request = captured as http.Request;
        expect(request.method, 'post');
        expect(request.url.toString(), 'https://api.github.com/graphql');
        expect(
          request.headers,
          <String, String>{
            'accept': '*/*',
            'content-type': 'application/json; charset=utf-8',
            'Authorization': 'bearer my-special-bearer-token',
          },
        );
        expect(await request.finalize().bytesToString(),
            r'{"operationName":"ReadRepositories","variables":{"nRepositories":42},"query":"query ReadRepositories ($nRepositories: Int!) { viewer { repositories (last: $nRepositories) { nodes { __typename  id  name  viewerHasStarred   }  }  } }\n"}');

        // @todo errors should be value, not excpetion
        // expect(queryRes.errors, isNull);
        // expect(queryRes.data, isNotNull);
        expect(queryRes.viewer, isNotNull);
        // @todo better if we don't have to cast here
        final List<NodesResolver> nodes = queryRes.viewer.repositories.nodes.cast();
        expect(nodes, hasLength(3));
        expect(nodes[0].repoId.value, 'MDEwOlJlcG9zaXRvcnkyNDgzOTQ3NA==');
        expect(nodes[1].repoName.value, 'go-evercookie');
        expect(nodes[2].viewerHasStarred.value, false);
        return;
      });
//    test('failed query because of network', {});
//    test('failed query because of because of error response', {});
//    test('failed query because of because of invalid response', {});
    });
    group('mutation', () {
      test('successful mutation', () async {
        when(mockHttpClient.send(any)).thenAnswer((Invocation a) async {
          const String body =
              '{"data":{"action":{"starrable":{"viewerHasStarred":true}}}}';

          final List<int> bytes = utf8.encode(body);
          final Stream<List<int>> stream =
          Stream<List<int>>.fromIterable(<List<int>>[bytes]);

          final http.StreamedResponse r = http.StreamedResponse(stream, 200);
          return r;
        });

        final AddStarMutation queryRes = await graphQLClient.execute(
          AddStarMutation(),
          // @todo type-sfe
          variables: <String, dynamic>{
            'nRepositories': 38,
          },
          headers: <String, String>{
            'Authorization': 'bearer $apiToken',
          },
        );

        final http.Request request = verify(mockHttpClient.send(captureAny))
            .captured
            .first as http.Request;
        expect(request.method, 'post');
        expect(request.url.toString(), 'https://api.github.com/graphql');
        expect(
          request.headers,
          <String, String>{
            'accept': '*/*',
            'content-type': 'application/json; charset=utf-8',
            'Authorization': 'bearer my-special-bearer-token',
          },
        );

        expect(await request.finalize().bytesToString(),
            r'{"operationName":"AddStar","variables":{"nRepositories":38},"query":"mutation AddStar ($starrableId: ID!) { action: addStar(input: {starrableId: $starrableId}) {\n      starrable {\n        viewerHasStarred\n      }\n    }\n  }\n"}');

//        expect(response.errors, isNull);
//        expect(response.data, isNotNull);
//        final bool viewerHasStarred =
//        response.data['action']['starrable']['viewerHasStarred'] as bool;
//        expect(viewerHasStarred, true);
      });
    });
//  });
//
//  group('upload', () {
//    const String uploadMutation = r'''
//    mutation($files: [Upload!]!) {
//      multipleUpload(files: $files) {
//        id
//        filename
//        mimetype
//        path
//      }
//    }
//
//    ''';
//
//    setUp(() {
//      mockHttpClient = MockHttpClient();
//
//      httpLink = HttpLink(
//          uri: 'http://localhost:3001/graphql', httpClient: mockHttpClient);
//
//      authLink = AuthLink(
//        getToken: () async => 'Bearer my-special-bearer-token',
//      );
//
//      link = authLink.concat(httpLink as Link);
//
//      graphQLClientClient = GraphQLClient(
//        cache: NormalizedInMemoryCache(
//          dataIdFromObject: typenameDataIdFromObject,
//        ),
//        link: link,
//      );
//    });
//    Future<void> expectUploadBody(http.ByteStream bodyBytesStream,
//        String boundary, List<File> files) async {
//      final Uint8List bodyBytes = await bodyBytesStream.toBytes();
//      int i = 0;
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 2)), '--');
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 70)), boundary);
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 55)),
//          '\r\ncontent-disposition: form-data; name="operations"\r\n\r\n');
//      expect(
//          String.fromCharCodes(bodyBytes.sublist(i, i += 226)),
//          r'''
//{"operationName":null,"variables":{"files":[null,null]},"query":"    mutation($files: [Upload!]!) {\n      multipleUpload(files: $files) {\n        id\n        filename\n        mimetype\n        path\n      }\n    }\n\n    "}
//      '''
//              .trim());
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 4)), '\r\n--');
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 70)), boundary);
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 101)),
//          '\r\ncontent-disposition: form-data; name="map"\r\n\r\n{"0":["variables.files.0"],"1":["variables.files.1"]}');
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 4)), '\r\n--');
//      // then random 51 chars for boundary
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 70)), boundary);
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 102)),
//          '\r\ncontent-type: image/jpeg\r\ncontent-disposition: form-data; name="0"; filename="sample_upload.jpg"\r\n\r\n');
//      // binary starts
//      expect(await files[0].readAsBytes(), bodyBytes.sublist(i, i += 256));
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 4)), '\r\n--');
//      // then random 51 chars for boundary
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 70)), boundary);
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 107)),
//          '\r\ncontent-type: video/quicktime\r\ncontent-disposition: form-data; name="1"; filename="sample_upload.mov"\r\n\r\n');
//      // binary starts
//      expect(await files[1].readAsBytes(), bodyBytes.sublist(i, i += 271));
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 4)), '\r\n--');
//      // then random 51 chars for boundary
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 70)), boundary);
//      expect(String.fromCharCodes(bodyBytes.sublist(i, i += 4)), '--\r\n');
//      expect(bodyBytes.lengthInBytes, i);
//    }
//
//    test('upload success', () async {
//      final List<File> files =
//      <String>['sample_upload.jpg', 'sample_upload.mov']
//          .map((String fileName) => join(
//        dirname(Platform.script.path),
//        'test',
//        fileName,
//      ))
//          .map((String filePath) => File(filePath))
//          .toList();
//
//      final MutationOptions _options = MutationOptions(
//        document: uploadMutation,
//        variables: <String, dynamic>{
//          'files': files,
//        },
//      );
//
//      http.ByteStream bodyBytes;
//      when(mockHttpClient.send(any)).thenAnswer((Invocation a) async {
//        bodyBytes = (a.positionalArguments[0] as http.BaseRequest).finalize();
//        const String body = r'''
//{
//  "data": {
//    "multipleUpload": [
//      {
//        "id": "r1odc4PAz",
//        "filename": "sample_upload.jpg",
//        "mimetype": "image/jpeg",
//        "path": "./uploads/r1odc4PAz-sample_upload.jpg"
//      },
//      {
//        "id": "5Ea18qlMur",
//        "filename": "sample_upload.mov",
//        "mimetype": "video/quicktime",
//        "path": "./uploads/5Ea18qlMur-sample_upload.mov"
//      }
//    ]
//  }
//}
//        ''';
//
//        final List<int> bytes = utf8.encode(body);
//        final Stream<List<int>> stream =
//        Stream<List<int>>.fromIterable(<List<int>>[bytes]);
//
//        final http.StreamedResponse r = http.StreamedResponse(stream, 200);
//        return r;
//      });
//
//      final QueryResult r = await graphQLClientClient.mutate(_options);
//
//      final http.MultipartRequest request =
//      verify(mockHttpClient.send(captureAny)).captured.first
//      as http.MultipartRequest;
//      expect(request.method, 'post');
//      expect(request.url.toString(), 'http://localhost:3001/graphql');
//      expect(request.headers['accept'], '*/*');
//      expect(
//          request.headers['Authorization'], 'Bearer my-special-bearer-token');
//      final List<String> contentTypeStringSplit =
//      request.headers['content-type'].split('; boundary=');
//      expect(contentTypeStringSplit[0], 'multipart/form-data');
//      await expectUploadBody(bodyBytes, contentTypeStringSplit[1], files);
//
//      expect(r.errors, isNull);
//      expect(r.data, isNotNull);
//      final List<Map<String, dynamic>> multipleUpload =
//      (r.data['multipleUpload'] as List<dynamic>)
//          .cast<Map<String, dynamic>>();
//
//      expect(multipleUpload, <Map<String, String>>[
//        <String, String>{
//          'id': 'r1odc4PAz',
//          'filename': 'sample_upload.jpg',
//          'mimetype': 'image/jpeg',
//          'path': './uploads/r1odc4PAz-sample_upload.jpg'
//        },
//        <String, String>{
//          'id': '5Ea18qlMur',
//          'filename': 'sample_upload.mov',
//          'mimetype': 'video/quicktime',
//          'path': './uploads/5Ea18qlMur-sample_upload.mov'
//        },
//      ]);
//    });
  });
}
