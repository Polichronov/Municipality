import 'package:flutter/material.dart';
import 'map_screen.dart';

class PublicTransportScreen extends StatefulWidget {
  const PublicTransportScreen({super.key});

  @override
  State<PublicTransportScreen> createState() => _PublicTransportScreenState();
}

class _PublicTransportScreenState extends State<PublicTransportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Search-related variables
  final TextEditingController _busSearchController = TextEditingController();
  final TextEditingController _trolleySearchController = TextEditingController();
  bool _isBusSearching = false;
  bool _isTrolleySearching = false;

  // Routes data
  final List<String> busRoutes = [
    'Линия 1 - Железник - СБА',
    'Линия 2 - Автогара - Болница',
    'Линия 3 - Казански - Кольо Ганчев',
    'Линия 4 - Аязмото - Траяна',
    'Линия 10 - Зора - Индустриален',
    'Линия 15 - Център - Кольо Ганчев'
  ];

  final List<String> trolleyRoutes = [
    'Тролей 1 - Железник - СБА',
    'Тролей 2 - Автогара - Болница',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      return;
    }
    
    if (_tabController.index == 2) {
      // Когато избираме таб "Карта", отваряме директно MapScreen
      Future.microtask(() {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => const MapScreen(),
          ),
        ).then((_) {
          // Когато потребителят се връща от картата, връщаме таб индекса на автобуси
          if (mounted) {
            _tabController.animateTo(0);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _busSearchController.dispose();
    _trolleySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF006C35),
        foregroundColor: Colors.white,
        title: const Text(
          'Градски транспорт',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.directions_bus), text: 'Автобуси'),
            Tab(icon: Icon(Icons.electric_rickshaw), text: 'Тролеи'),
            Tab(icon: Icon(Icons.map), text: 'Карта'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBusTab(),
          _buildTrolleyTab(),
          _buildMapPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text('Зареждане на картата...'),
        ],
      ),
    );
  }

  Widget _buildBusTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _busSearchController,
            decoration: InputDecoration(
              hintText: 'Търси линия или спирка...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF006C35)),
              suffixIcon: _busSearchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _busSearchController.clear();
                        setState(() {
                          _isBusSearching = false;
                        });
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onTap: () {
              setState(() {
                _isBusSearching = true;
              });
            },
            onChanged: (value) {
              setState(() {
                _isBusSearching = value.isNotEmpty;
              });
            },
            onSubmitted: (value) {
              if (value.isEmpty) {
                setState(() {
                  _isBusSearching = false;
                });
              }
            },
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: _hideSearch,
            child: _isBusSearching
                ? _buildBusSearchResults()
                : ListView.builder(
                    itemCount: busRoutes.length,
                    itemBuilder: (context, index) {
                      return _buildRouteCard(
                        busRoutes[index],
                        Icons.directions_bus,
                        const Color(0xFF006C35),
                        () => _showScheduleDialog(busRoutes[index]),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusSearchResults() {
    final String searchQuery = _busSearchController.text.toLowerCase();
    final List<String> filteredRoutes = busRoutes
        .where((route) => route.toLowerCase().contains(searchQuery))
        .toList();

    return ListView.builder(
      itemCount: filteredRoutes.isEmpty ? 1 : filteredRoutes.length,
      itemBuilder: (context, index) {
        if (filteredRoutes.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Няма намерени резултати',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }
        
        return ListTile(
          title: Text(filteredRoutes[index]),
          leading: const Icon(Icons.directions_bus, color: Color(0xFF006C35)),
          onTap: () {
            _busSearchController.text = filteredRoutes[index];
            setState(() {
              _isBusSearching = false;
            });
            FocusScope.of(context).unfocus();
            _showScheduleDialog(filteredRoutes[index]);
          },
        );
      },
    );
  }

  Widget _buildTrolleyTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _trolleySearchController,
            decoration: InputDecoration(
              hintText: 'Търси линия или спирка...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF006C35)),
              suffixIcon: _trolleySearchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _trolleySearchController.clear();
                        setState(() {
                          _isTrolleySearching = false;
                        });
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onTap: () {
              setState(() {
                _isTrolleySearching = true;
              });
            },
            onChanged: (value) {
              setState(() {
                _isTrolleySearching = value.isNotEmpty;
              });
            },
            onSubmitted: (value) {
              if (value.isEmpty) {
                setState(() {
                  _isTrolleySearching = false;
                });
              }
            },
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: _hideSearch,
            child: _isTrolleySearching
                ? _buildTrolleySearchResults()
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildRouteCard(
                        trolleyRoutes[0],
                        Icons.electric_rickshaw,
                        const Color(0xFF006C35),
                        () => _showScheduleDialog(trolleyRoutes[0]),
                      ),
                      _buildRouteCard(
                        trolleyRoutes[1],
                        Icons.electric_rickshaw,
                        const Color(0xFF006C35),
                        () => _showScheduleDialog(trolleyRoutes[1]),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrolleySearchResults() {
    final String searchQuery = _trolleySearchController.text.toLowerCase();
    final List<String> filteredRoutes = trolleyRoutes
        .where((route) => route.toLowerCase().contains(searchQuery))
        .toList();

    return ListView.builder(
      itemCount: filteredRoutes.isEmpty ? 1 : filteredRoutes.length,
      itemBuilder: (context, index) {
        if (filteredRoutes.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Няма намерени резултати',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }
        
        return ListTile(
          title: Text(filteredRoutes[index]),
          leading: const Icon(Icons.electric_rickshaw, color: Color(0xFF006C35)),
          onTap: () {
            _trolleySearchController.text = filteredRoutes[index];
            setState(() {
              _isTrolleySearching = false;
            });
            FocusScope.of(context).unfocus();
            _showScheduleDialog(filteredRoutes[index]);
          },
        );
      },
    );
  }

  Widget _buildRouteCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'На всеки 15-20 минути',
                      style: TextStyle(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showScheduleDialog(String routeName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      routeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Разписание:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: [
                    _buildTimeRow('06:00', '06:25', '06:50'),
                    _buildTimeRow('07:15', '07:40', '08:05'),
                    _buildTimeRow('08:30', '08:55', '09:20'),
                    _buildTimeRow('09:45', '10:10', '10:35'),
                    _buildTimeRow('11:00', '11:25', '11:50'),
                    _buildTimeRow('12:15', '12:40', '13:05'),
                    _buildTimeRow('13:30', '13:55', '14:20'),
                    _buildTimeRow('14:45', '15:10', '15:35'),
                    _buildTimeRow('16:00', '16:25', '16:50'),
                    _buildTimeRow('17:15', '17:40', '18:05'),
                    _buildTimeRow('18:30', '18:55', '19:20'),
                    _buildTimeRow('19:45', '20:10', '20:35'),
                    _buildTimeRow('21:00', '21:25', '21:50'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006C35),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Закупи билет'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeRow(String time1, String time2, String time3) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: _buildTimeChip(time1)),
          const SizedBox(width: 4),
          Expanded(child: _buildTimeChip(time2)),
          const SizedBox(width: 4),
          Expanded(child: _buildTimeChip(time3)),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    return Container(
      alignment: Alignment.center,
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            time,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        backgroundColor: Colors.grey[200],
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  void _hideSearch() {
    if (_tabController.index == 0) {
      setState(() {
        _isBusSearching = false;
      });
    } else if (_tabController.index == 1) {
      setState(() {
        _isTrolleySearching = false;
      });
    }
    FocusScope.of(context).unfocus();
  }
} 