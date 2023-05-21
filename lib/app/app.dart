import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_store/home/home.dart';
import 'package:flutter_store/theme/theme.dart';
import 'package:goods_repository/goods_repository.dart';

class App extends StatelessWidget {
  const App({super.key, required this.goodsRepository});

  final GoodsRepository goodsRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: goodsRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterGoodsTheme.light,
      darkTheme: FlutterGoodsTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'TW'), // 中文（简体）
      ],
    );
  }
}
