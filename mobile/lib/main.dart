import 'package:flutter/material.dart';
import 'screens/public_transport_screen.dart';
import 'screens/attractions_screen.dart';
import 'screens/events_screen.dart';
import 'screens/signals_screen.dart';
import 'screens/parking_screen.dart';
import 'screens/information_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Община Стара Загора',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF006C35), // Dark green color
        title: Transform.translate(
          offset: const Offset(-40, 0), // Изместване с 40 пиксела наляво
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Image.asset(
                  'assets/images/stara_zagora_emblem.png',
                  height: 40,
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ДОБРЕ ДОШЛИ В', 
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'ОБЩИНА СТАРА ЗАГОРА', 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 4,
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
          // Добавяме поле за търсене
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Търсене...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF006C35)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () => _searchController.clear(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                onSubmitted: (value) {
                  // Действие при натискане на Enter
                  _performSearch(value);
                },
              ),
            ),
          ),
          // Секции с PageView, за да се показват по 4 на страница (2x2)
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      // Първа страница с 4 секции (2x2)
                      _buildGridPage(
                        context,
                        [
                          _buildImageTile(context, 'assets/images/image1.jpg', 'Сигнали', SignalsScreen()),
                          _buildImageTile(context, 'assets/images/image2.jpg', 'Зелена зона', ParkingScreen()),
                          _buildImageTile(context, 'assets/images/image3.jpg', 'Градски транспорт', PublicTransportScreen()),
                          _buildImageTile(context, 'assets/images/image4.jpg', 'Събития', EventsScreen()),
                        ]
                      ),
                      // Втора страница с 2 секции (2x1)
                      _buildGridPage(
                        context,
                        [
                          _buildImageTile(context, 'assets/images/neolithic-dwellings-in-situ-museum-stara-zagora-00.jpg', 'Култура и туризъм', AttractionsScreen()),
                          _buildImageTile(context, 'assets/images/announcements_image.jpg', 'Информация и услуги', InformationScreen()),
                        ]
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Индикатор на страниците
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 2,
                  effect: const WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Color(0xFF006C35),
                    dotColor: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    // Тук ще се изпълни логиката за търсене
    // За момента просто ще покажем съобщение
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Търсене за: $query'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF006C35),
      ),
    );
  }

  Widget _buildGridPage(BuildContext context, List<Widget> tiles) {
    // Създаваме списък с редове
    final List<Widget> rows = [];
    
    // Осигуряваме винаги 4 плочки (2x2)
    final List<Widget> fullTiles = List.from(tiles);
    
    // Ако имаме по-малко от 4 плочки, добавяме празни плочки
    while (fullTiles.length < 4) {
      fullTiles.add(const SizedBox()); // Празна плочка
    }
    
    // Създаваме първия ред (първите 2 плочки)
    rows.add(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(child: fullTiles[0]),
              const SizedBox(width: 16),
              Expanded(child: fullTiles[1]),
            ],
          ),
        ),
      ),
    );
    
    // Създаваме втория ред (следващите 2 плочки)
    rows.add(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(child: fullTiles[2]),
              const SizedBox(width: 16),
              Expanded(child: fullTiles[3]),
            ],
          ),
        ),
      ),
    );
    
    // Добавяме малко разстояние между редовете
    return Column(
      children: [
        rows[0],
        const SizedBox(height: 16),
        rows[1],
      ],
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