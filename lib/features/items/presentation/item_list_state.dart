import 'package:equatable/equatable.dart';

import '../data/models/item_model.dart';

class ItemListState extends Equatable {
  const ItemListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  final List<Item> items;
  final bool isLoading;
  final String? error;

  ItemListState copyWith({List<Item>? items, bool? isLoading, String? error}) {
    return ItemListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, error];
}
