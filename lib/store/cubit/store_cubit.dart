import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  StoreCubit() : super(const StoreState());

  void setTab(StoreTab tab) => emit(StoreState(tab: tab));
}
