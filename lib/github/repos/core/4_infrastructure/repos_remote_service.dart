import 'package:dio/dio.dart';
import 'package:repo_viewer/core/4_infrastructure/dio_extensions.dart';
import '../../../../core/4_infrastructure/network_exceptions.dart';
import '../../../../core/4_infrastructure/remote_response.dart';
import '../../../core/4_infrastructure/github_headers.dart';
import '../../../core/4_infrastructure/github_headers_cache.dart';
import '../../../core/4_infrastructure/github_repo_dto.dart';

// ^ Provides common functionality which is shared between starredRepos and searchRepos remote services

// ^ A) Handles requests to the API for repoPages,
// ^ B) it maintains a cache of previousHeader with which we add to our requests to check if a repoPage has been updated or not.
// ^ C) it returns a 'RemoteResponse' which specifies whether query data is new, notUpdated or if there is no internet
// ^ D) if data is new, it returns it as a list of DTO's
// ^ E) it prevents searching beyond max available pages

abstract class ReposRemoteService {
  ReposRemoteService(
    this._dio,
    this._headersCache,
  );

  final Dio _dio; // facilitates HTTP requests
  final GithubHeadersCache
      _headersCache; // enables us to check if repo has been updated via eTag records, starred repos only

  // Remote response type will differ depending on whether there is an internet connection and if the content has
  // changed. This will determine whether the data is taken from the API or local database.
  Future<RemoteResponse<List<GithubRepoDTO>>> getPage({
    required Uri requestUri,
    // this enables our child classes to specify how the json response is converted as the json structure
    // differs between searched repos and starred repos
    required List<dynamic> Function(dynamic json) jsonDataSelector,
  }) async {
    final previousHeaders = await _headersCache.getHeaders(requestUri);
    try {
      final response = await _dio.getUri(
        requestUri,
        options: Options(
          headers: {
            //  Here we're providing the server our previousHeaders eTag, if it matches we receive a 304
            'If-None-Match': previousHeaders?.eTag ?? '',
          },
        ),
      );
      // & 304 RECEIVED (NOT MODIFIED)
      if (response.statusCode == 304) {
        return RemoteResponse.notModified(
            maxPage: previousHeaders?.link?.maxPage ?? 0);
        // & 200 RECEIVED (NEW DATA)
      } else if (response.statusCode == 200) {
        //  saving headers ready for next time
        final headers = GithubHeaders.parse(response);
        await _headersCache.saveHeaders(requestUri, headers);
        // Converts the data from json and saves each element as a GithubRepoDTO object
        final convertedData = jsonDataSelector(response.data)
            .map((e) => GithubRepoDTO.fromJson(e as Map<String, dynamic>))
            .toList();
        // returns the list of DTO's and maxPage
        return RemoteResponse.withNewData(
          convertedData,
          maxPage: headers.link?.maxPage ?? 1,
        );
      } else {
        throw RestApiException(response.statusCode);
      }
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        return const RemoteResponse.noConnection();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
