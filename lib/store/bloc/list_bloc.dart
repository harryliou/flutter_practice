import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goods_repository/goods_repository.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc({
    required GoodsRepository goodsRepository,
  })  : _goodsRepository = goodsRepository,
        super(const ListState()) {
    on<ListSubscriptionRequested>(_onSubscriptionRequested);
    on<ListGoodsReomveFromStore>(_onGoodsReomveFromStore);
    on<ListAtStoreQuantityChanged>(_onAtStoreQuantityChanged);
    on<ListAtStoreSell>(_onListAtStoreSell);
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

  Future<void> _onGoodsReomveFromStore(
    ListGoodsReomveFromStore event,
    Emitter<ListState> emit,
  ) async {
    final newGoods = event.goods.copyWith(atStore: false);
    await _goodsRepository.saveGoods(newGoods);
  }

  Future<void> _onAtStoreQuantityChanged(
    ListAtStoreQuantityChanged event,
    Emitter<ListState> emit,
  ) async {
    final newGoods =
        event.goods.copyWith(atStoreQuantity: event.atStoreQuantity);
    await _goodsRepository.saveGoods(newGoods);
  }

  Future<void> _onListAtStoreSell(
    ListAtStoreSell event,
    Emitter<ListState> emit,
  ) async {
    for (final goods in state.atStoreGoods) {
      final newGoods = goods.copyWith(
          atStoreQuantity: 0,
          soldQuantity: goods.soldQuantity + goods.atStoreQuantity);
      await _goodsRepository.saveGoods(newGoods);
    }
  }
}
