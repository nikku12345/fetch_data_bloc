// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repository _$RepositoryFromJson(Map<String, dynamic> json) => Repository(
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      htmlUrl: json['html_url'] as String,
      description: json['description'] as String?,
      stargazersCount: (json['stargazers_count'] as num).toInt(),
    );

Map<String, dynamic> _$RepositoryToJson(Repository instance) =>
    <String, dynamic>{
      'name': instance.name,
      'full_name': instance.fullName,
      'html_url': instance.htmlUrl,
      'description': instance.description,
      'stargazers_count': instance.stargazersCount,
    };
