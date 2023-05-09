import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:todos_api/todos_api.dart';

/// {@template sqlite_todos_api}
/// A Flutter implementation of the TodosApi that uses sqlite.
/// {@endtemplate}
class SqliteTodosApi extends TodosApi {
  /// {@macro sqlite_todos_api}
  SqliteTodosApi();

  final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  static Future<void> _createTables(sql.Database database) async {
    await database.execute('CREATE TABLE todos ('
        'id TEXT PRIMARY KEY, '
        'title TEXT, '
        'description TEXT, '
        'isCompleted INTEGER '
        ')');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'todos.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await _createTables(database);
      },
    );
  }

  Future<void> init() async {
    final db = await SqliteTodosApi.db();
    final todosResult = await db.query('todos', orderBy: 'id');
    if (todosResult.isNotEmpty) {
      final todos = todosResult.map((todo) {
        return Todo(
          id: todo['id'] as String,
          title: todo['title'] as String,
          description: todo['description'] as String,
          isCompleted: todo['isCompleted'] == 1,
        );
      }).toList();
      _todoStreamController.add(todos);
    } else {
      _todoStreamController.add(const []);
    }
  }

  @override
  Future<int> clearCompleted() async {
    final db = await SqliteTodosApi.db();
    final todos = [..._todoStreamController.value];
    final completedTodosAmount = todos.where((t) => t.isCompleted).length;
    todos.removeWhere((t) => t.isCompleted);
    _todoStreamController.add(todos);
    await db.delete('todos', where: 'isCompleted = ?', whereArgs: [1]);
    return completedTodosAmount;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    final db = await SqliteTodosApi.db();
    final todos = [..._todoStreamController.value];
    final changedTodosAmount =
        todos.where((t) => t.isCompleted != isCompleted).length;
    final newTodos = [
      for (final todo in todos) todo.copyWith(isCompleted: isCompleted)
    ];
    _todoStreamController.add(newTodos);
    await db.update(
      'todos',
      {
        'isCompleted': isCompleted ? 1 : 0,
      },
      where: 'id = ?',
    );
    return changedTodosAmount;
  }

  @override
  Future<void> deleteTodo(String id) async {
    final db = await SqliteTodosApi.db();
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == id);
    if (todoIndex == -1) {
      throw TodoNotFoundException();
    } else {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
      await db.delete('todos', where: 'id = ?', whereArgs: [id]);
    }
  }

  @override
  Stream<List<Todo>> getTodos() => _todoStreamController.asBroadcastStream();

  @override
  Future<void> saveTodo(Todo todo) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    if (todoIndex >= 0) {
      todos[todoIndex] = todo;
    } else {
      todos.add(todo);
    }
    _todoStreamController.add(todos);

    final db = await SqliteTodosApi.db();
    final data = {
      'id': todo.id,
      'title': todo.title,
      'description': todo.description,
      'isCompleted': todo.isCompleted ? 1 : 0,
    };
    await db.insert(
      'todos',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }
}
