import 'package:flutter/material.dart';

class AsyncScreen extends StatefulWidget {
  const AsyncScreen({super.key});

  @override
  State<AsyncScreen> createState() => _AsyncScreenState();
}

class _AsyncScreenState extends State<AsyncScreen> {
  String _status = 'Idle';

  Future<void> _loadUser() async {
    setState(() => _status = 'Loading user...');
    await Future.delayed(const Duration(seconds: 3));
    setState(() => _status = 'User loaded successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _loadUser, child: const Text('Start (3s)')),
          ],
        ),
      ),
    );
  }
}
