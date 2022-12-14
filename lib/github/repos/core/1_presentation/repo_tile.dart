import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:repo_viewer/core/1_presentation/routes/app_router.gr.dart';

import '../../../core/3_domain/github_repo.dart';

class RepoTile extends StatelessWidget {
  const RepoTile({Key? key, required this.repo}) : super(key: key);

  final GithubRepo repo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(repo.fullName),
      subtitle: Text(
        repo.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Hero(
        tag: repo.fullName,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage:
              CachedNetworkImageProvider(repo.owner.avatarUrlSmall),
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star_border),
          Text(
            repo.stargazersCount.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
      onTap: () {
        AutoRouter.of(context).push(RepoDetailRoute(repo: repo));
      },
    );
  }
}
