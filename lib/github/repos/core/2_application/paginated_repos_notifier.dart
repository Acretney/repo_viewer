import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/core/3_domain/fresh.dart';
import 'package:repo_viewer/github/core/3_domain/github_failure.dart';
import 'package:repo_viewer/github/core/3_domain/github_repo.dart';
import 'package:repo_viewer/github/core/4_infrastructure/pagination_config.dart';

part 'paginated_repos_notifier.freezed.dart';

typedef RepositoryGetter
    = Future<Either<GithubFailure, Fresh<List<GithubRepo>>>> Function(int page);

// The previously loaded repos are provided to the 'LoadInProgress' and 'loadFailure' states so this is not odd
@freezed
class PaginatedReposState with _$PaginatedReposState {
  const PaginatedReposState._();
  // We provide an (empty) repos list to the initial state because we need a repos object in all 4 constructors to
  // call it as myState.repos - repos would not be available if it was missing from one of the constructors
  const factory PaginatedReposState.initial(Fresh<List<GithubRepo>> repos) =
      _Initial;

  // ^ LOAD IN PROGRESS CASE
  // We'll use items per page in our shimmer functionality so it knows how many loading indicators to render
  const factory PaginatedReposState.loadInProgress(
      Fresh<List<GithubRepo>> repos, int itemsPerPage) = _LoadInProgress;

  // ^ LOAD SUCCESS CASE
  const factory PaginatedReposState.loadSuccess(Fresh<List<GithubRepo>> repos,
      {required bool isNextPageAvailable}) = _LoadSuccess;

  // ^ LOAD FAILURE CASE
  const factory PaginatedReposState.loadFailure(
      Fresh<List<GithubRepo>> repos, GithubFailure failure) = _LoadFailure;
}

// ^ Facilitates calls to get more repos
// ^ Instantiates and appends to a single list of Github repos
// ^ Notifies presentation later of changes between loading, success and failure states
// ^ Provides presentation layer list of repos and GithubFailur object if failure

class PaginatedReposNotifier extends StateNotifier<PaginatedReposState> {
  // Instantiate with an empty list of repositories. Its fresh.yes because fresh.no triggers a popup
  PaginatedReposNotifier() : super(PaginatedReposState.initial(Fresh.yes([])));

  // normally you shouldnt have mutable fields in a stateNotifier but it fits our use-case in this instance
  int _page = 1;

  // RepositoryGetter is a typeDef of Future<Either<GithubFailure, Fresh<List<GithubRepo>>>> Function(int page);
  @protected
  Future<void> getNextPage(RepositoryGetter getter) async {
    state = PaginatedReposState.loadInProgress(
        state.repos, PaginationConfig.itemsPerPage);
    final failureOrRepos = await getter(_page);
    state = failureOrRepos.fold(
      (l) => PaginatedReposState.loadFailure(state.repos, l),
      (r) {
        _page++;
        return PaginatedReposState.loadSuccess(
            // Here we append the new ReposList to the existing one in the current state
            r.copyWith(entity: [
              ...state.repos.entity,
              ...r.entity,
            ]),
            isNextPageAvailable: r.isNextPageAvailable ?? false);
      },
    );
  }
}
