import 'package:flutter/material.dart';
import 'screens/list_screen.dart';
import 'screens/grid_screen.dart';
import 'screens/prefs_screen.dart';
import 'screens/async_screen.dart';
import 'screens/isolate_screen.dart';

void main() {
  runApp(const Week4App());
}

class Week4App extends StatelessWidget {
  const Week4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 4 Exercises',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 4 Exercises'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _menuButton(context, "ListView Example", const ListScreen()),
          _menuButton(context, "GridView Example", const GridScreen()),
          _menuButton(context, "Shared Preferences", const PrefsScreen()),
          _menuButton(context, "Async Exercise (3 seconds)", const AsyncScreen()),
          _menuButton(context, "Isolate Exercise", const IsolateScreen()),
        ],
      ),
    );
  }

  Widget _menuButton(BuildContext context, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SubPageWrapper(title: text, page: page)),
          );
        },
        child: Text(text),
      ),
    );
  }
}

class SubPageWrapper extends StatelessWidget {
  final String title;
  final Widget page;

  const SubPageWrapper({super.key, required this.title, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: page,
    );
  }
}
