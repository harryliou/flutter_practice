import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store/list/list.dart';

@visibleForTesting
enum ListOption { toggleAll }

class ListOptionsButton extends StatelessWidget {
  const ListOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final goods = context.select((ListBloc bloc) => bloc.state.goods);
    final hasGoods = goods.isNotEmpty;
    final atStoreAmount = goods.where((goods) => goods.atStore).length;

    return PopupMenuButton<ListOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      onSelected: (options) {
        switch (options) {
          case ListOption.toggleAll:
            context.read<ListBloc>().add(const ListToggleAllRequested());
            break;
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ListOption.toggleAll,
            enabled: hasGoods,
            child: Text(
              atStoreAmount == goods.length
                  ? 'Mark All Not In Store'
                  : 'Mark All In Store',
            ),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
