import 'package:repo_viewer/github/repos/core/2_application/paginated_repos_notifier.dart';
import '../4_infrastructure/searched_repos_repository.dart';

// ^ A) Extends all the functionality of the PaginatedReposNotifier (which is shared with our searched repos feature)
// ^ B) Returns value of getNextPage from the StarredReposRepository

class SearchedReposNotifier extends PaginatedReposNotifier {
  SearchedReposNotifier(this._repository);

  final SearchedReposRepository _repository;

  Future<void> getFirstSearchedReposPage(String query) async {
    super.resetState();
    await getNextSearchedReposPage(query);
  }

  Future<void> getNextSearchedReposPage(String query) async {
    super.getNextPage((page) => _repository.getSearchedReposPage(query, page));
  }
}
