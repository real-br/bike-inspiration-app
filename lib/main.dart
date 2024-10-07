import 'dart:async';
import 'package:flutter/material.dart';
import 'upload_image_screen.dart';
import 'bike_feed.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bike Inspiration App',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  Widget _getSelectedPage() {
    switch (selectedIndex) {
      case 0:
        return BikeFeedScreen();
      case 1:
        return UploadImageScreen();
      case 2:
        return Placeholder();
      default:
        return Center(child: Text('Page not found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedPage(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 1.0))),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.directions_bike),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.add,
              ),
              label: 'Upload',
            ),
          ],
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
