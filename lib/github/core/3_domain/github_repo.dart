import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_viewer/github/core/3_domain/user.dart';

part 'github_repo.freezed.dart';

@freezed
class GithubRepo with _$GithubRepo {
  const GithubRepo._();
  const factory GithubRepo({
    required User owner,
    required String name,
    required String description,
    required int stargazersCount,
  }) = _GithubRepo;

// This returns a given repository path - Always provide getters for entities to hide the structure from
// other parts of the app
  String get fullName => '${owner.name}/$name';
}
