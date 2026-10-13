import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/data/auth_repository.dart';
import '../data/item_repository.dart';
import '../data/models/item_model.dart';
import 'item_list_state.dart';

class ItemListCubit extends Cubit<ItemListState> {
  ItemListCubit(this._itemRepository, this._authRepository)
    : super(const ItemListState()) {
    _sessionSubscription = _authRepository.sessionStream.listen((event) {
      if (event == SessionEvent.loggedOut) {
        _items.clear();
        _page = 1;
        emit(const ItemListState());
      }
    });
  }

  final ItemRepository _itemRepository;
  final AuthRepository _authRepository;

  final List<Item> _items = [];
  int _page = 1;
  static const int _pageSize = 20;

  late final StreamSubscription<SessionEvent> _sessionSubscription;

  Future<void> loadFirstPage() async {
    emit(state.copyWith(isLoading: true));
    _page = 1;
    _items.clear();
    try {
      final response = await _itemRepository.fetchItems(
        page: _page,
        limit: _pageSize,
      );
      _items.addAll(_parse(response));
      emit(state.copyWith(items: _items, isLoading: false));
    } on DioException catch (error) {
      emit(state.copyWith(isLoading: false, error: _messageFor(error)));
    }
  }

  Future<void> loadNextPage() async {
    _page++;
    try {
      final response = await _itemRepository.fetchItems(
        page: _page,
        limit: _pageSize,
      );
      _items.addAll(_parse(response));
      emit(state.copyWith(items: _items));
    } on DioException catch (error) {
      emit(state.copyWith(error: _messageFor(error)));
    }
  }

  List<Item> _parse(Response<dynamic> response) {
    final data = response.data as Map<String, dynamic>;
    final rawItems = data['items'] as List<dynamic>;
    return rawItems
        .map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String _messageFor(DioException error) {
    switch (error.response?.statusCode) {
      case 401:
        return 'Your session has expired.';
      case 403:
        return 'You do not have access to this resource.';
      case 404:
        return 'Nothing was found.';
      default:
        return 'Something went wrong, please try again.';
    }
  }

  void dispose() {
    _sessionSubscription.cancel();
  }
}
