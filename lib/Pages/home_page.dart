import 'package:applock/Platform/host_communication.dart';
import 'package:applock/app_lock_list.dart';
import 'package:flutter/material.dart';
import 'package:applock/Pages/stats_page.dart';
import 'package:applock/Pages/settings_page.dart';
import 'package:applock/Pages/template_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<List<AppInfo>> appInfo = getInstalledApps();

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
        return FutureBuilder<List<AppInfo>>(
          future: appInfo,
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = ListView.builder(
                padding: const EdgeInsets.all(8.0),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return AppListItem(
                    appName: snapshot.data![index].name!,
                    packageName: snapshot.data![index].packageName!,
                  );
                },
              );
            } else {
              child = const SizedBox(
                  width: 100, height: 100, child: CircularProgressIndicator());
            }
            return Center(child: child);
          },
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

class AppListItem extends StatefulWidget {
  const AppListItem(
      {super.key, required this.appName, required this.packageName});

  final String appName;
  final String packageName;

  @override
  State<AppListItem> createState() => _AppListItemState();
}

class _AppListItemState extends State<AppListItem> {
  Icon getLockButtonIcon() {
    if (isPackageLocked(widget.packageName)) {
      return const Icon(Icons.lock);
    } else {
      return const Icon(Icons.lock_open);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        child: Text(widget.appName[0]),
      ),
      title: Text(
        widget.appName,
        style: const TextStyle(
          color: Colors.black54,
        ),
      ),
      trailing: IconButton(
          onPressed: () {
            if (isPackageLocked(widget.packageName)) {
              setState(() {
                unlockPackage(widget.packageName);
              });
            } else {
              setState(() {
                lockPackage(widget.packageName);
              });
            }
          },
          icon: getLockButtonIcon()),
      onTap: () {
        //print("$appName clicked!");
      },
    );
  }
}
