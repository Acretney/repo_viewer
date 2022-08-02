import 'package:collection/collection.dart';
import 'package:sembast/sembast.dart';
import 'package:repo_viewer/core/4_infrastructure/sembast_database.dart';
import 'package:repo_viewer/github/core/4_infrastructure/pagination_config.dart';
import '../../../core/4_infrastructure/github_repo_dto.dart';

// ^ A) Creates local storage space for GithubRepoDTOs
// ^ B) Facilitates Saving and Retrieval of GithubRepoDTOs via JSON conversion

class StarredReposLocalService {
  StarredReposLocalService(this._sembastDatabase);

  final SembastDatabase _sembastDatabase;
  final _store = intMapStoreFactory.store('starredRepos');

  // Will either insert or update a page
  Future<void> upsertPage(List<GithubRepoDTO> dtos, int page) async {
    final sembastPage = page - 1;

    // We are saying there will be 3 items on one page 0, 1, 2 || 3, 4, 5 || 6, 7, 8
    await _store
        .records(
          dtos.mapIndexed((index, _) =>
              index + (PaginationConfig.itemsPerPage * sembastPage)),
        )
        .put(_sembastDatabase.instance, dtos.map((e) => e.toJson()).toList());
  }

  // paginates local database
  Future<List<GithubRepoDTO>> getPage(int page) async {
    final sembastPage = page - 1;

    final records = await _store.find(
      _sembastDatabase.instance,
      finder: Finder(
        // There are 3 items per page so we only want to receive 3 items per find operation
        limit: PaginationConfig.itemsPerPage,
        // Where to begin next find operation from
        offset: PaginationConfig.itemsPerPage * sembastPage,
      ),
    );
    return records.map((e) => GithubRepoDTO.fromJson(e.value)).toList();
  }

  Future<int> getLocalPageCount() async {
    final repoCount = await _store.count(_sembastDatabase.instance);
    return (repoCount / PaginationConfig.itemsPerPage).ceil();
  }
}
