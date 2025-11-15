import '../../domain/entities/paged_users.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/paged_users_model.dart';
import '../models/user_model.dart';
import '../../../../core/error/app_exception.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final UserLocalDataSource local;

  UserRepositoryImpl({required this.remote, required this.local});

  @override
  Future<PagedUsers> getUsers({
    required int page,
    required int perPage,
    bool useCacheIfAvailable = true,
  }) async {
    try {
      final paged = await remote.getUsers(page: page, perPage: perPage);

      final cached = await loadCachedUsers() ?? [];
      final asMap = {for (var u in cached) u['id'] as int: u};

      for (final u in paged.users) {
        final um = UserModel(
          id: u.id,
          email: u.email,
          firstName: u.firstName,
          lastName: u.lastName,
          avatar: u.avatar,
        );
        asMap[um.id] = um.toJson();
      }

      final updatedList = asMap.values.cast<Map<String, dynamic>>().toList()
        ..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
      await cacheUsers(updatedList);

      return paged;
    } on AppException {
      if (useCacheIfAvailable) {
        final raw = await loadCachedUsers();
        if (raw != null && raw.isNotEmpty) {
          final allUsers = raw.map((e) => UserModel.fromJson(e)).toList();
          final start = (page - 1) * perPage;
          final end = (start + perPage).clamp(0, allUsers.length);
          final pageUsers = (start < allUsers.length)
              ? allUsers.sublist(start, end)
              : <User>[];
          final totalPages = (allUsers.length / perPage).ceil().clamp(1, 999);
          return PagedUsersModel(
            page: page,
            perPage: perPage,
            total: allUsers.length,
            totalPages: totalPages,
            users: pageUsers,
          );
        }
      }
      rethrow;
    }
  }

  @override
  Future<void> cacheUsers(List<Map<String, dynamic>> rawUsers) {
    return local.cacheUsers(rawUsers);
  }

  @override
  Future<List<Map<String, dynamic>>?> loadCachedUsers() {
    return local.loadUsers();
  }

  @override
  Future<DateTime?> cacheTimestamp() => local.getCacheTimestamp();
}
