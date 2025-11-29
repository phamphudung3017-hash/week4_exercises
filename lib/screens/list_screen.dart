import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  final int count = 30;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: count,
      itemBuilder: (context, index) {
        final name = 'Contact ${index + 1}';
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.indigo.shade100,
              child: Text(
                name.split(' ').last,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(name),
            subtitle: Text('email${index + 1}@example.com'),
            trailing: IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
