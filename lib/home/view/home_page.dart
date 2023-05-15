import 'package:flutter/material.dart';
import 'package:flutter_todos/list/list.dart';
import 'package:flutter_todos/store/store.dart';

class PageWithSideBar extends StatefulWidget {
  const PageWithSideBar({super.key});

  @override
  State<PageWithSideBar> createState() => _PageWithSideBarState();
}

class _PageWithSideBarState extends State<PageWithSideBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const ListPage();
        break;
      case 1:
        page = const StorePage();
        break;
      default:
        throw UnimplementedError('$_selectedIndex is not implemented');
    }
    return Scaffold(
      // appBar: AppBar(
      //   //ADDED APP BAR
      //   title: const Text('Flutter Todos'),
      // ),
      // drawer: const Placeholder(),
      drawer: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 50,
              icon: const Icon(Icons.list),
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
