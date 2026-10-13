import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../injection.dart';
import 'models/item_model.dart';

class ItemRepository {
  ItemRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<Response<dynamic>> fetchItems({
    required int page,
    required int limit,
  }) {
    return _apiClient.dio.get<dynamic>(
      '/${AppConfig.salariesResource}',
      queryParameters: {'page': page, 'limit': limit},
    );
  }

  Future<Item> fetchItem(String id) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      '/${AppConfig.salariesResource}/$id',
    );
    return Item.fromJson(response.data!);
  }
}
