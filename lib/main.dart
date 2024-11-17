import 'dart:async';
import 'package:bike_inspiration_app/widgets/initial_screen.dart';
import 'package:bike_inspiration_app/widgets/profile_screen.dart';
import 'package:bike_inspiration_app/widgets/saved_posts_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/bike_feed.dart';
import 'widgets/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: InitialScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => MyHomePage(),
      },
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
        return SavedPostsScreen();
      case 2:
        return ProfilePage();
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
          height: 70,
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
                Icons.push_pin,
              ),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_2,
              ),
              label: 'Account',
            ),
          ],
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
