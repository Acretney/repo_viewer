import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../auth/shared/providers.dart';
import '../../../../core/1_presentation/routes/app_router.gr.dart';
import '../../../../search/1_presentation/search_bar.dart';
import '../../../core/shared/providers.dart';
import '../../core/1_presentation/paginated_repos_list_view.dart';

class SearchedReposPage extends ConsumerStatefulWidget {
  const SearchedReposPage({Key? key, required this.searchTerm})
      : super(key: key);

  final String searchTerm;

  @override
  _SearchedReposPageState createState() => _SearchedReposPageState();
}

class _SearchedReposPageState extends ConsumerState<SearchedReposPage> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(
    //   () => ref
    //       .read(searchedReposNotifierProvider.notifier)
    //       .getFirstSearchedReposPage(widget.searchTerm),
    // );
    ref
        .read(searchedReposNotifierProvider.notifier)
        .getFirstSearchedReposPage(widget.searchTerm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchBar(
        hint: 'Search all repositories...',
        title: widget.searchTerm,
        onShouldNavigateToResultPage: (searchTerm) {
          AutoRouter.of(context).pushAndPopUntil(
            SearchedReposRoute(searchTerm: searchTerm),
            predicate: (route) => route.settings.name == StarredReposRoute.name,
          );
        },
        onSignoutButtonPressed: () =>
            ref.read(authNotifierProvider.notifier).signOut(),
        body: PaginatedReposListView(
          paginatedReposNotifierProvider: searchedReposNotifierProvider,
          getNextPage: (ref) {
            ref
                .read(searchedReposNotifierProvider.notifier)
                .getNextSearchedReposPage(widget.searchTerm);
          },
          noResultsMessage:
              "This is all we could find for your search term. Really...",
        ),
      ),
    );
  }
}
