import 'package:flutter/material.dart';
import 'package:applock/Pages/stats_page.dart';
import 'package:applock/Pages/settings_page.dart';
import 'package:applock/Pages/template_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applock'),
        backgroundColor: Colors.red,
      ),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.red,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            backgroundColor: Colors.red,
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            backgroundColor: Colors.red,
            label: 'Template',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green,
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return Container(
          child: const Center(
            child: Text('Home Page'),
          ),
        );
      case 1:
        return const StatsPage();
      case 2:
        return const TemplatePage();
      case 3:
        return const SettingsPage();
      default:
        return Container();
    }
  }
}
