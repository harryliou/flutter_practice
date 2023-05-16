import 'package:flutter/widgets.dart';
import 'package:flutter_store/bootstrap.dart';
import 'package:sqlite_goods_api/sqlite_goods_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final goodsApi = SqliteGoodsApi();
  await goodsApi.init();

  bootstrap(goodsApi: goodsApi);
}
