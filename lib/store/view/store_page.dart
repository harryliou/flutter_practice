import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store/store/store.dart';
import 'package:goods_repository/goods_repository.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

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
        title: const Text('Store'),
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
        ],
        child: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            final listBloc = context.watch<ListBloc>();
            if (state.goods.isEmpty) {
              if (state.status == ListStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != ListStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    'No Goods',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = constraints.maxHeight;
                final scrollHeight = screenHeight * 0.7;
                final columnHeight = screenHeight - scrollHeight;

                return Column(
                  children: [
                    SizedBox(
                      height: scrollHeight,
                      child: CupertinoScrollbar(
                        child: ListView.builder(
                          itemCount: state.atStoreGoods.length,
                          itemBuilder: (context, index) {
                            final goods = state.atStoreGoods[index];
                            final isFirstItem = index == 0;
                            final isLastItem =
                                index == state.atStoreGoods.length;
                            final shouldAddDivider =
                                !isFirstItem && !isLastItem;
                            return Column(
                              children: [
                                if (shouldAddDivider)
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: const Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                GoodsListTitle(
                                  goods: goods,
                                  onDismissed: (_) {
                                    context.read<ListBloc>().add(
                                          ListGoodsReomveFromStore(
                                            goods: goods,
                                          ),
                                        );
                                  },
                                  onTap: () {
                                    showModalBottomSheet<Widget>(
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: 200,
                                          child: CupertinoPicker(
                                            scrollController:
                                                FixedExtentScrollController(
                                              initialItem:
                                                  goods.atStoreQuantity,
                                            ),
                                            itemExtent: 32,
                                            onSelectedItemChanged: (index) {
                                              listBloc.add(
                                                ListAtStoreQuantityChanged(
                                                  goods: goods,
                                                  atStoreQuantity: index,
                                                ),
                                              );
                                            },
                                            children: List.generate(
                                              (goods.quantity -
                                                      goods.soldQuantity) +
                                                  1,
                                              (index) => Text(
                                                index.toString(),
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: columnHeight,
                      child: Column(
                        // 下半部分的內容
                        children: [
                          Text('Total items: ${state.atStoreGoods.length}'),
                          Text('Total price: ${state.atStoreGoodsTotalPrice}'),
                          ElevatedButton(
                            onPressed: () {
                              listBloc.add(
                                const ListAtStoreSell(),
                              );
                            },
                            child: const Text('Sell'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
