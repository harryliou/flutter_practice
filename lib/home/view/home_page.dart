import 'package:flutter/material.dart';
import 'package:flutter_store/list/list.dart';
import 'package:flutter_store/store/store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const ListPage();
        break;
      case 1:
        // page = const StorePage();
        page = const StorePage();
        break;
      default:
        throw UnimplementedError('$_selectedIndex is not implemented');
    }
    return Scaffold(
      drawer: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 50,
              icon: const Icon(Icons.list),
              color: _selectedIndex == 0 ? Colors.blue : Colors.white,
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            IconButton(
              iconSize: 50,
              icon: const Icon(Icons.store),
              color: _selectedIndex == 1 ? Colors.blue : Colors.white,
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: page,
    );
  }
}
