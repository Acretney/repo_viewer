import 'package:dartz/dartz.dart';
import 'package:repo_viewer/core/4_infrastructure/network_exceptions.dart';
import 'package:repo_viewer/github/core/3_domain/github_failure.dart';
import 'package:repo_viewer/github/repos/starred_repos/4_infrastructure/starred_repos_local_service.dart';
import '../../../../core/3_domain/fresh.dart';
import '../../../core/3_domain/github_repo.dart';
import 'starred_repos_remote_service.dart';
import 'package:repo_viewer/github/repos/core/4_infrastructure/extensions.dart';

// ^ A) collects RemoteResponse from StarredReposRemoteService
// ^ B) If data is new...
// ^       Converts from DTOs and returns Domain level entities
// ^       Saves to local storage
// ^ C) If data is old or no connection
// ^       returns data from storage
// ^ D) If no connectection
// ^       marks data are out of date

class StarredReposRepository {
  StarredReposRepository(this._remoteService, this._localService);

  final StarredReposRemoteService _remoteService;
  final StarredReposLocalService _localService;

  Future<Either<GithubFailure, Fresh<List<GithubRepo>>>> getStarredReposPage(
      int page) async {
    try {
      final remotePageItems = await _remoteService.getStarredReposPage(page);
      //TODO remove
      print('REMOTE PAGE ITEMS ${remotePageItems.toString()}');
      return right(await remotePageItems.when(
        // ^ NO CONNECTION CASE
        noConnection: () async => Fresh.no(
          await _localService.getPage(page).then((dtos) => dtos.toDomain()),
          isNextPageAvailable: page < await _localService.getLocalPageCount(),
        ),
        // ^ NOT MODIFIED CASE
        notModified: (maxPage) async {
          print('retrieving from local storage');
          Fresh<List<GithubRepo>> result = Fresh.yes(
            await _localService.getPage(page).then((dtos) => dtos.toDomain()),
            isNextPageAvailable: page < maxPage,
          );
          print('Length is: ${result.entity}');
          return result;
        },
        // ^ NEW DATA CASE
        withNewData: (data, maxPage) async {
          // Saves data to local storage

          await _localService.upsertPage(data, page);

          // Returns new data as domain entities
          return Fresh.yes(data.toDomain(),
              isNextPageAvailable: page < maxPage);
        },
      ));
    } on RestApiException catch (e) {
      return left(GithubFailure.api(e.errorCode));
    }
  }
}
