import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goods_repository/goods_repository.dart';

part 'edit_goods_event.dart';
part 'edit_goods_state.dart';

class EditGoodsBloc extends Bloc<EditGoodsEvent, EditGoodsState> {
  EditGoodsBloc({
    required GoodsRepository goodsRepository,
    required Goods? initialGoods,
  })  : _goodsRepository = goodsRepository,
        super(
          EditGoodsState(
            initialGoods: initialGoods,
            name: initialGoods?.name ?? '',
            capacity: initialGoods?.capacity ?? 0,
            quantity: initialGoods?.quantity ?? 0,
            soldQuantity: initialGoods?.soldQuantity ?? 0,
            unitPrice: initialGoods?.unitPrice ?? 0,
            purchaseDate: initialGoods?.purchaseDate ?? DateTime.now(),
            expirationDate: initialGoods?.expirationDate ?? DateTime.now(),
          ),
        ) {
    on<EditGoodsNameChanged>(_onNameChanged);
    on<EditGoodsCapacityChanged>(_onCapacityChanged);
    on<EditGoodsQuantityChanged>(_onQuantityChanged);
    on<EditGoodsSoldQuantityChanged>(_onSoldQuantityChanged);
    on<EditGoodsPurchaseDateChanged>(_onPurchaseDateChanged);
    on<EditGoodsExpirationDateChanged>(_onExpirationDateChanged);
    on<EditGoodsSubmitted>(_onSubmitted);
    on<EditGoodsUnitPriceChanged>(_onUnitPriceChanged);
  }

  final GoodsRepository _goodsRepository;

  void _onNameChanged(
    EditGoodsNameChanged event,
    Emitter<EditGoodsState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onCapacityChanged(
    EditGoodsCapacityChanged event,
    Emitter<EditGoodsState> emit,
  ) {
    emit(state.copyWith(capacity: event.capacity));
  }

  void _onQuantityChanged(
    EditGoodsQuantityChanged event,
    Emitter<EditGoodsState> emit,
  ) {
    emit(state.copyWith(quantity: event.quantity));
  }

  void _onSoldQuantityChanged(
    EditGoodsSoldQuantityChanged event,
    Emitter<EditGoodsState> emit,
  ) {
    emit(state.copyWith(soldQuantity: event.soldQuantity));
  }

  void _onPurchaseDateChanged(
    EditGoodsPurchaseDateChanged event,
    Emitter<EditGoodsState> emit,
  ) {
    emit(state.copyWith(purchaseDate: event.purchaseDate));
  }

  void _onExpirationDateChanged(
    EditGoodsExpirationDateChanged event,
    Emitter<EditGoodsState> emit,
  ) {
    emit(state.copyWith(expirationDate: event.expirationDate));
  }

  void _onUnitPriceChanged(
    EditGoodsUnitPriceChanged event,
    Emitter<EditGoodsState> emit,
  ) {
    emit(state.copyWith(unitPrice: event.unitPrice));
  }

  Future<void> _onSubmitted(
    EditGoodsSubmitted event,
    Emitter<EditGoodsState> emit,
  ) async {
    emit(state.copyWith(status: EditGoodsStatus.loading));
    final goods = (state.initialGoods ?? Goods(name: '')).copyWith(
      name: state.name,
      capacity: state.capacity,
      quantity: state.quantity,
      soldQuantity: state.soldQuantity,
      purchaseDate: state.purchaseDate,
      expirationDate: state.expirationDate,
      unitPrice: state.unitPrice,
    );

    try {
      await _goodsRepository.saveGoods(goods);
      emit(state.copyWith(status: EditGoodsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditGoodsStatus.failure));
    }
  }
}
