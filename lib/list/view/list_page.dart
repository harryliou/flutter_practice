import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store/list/list.dart';
import 'package:goods_repository/goods_repository.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListBloc(
        goodsRepository: context.read<GoodsRepository>(),
      )..add(const ListSubscriptionRequested()),
      child: const ListView(),
    );
  }
}

class ListView extends StatelessWidget {
  const ListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('List of Goods'),
        actions: const [
          ListFilterButton(),
          ListOptionsButton(),
        ],
      ),
    );
  }
}
