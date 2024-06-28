import 'package:json_annotation/json_annotation.dart';

part 'home_list_model.g.dart';

@JsonSerializable()
class Repository {
  final String name;
  final String fullName;
  final String htmlUrl;
  final String? description;
  final int stargazersCount;

  Repository({
    required this.name,
    required this.fullName,
    required this.htmlUrl,
    this.description,
    required this.stargazersCount,
  });

  factory Repository.fromJson(Map<String, dynamic> json) => _$RepositoryFromJson(json);

  Map<String, dynamic> toJson() => _$RepositoryToJson(this);
}
