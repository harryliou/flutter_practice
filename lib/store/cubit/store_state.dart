part of 'store_cubit.dart';

enum StoreTab { todos, stats }

class StoreState extends Equatable {
  const StoreState({
    this.tab = StoreTab.todos,
  });

  final StoreTab tab;

  @override
  List<Object> get props => [tab];
}
