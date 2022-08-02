import 'package:dartz/dartz.dart';
import 'package:repo_viewer/github/core/3_domain/github_failure.dart';

import '../../../../core/3_domain/fresh.dart';
import '../../../../core/4_infrastructure/network_exceptions.dart';
import '../../../core/3_domain/github_repo.dart';
import 'searched_repos_remote_service.dart';
import 'package:repo_viewer/github/repos/core/4_infrastructure/extensions.dart';

class SearchedReposRepository {
  SearchedReposRepository(this._remoteService);

  final SearchedReposRemoteService _remoteService;

  Future<Either<GithubFailure, Fresh<List<GithubRepo>>>> getSearchedReposPage(
    String query,
    int page,
  ) async {
    try {
      final remotePageItems =
          await _remoteService.getSearchedReposPage(query, page);
      return right(
        remotePageItems.maybeWhen(
          withNewData: (data, maxPage) =>
              Fresh.yes(data.toDomain(), isNextPageAvailable: page < maxPage),
          orElse: () => Fresh.no([], isNextPageAvailable: false),
        ),
      );
    } on RestApiException catch (e) {
      return left(GithubFailure.api(e.errorCode));
    }
  }
}
