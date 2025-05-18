import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

// Клас за представяне на автобус
class Bus {
  final String routeName;
  final Color color;
  int positionIndex;
  
  Bus({
    required this.routeName,
    required this.color,
    required this.positionIndex,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final List<Polyline> _polylines = [];
  final List<Marker> _markers = [];
  
  // Таймер за движение на автобусите
  Timer? _busAnimationTimer;
  
  // Списък с всички автобуси
  final List<Bus> _buses = [];
  
  // Default camera position (Stara Zagora center)
  static const LatLng _center = LatLng(42.4273, 25.6286);
  LatLng? _currentLocation;
  bool _locationServiceActive = false;
  
  // Структура с данни за автобусни линии
  final Map<String, Map<String, dynamic>> _busRoutes = {
    'Линия 1': {
      'color': Colors.blue,
      'route': [
        const LatLng(42.4273, 25.6286), // Център
        const LatLng(42.4285, 25.6290), // ул. Цар Симеон Велики
        const LatLng(42.4298, 25.6298), // бул. Руски
        const LatLng(42.4315, 25.6309), // бул. Руски
        const LatLng(42.4332, 25.6319), // бул. Славянски
        const LatLng(42.4350, 25.6320), // кв. Железник
        const LatLng(42.4365, 25.6332), // кв. Железник
        const LatLng(42.4372, 25.6366), // ул. Железник
        const LatLng(42.4385, 25.6383), // Железник юг
        const LatLng(42.4400, 25.6400), // Железник север
        const LatLng(42.4425, 25.6425), // към СБА
        const LatLng(42.4450, 25.6450), // СБА
      ],
      'stops': [
        {'name': 'Централна автогара', 'position': const LatLng(42.4273, 25.6286), 'lines': ['1', '3', '15']},
        {'name': 'Бул. Руски', 'position': const LatLng(42.4315, 25.6309), 'lines': ['1', '4']},
        {'name': 'Кв. Железник', 'position': const LatLng(42.4350, 25.6320), 'lines': ['1', '10']},
        {'name': 'Железник юг', 'position': const LatLng(42.4385, 25.6383), 'lines': ['1']},
        {'name': 'СБА', 'position': const LatLng(42.4450, 25.6450), 'lines': ['1']},
      ]
    },
    'Линия 2': {
      'color': Colors.green,
      'route': [
        const LatLng(42.4273, 25.6286), // Център
        const LatLng(42.4265, 25.6270), // ул. Христо Ботев
        const LatLng(42.4255, 25.6255), // ул. Христо Ботев
        const LatLng(42.4245, 25.6240), // ул. Хаджи Димитър Асенов
        const LatLng(42.4235, 25.6225), // ул. Хаджи Димитър Асенов
        const LatLng(42.4225, 25.6215), // ул. Георги Папазов
        const LatLng(42.4215, 25.6205), // ул. Георги Папазов
        const LatLng(42.4200, 25.6200), // бул. Никола Петков
        const LatLng(42.4180, 25.6175), // бул. Никола Петков
        const LatLng(42.4165, 25.6150), // Болница
        const LatLng(42.4150, 25.6100), // Болница
      ],
      'stops': [
        {'name': 'Централна автогара', 'position': const LatLng(42.4273, 25.6286), 'lines': ['2', '4', '15']},
        {'name': 'ул. Христо Ботев', 'position': const LatLng(42.4255, 25.6255), 'lines': ['2']},
        {'name': 'ул. Георги Папазов', 'position': const LatLng(42.4215, 25.6205), 'lines': ['2', '10']},
        {'name': 'бул. Никола Петков', 'position': const LatLng(42.4180, 25.6175), 'lines': ['2']},
        {'name': 'УМБАЛ', 'position': const LatLng(42.4150, 25.6100), 'lines': ['2', '15']},
      ]
    },
    'Линия 3': {
      'color': Colors.red,
      'route': [
        const LatLng(42.4273, 25.6286), // Център
        const LatLng(42.4268, 25.6305), // бул. Цар Симеон Велики
        const LatLng(42.4258, 25.6325), // бул. Цар Симеон Велики
        const LatLng(42.4248, 25.6345), // бул. Патриарх Евтимий
        const LatLng(42.4238, 25.6365), // бул. Патриарх Евтимий
        const LatLng(42.4225, 25.6385), // кв. Казански
        const LatLng(42.4210, 25.6405), // кв. Казански
        const LatLng(42.4200, 25.6425), // ул. Димитър Наумов
        const LatLng(42.4185, 25.6445), // ул. Димитър Наумов
        const LatLng(42.4170, 25.6465), // кв. Кольо Ганчев
        const LatLng(42.4155, 25.6485), // кв. Кольо Ганчев
        const LatLng(42.4150, 25.6500), // кв. Кольо Ганчев
      ],
      'stops': [
        {'name': 'Централна автогара', 'position': const LatLng(42.4273, 25.6286), 'lines': ['3', '1', '15']},
        {'name': 'бул. Цар Симеон Велики', 'position': const LatLng(42.4258, 25.6325), 'lines': ['3']},
        {'name': 'бул. Патриарх Евтимий', 'position': const LatLng(42.4238, 25.6365), 'lines': ['3', '4']},
        {'name': 'кв. Казански', 'position': const LatLng(42.4210, 25.6405), 'lines': ['3', '10']},
        {'name': 'кв. Кольо Ганчев', 'position': const LatLng(42.4150, 25.6500), 'lines': ['3', '15']},
      ]
    },
    'Линия 4': {
      'color': Colors.orange,
      'route': [
        const LatLng(42.4273, 25.6286), // Център
        const LatLng(42.4280, 25.6240), // ул. Цар Иван Шишман
        const LatLng(42.4287, 25.6200), // ул. Цар Иван Шишман
        const LatLng(42.4295, 25.6170), // парк Аязмото
        const LatLng(42.4305, 25.6140), // парк Аязмото
        const LatLng(42.4315, 25.6100), // бул. Стефан Стамболов
        const LatLng(42.4325, 25.6060), // бул. Стефан Стамболов
        const LatLng(42.4335, 25.6030), // кв. Траяна
        const LatLng(42.4345, 25.6010), // кв. Траяна
        const LatLng(42.4350, 25.6000), // кв. Траяна
      ],
      'stops': [
        {'name': 'Централна автогара', 'position': const LatLng(42.4273, 25.6286), 'lines': ['4', '1', '2']},
        {'name': 'ул. Цар Иван Шишман', 'position': const LatLng(42.4287, 25.6200), 'lines': ['4']},
        {'name': 'Парк Аязмото', 'position': const LatLng(42.4305, 25.6140), 'lines': ['4', '15']},
        {'name': 'бул. Стефан Стамболов', 'position': const LatLng(42.4325, 25.6060), 'lines': ['4', '10']},
        {'name': 'кв. Траяна', 'position': const LatLng(42.4350, 25.6000), 'lines': ['4']},
      ]
    },
    'Линия 10': {
      'color': Colors.purple,
      'route': [
        const LatLng(42.4273, 25.6286), // Център
        const LatLng(42.4278, 25.6315), // ул. Св. Княз Борис I
        const LatLng(42.4283, 25.6345), // ул. Св. Княз Борис I
        const LatLng(42.4290, 25.6375), // бул. Митрополит Методий Кусев
        const LatLng(42.4300, 25.6410), // бул. Митрополит Методий Кусев
        const LatLng(42.4310, 25.6450), // ул. Индустриална
        const LatLng(42.4320, 25.6480), // Индустриална зона
        const LatLng(42.4330, 25.6500), // Индустриална зона
      ],
      'stops': [
        {'name': 'Централна автогара', 'position': const LatLng(42.4273, 25.6286), 'lines': ['10', '1', '15']},
        {'name': 'ул. Св. Княз Борис I', 'position': const LatLng(42.4283, 25.6345), 'lines': ['10']},
        {'name': 'бул. Митрополит Методий Кусев', 'position': const LatLng(42.4300, 25.6410), 'lines': ['10', '3']},
        {'name': 'ул. Индустриална', 'position': const LatLng(42.4310, 25.6450), 'lines': ['10']},
        {'name': 'Индустриална зона', 'position': const LatLng(42.4330, 25.6500), 'lines': ['10', '1']},
      ]
    },
    'Линия 15': {
      'color': Colors.teal,
      'route': [
        const LatLng(42.4273, 25.6286), // Център
        const LatLng(42.4250, 25.6286), // бул. Цар Симеон Велики
        const LatLng(42.4230, 25.6286), // бул. Цар Симеон Велики
        const LatLng(42.4210, 25.6285), // ул. Августа Траяна
        const LatLng(42.4190, 25.6282), // ул. Августа Траяна
        const LatLng(42.4170, 25.6280), // кв. Кольо Ганчев
        const LatLng(42.4150, 25.6278), // кв. Кольо Ганчев
        const LatLng(42.4130, 25.6276), // Манастир "Св. Теодор Тирон"
        const LatLng(42.4110, 25.6275), // Манастир "Св. Теодор Тирон"
        const LatLng(42.4090, 25.6275), // Манастир "Св. Теодор Тирон"
        const LatLng(42.4070, 25.6275), // Южен обход
        const LatLng(42.4050, 25.6275), // Южен обход
      ],
      'stops': [
        {'name': 'Централна автогара', 'position': const LatLng(42.4273, 25.6286), 'lines': ['15', '1', '2', '3']},
        {'name': 'бул. Цар Симеон Велики', 'position': const LatLng(42.4230, 25.6286), 'lines': ['15']},
        {'name': 'ул. Августа Траяна', 'position': const LatLng(42.4190, 25.6282), 'lines': ['15', '2']},
        {'name': 'кв. Кольо Ганчев', 'position': const LatLng(42.4150, 25.6278), 'lines': ['15', '3']},
        {'name': 'Манастир "Св. Теодор Тирон"', 'position': const LatLng(42.4110, 25.6275), 'lines': ['15']},
        {'name': 'Южен обход', 'position': const LatLng(42.4050, 25.6275), 'lines': ['15']},
      ]
    },
  };
  
  // Активни линии, които се показват на картата
  final Set<String> _activeRoutes = {};
  
  @override
  void initState() {
    super.initState();
    _initLocationService();
    
    // По подразбиране всички линии са активни
    _activeRoutes.addAll(_busRoutes.keys);
    
    // Добавяме маршрутите на картата
    _addBusRoutes();
    
    // Инициализиране на автобусите (по 1-2 на линия)
    _initBuses();
    
    // Стартиране на анимациите на автобусите
    _startBusAnimations();
  }
  
  @override
  void dispose() {
    // Спиране на таймера при унищожаване на екрана
    _busAnimationTimer?.cancel();
    super.dispose();
  }

  // Инициализация на автобусите
  void _initBuses() {
    _buses.clear();
    
    // За всеки маршрут добавяме 1-2 автобуса
    for (var entry in _busRoutes.entries) {
      final routeName = entry.key;
      final routeData = entry.value;
      final routePoints = routeData['route'] as List<LatLng>;
      final busColor = routeData['color'] as Color;
      
      // По подразбиране по 1 автобус на линия
      int busesCount = 1;
      
      // За някои линии добавяме по 2 автобуса
      if (routeName == 'Линия 1' || routeName == 'Линия 15') {
        busesCount = 2;
      }
      
      for (int i = 0; i < busesCount; i++) {
        // Изчисляваме позиция - ако са 2 автобуса ги разпределяме равномерно
        int positionIndex = (i * routePoints.length ~/ busesCount) % routePoints.length;
        
        _buses.add(Bus(
          routeName: routeName,
          color: busColor,
          positionIndex: positionIndex,
        ));
      }
    }
    
    // Обновяваме маркерите на картата
    _updateBusMarkers();
  }

  // Стартиране на анимациите на автобусите
  void _startBusAnimations() {
    // Създаваме един таймер за всички автобуси
    _busAnimationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        _updateBusPositions();
      }
    });
  }

  // Обновяване на позициите на автобусите
  void _updateBusPositions() {
    if (!mounted) return;
    
    setState(() {
      // За всеки автобус
      for (var bus in _buses) {
        // Само ако линията му е активна
        if (_activeRoutes.contains(bus.routeName)) {
          // Взимаме пътните точки за този маршрут
          final routePoints = _busRoutes[bus.routeName]!['route'] as List<LatLng>;
          
          // Преместваме автобуса към следващата точка
          bus.positionIndex = (bus.positionIndex + 1) % routePoints.length;
        }
      }
      
      // Обновяваме маркерите на картата
      _updateBusMarkers();
    });
  }

  // Инициализация на услугата за местоположение
  Future<void> _initLocationService() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationServiceActive = false;
          });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationServiceActive = false;
        });
        return;
      }
      
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationServiceActive = false;
        });
        return;
      }

      // Взимаме първоначалното местоположение
      _getCurrentLocation();
      
      setState(() {
        _locationServiceActive = true;
      });
    } catch (e) {
      print("Грешка при инициализиране на местоположението: $e");
      setState(() {
        _locationServiceActive = false;
      });
    }
  }

  // Получаване на текущото местоположение
  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _locationServiceActive = true;
        });
        
        _mapController.move(_currentLocation!, 15.0);
      }
    } catch (e) {
      print("Грешка при получаване на местоположението: $e");
    }
  }

  void _addBusRoutes() {
    _polylines.clear();
    _markers.clear();
    
    // Добавяме маршрутите към картата
    for (var entry in _busRoutes.entries) {
      final routeName = entry.key;
      final routeData = entry.value;
      
      // Проверяваме дали линията е активна
      if (_activeRoutes.contains(routeName)) {
        // Добавяме линията
        _polylines.add(
          Polyline(
            points: routeData['route'] as List<LatLng>,
            color: routeData['color'] as Color,
            strokeWidth: 5.0,
          ),
        );
      }
    }
    
    // Обновяваме маркерите на автобусите
    _updateBusMarkers();
  }

  // Обновяване на маркерите на автобусите
  void _updateBusMarkers() {
    _markers.clear();
    
    // Добавяме маркер за всеки активен автобус
    for (var bus in _buses) {
      if (_activeRoutes.contains(bus.routeName)) {
        final routePoints = _busRoutes[bus.routeName]!['route'] as List<LatLng>;
        final busPosition = routePoints[bus.positionIndex];
        
        // Изчисляваме ротацията на автобуса според посоката на движение
        double rotation = 0;
        final nextIndex = (bus.positionIndex + 1) % routePoints.length;
        rotation = _calculateRotation(busPosition, routePoints[nextIndex]);
        
        _markers.add(
          Marker(
            point: busPosition,
            width: 40,
            height: 40,
            child: Transform.rotate(
              angle: rotation,
              child: Container(
                decoration: BoxDecoration(
                  color: bus.color.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.directions_bus,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      }
    }
    
    // Добавяме маркер за текущото местоположение на потребителя
    if (_currentLocation != null) {
      _markers.add(
        Marker(
          point: _currentLocation!,
          width: 20,
          height: 20,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.person_pin_circle,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      );
    }
  }
  
  // Изчисляване на ротация според посоката на движение
  double _calculateRotation(LatLng current, LatLng next) {
    final deltaLat = next.latitude - current.latitude;
    final deltaLng = next.longitude - current.longitude;
    return atan2(deltaLng, deltaLat);
  }

  void _toggleRoute(String routeName) {
    setState(() {
      if (_activeRoutes.contains(routeName)) {
        _activeRoutes.remove(routeName);
      } else {
        _activeRoutes.add(routeName);
      }
      _addBusRoutes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта на градския транспорт'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 14.0,
              onTap: (_, __) {},
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'bg.stz.municipality',
                subdomains: const ['a', 'b', 'c'],
              ),
              PolylineLayer(polylines: _polylines),
              MarkerLayer(markers: _markers),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Маршрути',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _busRoutes.keys.map((routeName) {
                        final routeData = _busRoutes[routeName]!;
                        final busColor = routeData['color'] as Color;
                        final isActive = _activeRoutes.contains(routeName);
                        
                        return InkWell(
                          onTap: () {
                            _toggleRoute(routeName);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Chip(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: VisualDensity.compact,
                            label: Text(
                              routeName,
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.black87,
                                fontSize: 12,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            backgroundColor: isActive ? busColor : Colors.grey.shade200,
                            avatar: Icon(
                              Icons.directions_bus,
                              color: isActive ? Colors.white : Colors.grey.shade600,
                              size: 16,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!_locationServiceActive)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Card(
                color: Colors.amber[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.amber),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Услугата за местоположение не е активна. Няма да виждате текущата си позиция на картата.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      TextButton(
                        onPressed: _initLocationService,
                        child: const Text('Опитай отново'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 