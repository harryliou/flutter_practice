import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store/edit_goods/edit_goods.dart';
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
      child: const GoodsListView(),
    );
  }
}

class GoodsListView extends StatelessWidget {
  const GoodsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('庫存'),
        actions: const [
          ListFilterButton(),
          ListOptionsButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_addTodo_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(EditGoodsPage.route()),
        child: const Icon(Icons.add),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ListBloc, ListState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == ListStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('List Failure')),
                  );
              }
            },
          ),
          BlocListener<ListBloc, ListState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedGoods != current.lastDeletedGoods &&
                current.lastDeletedGoods != null,
            listener: (context, state) {
              final deltedGoods = state.lastDeletedGoods!;
              final messager = ScaffoldMessenger.of(context);
              messager
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      '已刪除精油項目: ${deltedGoods.name}',
                    ),
                    action: SnackBarAction(
                      label: '取消並回復',
                      onPressed: () {
                        messager.hideCurrentSnackBar();
                        context
                            .read<ListBloc>()
                            .add(const ListUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<ListBloc, ListState>(builder: (context, state) {
          if (state.goods.isEmpty) {
            if (state.status == ListStatus.loading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state.status != ListStatus.success) {
              return const SizedBox();
            } else {
              return Center(
                child: Text(
                  '無精油',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }
          }

          return CupertinoScrollbar(
            child: ListView.builder(
              itemCount: state.filteredGoods.length,
              itemBuilder: (context, index) {
                final goods = state.filteredGoods[index];
                final isFirstItem = index == 0;
                final isLastItem = index == state.filteredGoods.length;
                final shouldAddDivider = !isFirstItem && !isLastItem;
                return Column(
                  children: [
                    if (shouldAddDivider)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    GoodsListTitle(
                      goods: goods,
                      onToggleAtStore: (atStore) {
                        context.read<ListBloc>().add(
                              ListGoodsAtStoreToggled(
                                goods: goods,
                                atStore: atStore,
                              ),
                            );
                      },
                      onDismissed: (_) {
                        context.read<ListBloc>().add(ListGoodsDeleted(goods));
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          EditGoodsPage.route(initialGoods: goods),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
