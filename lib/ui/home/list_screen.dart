import 'package:assignment_task/app_config.dart';
import 'package:assignment_task/bloc/home/home_bloc.dart';
import 'package:assignment_task/common/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';





class RepositoryListScreen extends StatelessWidget {
  const RepositoryListScreen({super.key});
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text(AppConfig.aapName)),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeRepositoryLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeRepositoryLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(HomeRefreshRepositoriesEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data refresh completed')),
                );
              },
              child: ListView.builder(
                itemCount: state.repositories.length,
                itemBuilder: (context, index) {
                  final repo = state.repositories[index];
                  return InkWell(
                    onTap: (){
                      _launchURL(repo.htmlUrl);
                    },
                    child: Card(

                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              repo.name,
                              style: AppTextStyles.headline,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              repo.description ?? 'No description',
                              style: AppTextStyles.bodyText1,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${repo.stargazersCount}',
                                      style:AppTextStyles.bodyText2
                                    ),
                                  ],
                                ),
                                // Add more widgets here for additional information or actions
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                },
              ),
            );
          } else if (state is HomeRepositoryErrorState) {
            return const Center(child: Text('Failed to load repositories. Please check your internet connection and try again.'));
          }
          return Container();
        },
      ),
    );
  }
}
