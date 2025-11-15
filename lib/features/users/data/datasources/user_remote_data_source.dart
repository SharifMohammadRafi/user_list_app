//
import 'package:dio/dio.dart';
import 'package:task_app/features/users/data/models/paged_users_model.dart';
import 'package:task_app/features/users/domain/entities/paged_users.dart';
import '../../../../core/error/app_exception.dart';

class UserRemoteDataSource {
  final Dio _dio;
  UserRemoteDataSource(this._dio);

  Future<PagedUsers> getUsers({required int page, required int perPage}) async {
    try {
      final res = await _dio.get(
        '/users',
        queryParameters: {'per_page': perPage, 'page': page},
      );
      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        return PagedUsersModel.fromJson(res.data as Map<String, dynamic>);
      }
      throw AppException('Unexpected server response');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw AppException(
          'Request timed out. Please try again.',
          code: 'timeout',
        );
      }
      if (e.type == DioExceptionType.connectionError) {
        throw AppException('No internet connection.', code: 'offline');
      }
      throw AppException('Failed to load users. ${e.message!}');
    } catch (e) {
      throw AppException('Failed to load users.');
    }
  }
}
