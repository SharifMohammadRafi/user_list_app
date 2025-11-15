import '../entities/paged_users.dart';

abstract class UserRepository {
  Future<PagedUsers> getUsers({
    required int page,
    required int perPage,
    bool useCacheIfAvailable = true,
  });

  Future<void> cacheUsers(List<Map<String, dynamic>> rawUsers);
  Future<List<Map<String, dynamic>>?> loadCachedUsers();
  Future<DateTime?> cacheTimestamp();
}
