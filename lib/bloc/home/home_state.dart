



import '../../data/home/models/home_list_model.dart';


abstract class HomeState {}

class HomeRepositoryLoadingState extends HomeState {}

class HomeRepositoryLoadedState extends HomeState {
  final List<Repository> repositories;

  HomeRepositoryLoadedState(this.repositories);
}

class HomeRepositoryErrorState extends HomeState {}
