// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_viewer/github/core/4_infrastructure/user_dto.dart';

import '../3_domain/github_repo.dart';

part 'github_repo_dto.freezed.dart';
part 'github_repo_dto.g.dart';

// ^ This handles cases where descriptions are null. We do not want to make the description field (or any field)
// ^ nullable if we can help it. We can pass this function via the @JsonKey parameter to have the conversion return
// ^ an empty string if the description is null
String _descriptionFromJson(Object? json) {
  return (json as String?) ?? '';
}

@freezed
class GithubRepoDTO with _$GithubRepoDTO {
  const GithubRepoDTO._();
  const factory GithubRepoDTO({
    // We depend on the UserDTO not the User class from domain
    required UserDTO owner,
    required String name,
    // Ensuring we never receive null
    @JsonKey(fromJson: _descriptionFromJson) required String description,
    // This is the only field with a different json key or type to our field name or type
    @JsonKey(name: 'stargazers_count') required int stargazersCount,
  }) = _GithubRepoDTO;

  factory GithubRepoDTO.fromJson(Map<String, dynamic> json) =>
      _$GithubRepoDTOFromJson(json);

  factory GithubRepoDTO.fromDomain(GithubRepo _) {
    return GithubRepoDTO(
        owner: UserDTO.fromDomain(_.owner),
        name: _.name,
        description: _.description,
        stargazersCount: _.stargazersCount);
  }

  GithubRepo toDomain() {
    return GithubRepo(
      owner: owner.toDomain(),
      name: name,
      description: description,
      stargazersCount: stargazersCount,
    );
  }
}
