part of 'home_cubit.dart';

sealed class HomeCubitState {}

final class HomeCubitInitial extends HomeCubitState {}

final class LoadingRecentActivity extends HomeCubitState {}

final class LoadingRecommendation extends HomeCubitState {}

final class LoadedRecentActivity extends HomeCubitState {}

final class LoadedRecommendation extends HomeCubitState {}

final class HomeCubitFailure extends HomeCubitState {
  final String message;
  HomeCubitFailure(this.message);
}
