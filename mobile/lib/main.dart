import 'package:flutter/material.dart';
import 'screens/public_transport_screen.dart';
import 'screens/attractions_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Layout',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ОБЩИНА СТАРА ЗАГОРА'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/images/top_image.jpg', 
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 24),
          // Bottom 2/3 of the screen with rows of clickable images
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2, // Two images per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 32,
                children: [
                  _buildImageTile(context, 'assets/images/image1.jpg', 'Сигнали', Screen1()),
                  _buildImageTile(context, 'assets/images/image2.jpg', 'Паркиране', Screen2()),
                  _buildImageTile(context, 'assets/images/image3.jpg', 'Градски транспорт', PublicTransportScreen()),
                  _buildImageTile(context, 'assets/images/image4.jpg', 'Събития', Screen4()),
                  _buildImageTile(context, 'assets/images/neolithic-dwellings-in-situ-museum-stara-zagora-00.jpg', 'Забележителности', AttractionsScreen()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageTile(BuildContext context, String imagePath, String label, Widget screen) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Screen 1
class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // This restores the back arrow
      body: SizedBox.shrink(), // No text, empty body
    );
  }
}

// Screen 2
class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox.shrink(),
    );
  }
}

// Screen 3
class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox.shrink(),
    );
  }
}

// Screen 4
class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox.shrink(),
    );
  }
}