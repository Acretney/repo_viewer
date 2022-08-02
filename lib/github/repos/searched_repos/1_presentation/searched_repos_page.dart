import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../auth/shared/providers.dart';
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
    Future.microtask(
      () => ref
          .read(searchedReposNotifierProvider.notifier)
          .getNextSearchedReposPage(widget.searchTerm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.searchTerm), actions: [
        IconButton(
          icon: const Icon(MdiIcons.logoutVariant),
          onPressed: () {
            ref.read(authNotifierProvider.notifier).signOut();
          },
        ),
      ]),
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
    );
  }
}
