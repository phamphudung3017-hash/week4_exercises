import 'package:flutter/material.dart';

class GridScreen extends StatelessWidget {
  const GridScreen({super.key});

  Widget buildFixedGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Fixed Column Grid', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(12, (i) {
            return _gridItem(i);
          }),
        ),
      ],
    );
  }

  Widget buildResponsiveGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Responsive Grid', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        GridView.extent(
          shrinkWrap: true,
          maxCrossAxisExtent: 150,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(12, (i) {
            return _gridItem(i);
          }),
        ),
      ],
    );
  }

  Widget _gridItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 36),
          const SizedBox(height: 8),
          Text('Item ${index + 1}'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          buildFixedGrid(),
          const SizedBox(height: 20),
          buildResponsiveGrid(),
          const SizedBox(height: 20),
          const Text('Bonus: Try to implement within 50 minutes!'),
        ],
      ),
    );
  }
}
