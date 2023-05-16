import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_store/list/list.dart';
import 'package:goods_repository/goods_repository.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc({
    required GoodsRepository goodsRepository,
  })  : _goodsRepository = goodsRepository,
        super(const ListState()) {
    on<ListSubscriptionRequested>(_onSubscriptionRequested);
    on<ListTodoAtStoreToggled>(_onTodoCompletionToggled);
    on<ListTodoDeleted>(_onTodoDeleted);
    on<ListUndoDeletionRequested>(_onUndoDeletionRequested);
    on<ListFilterChanged>(_onFilterChanged);
    on<ListToggleAllRequested>(_onToggleAllRequested);
  }

  final GoodsRepository _goodsRepository;

  Future<void> _onSubscriptionRequested(
    ListSubscriptionRequested event,
    Emitter<ListState> emit,
  ) async {
    emit(state.copyWith(status: () => ListStatus.loading));

    await emit.forEach<List<Goods>>(
      _goodsRepository.getGoods(),
      onData: (goods) => state.copyWith(
        status: () => ListStatus.success,
        goods: () => goods,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ListStatus.failure,
      ),
    );
  }

  Future<void> _onTodoCompletionToggled(
    ListTodoAtStoreToggled event,
    Emitter<ListState> emit,
  ) async {
    final newGoods = event.goods.copyWith(atStore: event.atStore);
    await _goodsRepository.saveGoods(newGoods);
  }

  Future<void> _onTodoDeleted(
    ListTodoDeleted event,
    Emitter<ListState> emit,
  ) async {
    emit(state.copyWith(lastDeletedGoods: () => event.goods));
    await _goodsRepository.deleteGoods(event.goods.id);
  }

  Future<void> _onUndoDeletionRequested(
    ListUndoDeletionRequested event,
    Emitter<ListState> emit,
  ) async {
    assert(
      state.lastDeletedGoods != null,
      'Last deleted goods can not be null.',
    );

    final goods = state.lastDeletedGoods!;
    emit(state.copyWith(lastDeletedGoods: () => null));
    await _goodsRepository.saveGoods(goods);
  }

  void _onFilterChanged(
    ListFilterChanged event,
    Emitter<ListState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAllRequested(
    ListToggleAllRequested event,
    Emitter<ListState> emit,
  ) async {
    final areAllatStored = state.goods.every((todo) => todo.atStore);
    await _goodsRepository.atStoreAll(atStore: !areAllatStored);
  }
}
