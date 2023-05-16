import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store/list/list.dart';

class ListFilterButton extends StatelessWidget {
  const ListFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter = context.select((ListBloc bloc) => bloc.state.filter);

    return PopupMenuButton<GoodsViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      onSelected: (filter) {
        context.read<ListBloc>().add(ListFilterChanged(filter));
      },
      itemBuilder: (context) {
        return const [
          PopupMenuItem(
            value: GoodsViewFilter.all,
            child: Text('ALL'),
          ),
          PopupMenuItem(
            value: GoodsViewFilter.notAtStoreOnly,
            child: Text('Not in Store Only'),
          ),
          PopupMenuItem(
            value: GoodsViewFilter.atStoreOnly,
            child: Text('In Store Only'),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
