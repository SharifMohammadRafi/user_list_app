import '../../domain/entities/paged_users.dart';
import '../../domain/entities/user.dart';
import 'user_model.dart';

class PagedUsersModel extends PagedUsers {
  const PagedUsersModel({
    required super.page,
    required super.perPage,
    required super.total,
    required super.totalPages,
    required super.users,
  });

  factory PagedUsersModel.fromJson(Map<String, dynamic> json) {
    final List<User> users = (json['data'] as List<dynamic>? ?? [])
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PagedUsersModel(
      page: json['page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? users.length,
      total: json['total'] as int? ?? users.length,
      totalPages: json['total_pages'] as int? ?? 1,
      users: users,
    );
  }
}
