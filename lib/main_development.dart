import 'package:flutter/widgets.dart';
import 'package:flutter_todos/bootstrap.dart';
// import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:sqlite_todos_api/sqlite_todos_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final todosApi = LocalStorageTodosApi(
  //   plugin: await SharedPreferences.getInstance(),
  // );

  final todosApi = SqliteTodosApi();
  await todosApi.init();

  bootstrap(todosApi: todosApi);
}
