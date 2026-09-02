import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/item_model.dart';
import 'item_detail_page.dart';
import 'item_list_cubit.dart';
import 'item_list_state.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<ItemListCubit>().loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salaries'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<ItemListCubit>().loadFirstPage();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: BlocBuilder<ItemListCubit, ItemListState>(
                builder: (context, state) {
                  if (state.isLoading && state.items.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null && state.items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red.shade300,
                            ),
                            SizedBox(height: 12),
                            Text(
                              state.error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                context.read<ItemListCubit>().loadFirstPage();
                              },
                              child: Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state.items.isEmpty) {
                    return _buildEmptyState();
                  }
                  return RefreshIndicator(
                    onRefresh: () {
                      return context.read<ItemListCubit>().loadFirstPage();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          color: Colors.grey.shade100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${state.items.length} records',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              if (state.error != null)
                                Text(
                                  state.error!,
                                  style: TextStyle(
                                    color: Colors.red.shade400,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            children: [
                              for (final item in state.items)
                                _buildItemCard(item),
                              if (state.isLoading)
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.blueGrey.shade50,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.payments_outlined, color: Colors.blueGrey.shade700),
          SizedBox(width: 8),
          Text(
            'Monthly salaries',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(Item item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ItemDetailPage(id: item.id)),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    item.month.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.money} CZK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Period ${item.period}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
          SizedBox(height: 12),
          Text(
            'No salaries yet',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
