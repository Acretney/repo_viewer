import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../../core/3_domain/github_repo.dart';
import '../../core/shared/providers.dart';

class RepoDetailPage extends ConsumerStatefulWidget {
  const RepoDetailPage({Key? key, required this.repo}) : super(key: key);

  final GithubRepo repo;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RepoDetailPageState();
}

class _RepoDetailPageState extends ConsumerState<RepoDetailPage> {
  @override
  void initState() {
    super.initState();
    ref
        .read(repoDetailNotifierProvider.notifier)
        .getRepoDetail(widget.repo.fullName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: widget.repo.fullName,
              child: CircleAvatar(
                radius: 16,
                backgroundImage: CachedNetworkImageProvider(
                  widget.repo.owner.avatarUrlSmall,
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(widget.repo.name))
          ],
        ),
      ),
    );
  }
}
