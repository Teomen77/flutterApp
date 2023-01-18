import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Applock',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const HomePage(title: 'AppLock'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> appNames =
      List<String>.generate(100, (index) => "App #$index");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Expanded(child: buildAppList()),
            Row(children: [
              ElevatedButton(onPressed: () {}, child: const Text("Lock")),
              ElevatedButton(onPressed: () {}, child: const Text("Unlock"))
            ])
          ],
        ));
  }

  ListView buildAppList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      shrinkWrap: true,
      itemCount: appNames.length,
      itemBuilder: (context, index) {
        return AppListItem(
          appName: appNames[index],
        );
      },
    );
  }
}

class AppListItem extends StatelessWidget {
  const AppListItem({super.key, required this.appName});

  final String appName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        child: Text(appName[0]),
      ),
      title: Text(
        appName,
        style: const TextStyle(
          color: Colors.black54,
        ),
      ),
      onTap: () {
        print("$appName clicked!");
      },
    );
  }
}
