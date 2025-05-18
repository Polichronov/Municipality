import 'package:flutter/material.dart';

class AttractionsScreen extends StatelessWidget {
  const AttractionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Култура и туризъм'),
      ),
      body: ListView(
        children: [
          // Hero image at the top
          Image.asset(
            'assets/images/neolithic-dwellings-in-situ-museum-stara-zagora-00.jpg',
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
          
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Исторически и културни забележителности',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Description
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Стара Загора е град с богата история и множество забележителности, включително археологически разкопки, музеи и културни паметници.',
              style: TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 20),

          // List of attractions
          _buildAttractionItem(
            'Античен форум',
            'Археологически разкопки от римско време',
            Icons.place_outlined,
          ),
          _buildAttractionItem(
            'Регионален исторически музей',
            'Експозиция, проследяваща 8000-годишната история на града',
            Icons.museum_outlined,
          ),
          _buildAttractionItem(
            'Парк Аязмото',
            'Живописен парк с алеи и множество възможности за отдих',
            Icons.park_outlined,
          ),
          _buildAttractionItem(
            'Неолитни жилища',
            'Едни от най-добре запазените праисторически жилища в Европа',
            Icons.history_edu_outlined,
          ),
          _buildAttractionItem(
            'Римски мозайки',
            'Прекрасно запазени римски мозайки от 3-4 век',
            Icons.grid_on_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAttractionItem(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue.shade800),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    );
  }
} 