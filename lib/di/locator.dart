import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:task_app/core/network/dio_client.dart';
import '../features/users/data/datasources/user_local_data_source.dart';
import '../features/users/data/datasources/user_remote_data_source.dart';
import '../features/users/data/repositories/user_repository_impl.dart';
import '../features/users/domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<Dio>(() => buildDioClient());

  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSource());

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remote: getIt<UserRemoteDataSource>(),
      local: getIt<UserLocalDataSource>(),
    ),
  );
}
