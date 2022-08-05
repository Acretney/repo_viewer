import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:repo_viewer/core/4_infrastructure/network_exceptions.dart';
import 'package:repo_viewer/core/4_infrastructure/remote_response.dart';
import '../../core/4_infrastructure/github_headers.dart';
import '../../core/4_infrastructure/github_headers_cache.dart';
import 'package:repo_viewer/core/4_infrastructure/dio_extensions.dart';

class RepoDetailRemoteService {
  RepoDetailRemoteService(this._dio, this._headersCache);

  final Dio _dio;
  final GithubHeadersCache _headersCache;

  Future<RemoteResponse<String>> getReadmeHtml(String fullRepoName) async {
    final requestUri =
        Uri.https('api.github.com', '/repos/$fullRepoName/readme');
    final previousHeaders = await _headersCache.getHeaders(requestUri);
    try {
      final response = await _dio.getUri(requestUri,
          options: Options(
            headers: {
              'If-None-Match': previousHeaders?.eTag ?? '',
            },
            responseType:
                ResponseType.plain, // We want plain text rather than JSON
          ));
      // ^ NOT MODIFIED
      if (response.statusCode == 304) {
        return const RemoteResponse.notModified(maxPage: 0);
        // ^ NEW DATA
      } else if (response.statusCode == 200) {
        final headers = GithubHeaders.parse(response);
        await _headersCache.saveHeaders(requestUri, headers);
        final html = response.data as String;
        return RemoteResponse.withNewData(html, maxPage: 0);
      } else {
        throw RestApiException(response.statusCode);
      }
    } on DioError catch (e) {
      // ^ NO CONNECTION
      if (e.isNoConnectionError) {
        return const RemoteResponse.noConnection();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  /// returns 'null' if there is no internet connection
  Future<bool?> getStarredStatus(String fullRepoName) async {
    final requestUri = Uri.https(
      'api.github.com',
      '/user/starred/$fullRepoName',
    );

    try {
      final response = await _dio.getUri(
        requestUri,
        // The API is weird because it returns a 404 in the event the repo is unstarred. This is actually a valid
        // response so we change the validate status here to interpret it as a successfull response.
        options: Options(
          validateStatus: (status) =>
              (status != null && status >= 200 && status < 400) ||
              status == 404,
        ),
      );
      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 404) {
        return false;
      } else {
        throw RestApiException(response.statusCode);
      }
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        return null;
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  /// returns null if there is no internet connection
  Future<Unit?> switchStarredStatus(
    String fullRepoName, {
    required bool isCurrentlyStarred,
  }) async {
    final requestUri = Uri.https(
      'api.github.com',
      '/user/starred/$fullRepoName',
    );

    try {
      final response = await (isCurrentlyStarred
          ? _dio.deleteUri(requestUri)
          : _dio.putUri(requestUri));

      if (response.statusCode == 204) {
        return unit;
      } else {
        throw RestApiException(response.statusCode);
      }
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        return null;
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}