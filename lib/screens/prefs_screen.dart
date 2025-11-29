import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsScreen extends StatefulWidget {
  const PrefsScreen({super.key});

  @override
  State<PrefsScreen> createState() => _PrefsScreenState();
}

class _PrefsScreenState extends State<PrefsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _display = 'No saved name yet.';
  String _timestamp = '';

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setInt('age', int.tryParse(_ageController.text) ?? 0);
    final now = DateTime.now().toIso8601String();
    await prefs.setString('saved_at', now);
    setState(() {
      _display = 'Saved: ${_nameController.text}';
      _timestamp = now;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
  }

  Future<void> _show() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final age = prefs.getInt('age');
    final at = prefs.getString('saved_at');
    setState(() {
      if (name == null || name.isEmpty) {
        _display = 'No name saved yet.';
        _timestamp = at ?? '';
      } else {
        _display = 'Name: $name\nEmail: ${email ?? '-'}\nAge: ${age ?? '-'}';
        _timestamp = at ?? '';
      }
    });
  }

  Future<void> _clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('age');
    await prefs.remove('saved_at');
    setState(() {
      _display = 'Cleared saved data.';
      _timestamp = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cleared')));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 8),
          TextField(controller: _ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
          const SizedBox(height: 8),
          TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(onPressed: _save, child: const Text('Save Name')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _show, child: const Text('Show Name')),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: _clear, child: const Text('Clear')),
            ],
          ),
          const SizedBox(height: 16),
          Text(_display),
          if (_timestamp.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Last saved: $_timestamp'),
          ]
        ],
      ),
    );
  }
}
