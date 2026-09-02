import 'package:flutter/material.dart';

import '../../../injection.dart';
import '../data/item_repository.dart';
import '../data/models/item_model.dart';

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({required this.id, super.key});

  final String id;

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final ItemRepository _itemRepository = getIt<ItemRepository>();
  Item? _item;

  @override
  void initState() {
    super.initState();
    _itemRepository
        .fetchItem(widget.id)
        .then((item) {
          if (mounted) {
            setState(() => _item = item);
          }
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    return Scaffold(
      appBar: AppBar(title: const Text('Salary detail')),
      body: item == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(label: 'Amount', value: '${item.money} CZK'),
                  const Divider(),
                  _DetailRow(label: 'Period', value: item.period),
                  const Divider(),
                  _DetailRow(label: 'Year', value: item.year.toString()),
                  const Divider(),
                  _DetailRow(label: 'Month', value: item.month.toString()),
                ],
              ),
            ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
