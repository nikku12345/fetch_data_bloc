
import 'package:assignment_task/bloc/home/home_event.dart';
import 'package:assignment_task/bloc/home/home_state.dart';
import 'package:assignment_task/data/home/models/home_list_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/home/repositories/hom_repositry.dart';
import '../../helper/background_task.dart';
import '../../helper/database_helper.dart';






class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DatabaseHelper databaseHelper;

  HomeBloc(this.databaseHelper) : super(HomeRepositoryLoadingState()) {
    on<HomeFetchRepositoriesEvent>((event, emit) async {
      emit(HomeRepositoryLoadingState());
      try {
        List<Repository> repositories = await databaseHelper.getRepositories();
        if (repositories.isEmpty) {
          repositories = await fetchRepositoriesHome();
          //print("repository data$repositories");
          await databaseHelper.insertRepositories(repositories);
        }
        emit(HomeRepositoryLoadedState(repositories));
      } catch (e) {
        //print("in error state");
        emit(HomeRepositoryErrorState());
      }
    });

    on<HomeRefreshRepositoriesEvent>((event, emit) async {
      emit(HomeRepositoryLoadingState());
      try {
        await refreshRepositories(databaseHelper);
        List<Repository> repositories = await databaseHelper.getRepositories();
        emit(HomeRepositoryLoadedState(repositories));
      } catch (e) {
        emit(HomeRepositoryErrorState());
      }
    });
  }
}
