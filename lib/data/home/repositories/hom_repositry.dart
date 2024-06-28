import 'package:assignment_task/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import '../models/home_list_model.dart';


Future<List<Repository>> fetchRepositoriesHome() async {
  final response = await http.get(Uri.parse(
      '${AppConfig.url}/search/repositories?q=created:%3E2022-04-29&sort=stars&order=desc'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    debugPrint("response from api$data",wrapWidth: 1024);
    final List<Repository> repositories = (data['items'] as List)
        .map((item) => Repository.fromJson(item))
        .toList();
    print("response of repo$repositories");
    return repositories;
  } else {
    throw Exception('Failed to load repositories');
  }
}
