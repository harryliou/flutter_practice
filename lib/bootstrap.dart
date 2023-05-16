import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_store/app/app.dart';
import 'package:flutter_store/app/app_bloc_observer.dart';
import 'package:goods_api/goods_api.dart';
import 'package:goods_repository/goods_repository.dart';

void bootstrap({required GoodsApi goodsApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final goodsRepository = GoodsRepository(goodsApi: goodsApi);

  runZonedGuarded(
    () => runApp(App(goodsRepository: goodsRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
