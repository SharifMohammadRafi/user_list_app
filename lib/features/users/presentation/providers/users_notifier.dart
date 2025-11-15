import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di/locator.dart';
import '../../../users/domain/entities/user.dart';
import '../../../users/domain/repositories/user_repository.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/utils/connectivity_service.dart';

final repositoryProvider = Provider<UserRepository>(
  (ref) => getIt<UserRepository>(),
);

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(),
);

class UsersState extends Equatable {
  final List<User> items;
  final int page;
  final int perPage;
  final int totalPages;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool offline;
  final String searchQuery;
  final bool cacheStale;

  const UsersState({
    this.items = const [],
    this.page = 1,
    this.perPage = 10,
    this.totalPages = 1,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.offline = false,
    this.searchQuery = '',
    this.cacheStale = false,
  });

  UsersState copyWith({
    List<User>? items,
    int? page,
    int? perPage,
    int? totalPages,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? offline,
    String? searchQuery,
    bool? cacheStale,
    bool clearError = false,
  }) {
    return UsersState(
      items: items ?? this.items,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
      offline: offline ?? this.offline,
      searchQuery: searchQuery ?? this.searchQuery,
      cacheStale: cacheStale ?? this.cacheStale,
    );
  }

  bool get hasMore => page < totalPages;

  List<User> get filteredItems {
    final q = _normalize(searchQuery);
    if (q.isEmpty) return items;
    return items.where((u) {
      final name = _normalize(u.fullName);
      return name.contains(q);
    }).toList();
  }

  String _normalize(String s) {
    final t = s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    return t;
  }

  @override
  List<Object?> get props => [
    items,
    page,
    perPage,
    totalPages,
    isLoading,
    isLoadingMore,
    error,
    offline,
    searchQuery,
    cacheStale,
  ];
}

class UsersNotifier extends StateNotifier<UsersState> {
  final UserRepository repo;
  final ConnectivityService connectivity;
  StreamSubscription? _connSub;

  UsersNotifier(this.repo, this.connectivity) : super(const UsersState()) {
    _observeConnectivity();
    loadInitial();
  }

  void _observeConnectivity() {
    _connSub = connectivity.onConnectivityChanged.listen((result) async {
      final online = await connectivity.isOnline;
      state = state.copyWith(offline: !online);
    });
  }

  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true, page: 1, clearError: true);
    try {
      final paged = await repo.getUsers(page: 1, perPage: state.perPage);
      final ts = await repo.cacheTimestamp();
      final cacheStale = ts == null
          ? true
          : DateTime.now().difference(ts) > const Duration(hours: 1);
      state = state.copyWith(
        items: paged.users,
        page: paged.page,
        totalPages: paged.totalPages,
        isLoading: false,
        cacheStale: cacheStale,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong.');
    }
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isLoadingMore) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final nextPage = state.page + 1;
      final paged = await repo.getUsers(page: nextPage, perPage: state.perPage);
      final merged = [...state.items, ...paged.users];
      state = state.copyWith(
        items: merged,
        page: paged.page,
        totalPages: paged.totalPages,
        isLoadingMore: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.message);
    } catch (_) {
      state = state.copyWith(
        isLoadingMore: false,
        error: 'Failed to load more.',
      );
    }
  }

  void setSearchQuery(String q) {
    state = state.copyWith(searchQuery: q);
  }

  @override
  void dispose() {
    _connSub?.cancel();
    super.dispose();
  }
}

final usersNotifierProvider = StateNotifierProvider<UsersNotifier, UsersState>((
  ref,
) {
  final repo = ref.watch(repositoryProvider);
  final conn = ref.watch(connectivityServiceProvider);
  return UsersNotifier(repo, conn);
});
