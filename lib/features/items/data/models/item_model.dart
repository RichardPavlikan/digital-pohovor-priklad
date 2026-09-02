import 'package:equatable/equatable.dart';

/// A single salary record returned by the collection endpoint.
class Item extends Equatable {
  const Item({
    required this.id,
    required this.money,
    required this.year,
    required this.month,
    this.createdAt,
  });

  final String id;
  final int money;
  final int year;
  final int month;
  final DateTime? createdAt;

  String get period => '${month.toString().padLeft(2, '0')}/$year';

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      money: (json['money'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, money, year, month, createdAt];
}
