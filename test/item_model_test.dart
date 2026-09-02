import 'package:flutter_test/flutter_test.dart';
import 'package:salary_app/features/items/data/models/item_model.dart';

void main() {
  group('Item.fromJson', () {
    test('parses the salary payload', () {
      final item = Item.fromJson({
        'id': '9d1a7b0e-0000-4000-8000-000000000001',
        'money': 55000,
        'year': 2024,
        'month': 3,
        'createdAt': '2024-03-31T10:00:00+00:00',
      });

      expect(item.id, '9d1a7b0e-0000-4000-8000-000000000001');
      expect(item.money, 55000);
      expect(item.period, '03/2024');
    });

    test('tolerates a missing createdAt', () {
      final item = Item.fromJson({
        'id': 'abc',
        'money': 1000,
        'year': 2023,
        'month': 12,
      });

      expect(item.createdAt, isNull);
      expect(item.period, '12/2023');
    });
  });
}
