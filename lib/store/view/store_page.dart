import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        title: const Text('商店'),
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
                    '無精油',
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
                                    showDialog<Widget>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => AlertDialog(
                                        title: const Text('設定即將售出數量'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('精油: ${goods.name}'),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            TextFormField(
                                              initialValue: goods
                                                  .atStoreQuantity
                                                  .toString(),
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 25,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    25),
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[Z0-9\s]')),
                                              ],
                                              onChanged: (value) {
                                                var maxNumber = goods.quantity -
                                                    goods.soldQuantity;
                                                if (maxNumber < 0) {
                                                  maxNumber = 0;
                                                }
                                                if (value == '') {
                                                  value = '0';
                                                }
                                                final valueInt =
                                                    int.parse(value);
                                                if (valueInt > maxNumber) {
                                                  showDialog<Widget>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text('錯誤'),
                                                      content: Text(
                                                          '即將售出數量不可大於目前庫存數量: $maxNumber'),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                              context,
                                                            ).popUntil(
                                                                (route) => route
                                                                    .isFirst);
                                                          },
                                                          child:
                                                              const Text('返回'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  listBloc.add(
                                                    ListAtStoreQuantityChanged(
                                                      goods: goods,
                                                      atStoreQuantity:
                                                          maxNumber,
                                                    ),
                                                  );
                                                  // Navigator.of(context).pop();
                                                } else {
                                                  listBloc.add(
                                                    ListAtStoreQuantityChanged(
                                                      goods: goods,
                                                      atStoreQuantity: valueInt,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('返回'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                    //   showModalBottomSheet<Widget>(
                                    //     context: context,
                                    //     builder: (context) {
                                    //       return Column(
                                    //         children: [
                                    //           Text(
                                    //             '設定${goods.name}即將售出數量',
                                    //           ),
                                    //           SizedBox(
                                    //             height: 200,
                                    //             child: CupertinoPicker(
                                    //               scrollController:
                                    //                   FixedExtentScrollController(
                                    //                 initialItem:
                                    //                     goods.atStoreQuantity,
                                    //               ),
                                    //               itemExtent: 32,
                                    //               onSelectedItemChanged: (index) {
                                    //                 listBloc.add(
                                    //                   ListAtStoreQuantityChanged(
                                    //                     goods: goods,
                                    //                     atStoreQuantity: index,
                                    //                   ),
                                    //                 );
                                    //               },
                                    //               children: List.generate(
                                    //                 ((goods.quantity -
                                    //                             goods
                                    //                                 .soldQuantity) >=
                                    //                         0)
                                    //                     ? (goods.quantity -
                                    //                             goods
                                    //                                 .soldQuantity) +
                                    //                         1
                                    //                     : 1,
                                    //                 (index) => Text(
                                    //                   index.toString(),
                                    //                   style: const TextStyle(
                                    //                     fontSize: 20,
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       );
                                    //     },
                                    //   );
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
                        children: [
                          Text('目前商店精油總數量: ${state.atStoreGoods.length}'),
                          Text('即將售出價格: ${state.atStoreGoodsTotalPrice}'),
                          ElevatedButton(
                            onPressed: () {
                              listBloc.add(
                                const ListAtStoreSell(),
                              );
                            },
                            child: const Text('售出'),
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
