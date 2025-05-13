import 'package:flutter/material.dart';

class PublicTransportScreen extends StatefulWidget {
  const PublicTransportScreen({super.key});

  @override
  State<PublicTransportScreen> createState() => _PublicTransportScreenState();
}

class _PublicTransportScreenState extends State<PublicTransportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> busRoutes = [
    'Линия 1 - Железник - СБА',
    'Линия 2 - Автогара - Болница',
    'Линия 3 - Казански - Кольо Ганчев',
    'Линия 4 - Аязмото - Траяна',
    'Линия 10 - Зора - Индустриален',
    'Линия 15 - Център - Кольо Ганчев'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Градски транспорт'),
        bottom: TabBar(
          controller: _tabController,
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
          _buildMapTab(),
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
            decoration: InputDecoration(
              hintText: 'Търси линия или спирка...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: busRoutes.length,
            itemBuilder: (context, index) {
              return _buildRouteCard(
                busRoutes[index],
                Icons.directions_bus,
                Colors.blue,
                () => _showScheduleDialog(busRoutes[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrolleyTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildRouteCard(
          'Тролей 1 - Железник - СБА',
          Icons.electric_rickshaw,
          Colors.green,
          () => _showScheduleDialog('Тролей 1 - Железник - СБА'),
        ),
        _buildRouteCard(
          'Тролей 2 - Автогара - Болница',
          Icons.electric_rickshaw,
          Colors.green,
          () => _showScheduleDialog('Тролей 2 - Автогара - Болница'),
        ),
      ],
    );
  }

  Widget _buildMapTab() {
    return Stack(
      children: [
        Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 100, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'Карта на градския транспорт',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Показва всички линии и спирки в града',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
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
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'На всеки 15-20 минути',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
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
                  Text(
                    routeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTimeChip(time1),
          _buildTimeChip(time2),
          _buildTimeChip(time3),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    return Chip(
      label: Text(time),
      backgroundColor: Colors.grey[200],
    );
  }
} 