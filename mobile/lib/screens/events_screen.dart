import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final List<Event> events = [
    Event(
      title: 'ЕВРОПЕЙСКА НОЩ НА МУЗЕИТЕ',
      description: '17 май 2025 г. Вход свободен. ХУДОЖЕСТВЕНА ГАЛЕРИЯ – СТАРА ЗАГОРА 19:00-23:00 ч. ИЗЛОЖБИ Изложба живопис, керамика, текстил на Таня Шивачева...',
      startDate: DateTime(2025, 5, 17),
      endDate: DateTime(2025, 5, 17),
      location: 'Художествена галерия Стара Загора',
      imageUrl: 'assets/images/neolithic-dwellings-in-situ-museum-stara-zagora-00.jpg',
      type: EventType.cultural,
    ),
    Event(
      title: 'Спектакъл „СЪН"',
      description: 'Кукленият театър на Стара Загора започна работа по най-новото си заглавие за възрастна публика – спектакъла „СЪН", по идея и режисура на Любомир Желев. Мистичен, силно визуален и емоционален проект.',
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2025, 8, 30),
      location: 'Куклен театър Стара Загора',
      imageUrl: 'assets/images/image2.jpg',
      type: EventType.cultural,
    ),
    Event(
      title: 'Концерт за 165-годишнината на читалище „Родина-1860"',
      description: 'Най-голямото читалище в Южна България чества с концерт своята 165-годишнина в Държавна Опера Стара Загора.',
      startDate: DateTime(2025, 5, 12),
      endDate: DateTime(2025, 5, 12),
      location: 'Държавна Опера Стара Загора',
      imageUrl: 'assets/images/image3.jpg',
      type: EventType.cultural,
    ),
    Event(
      title: 'Изложба „Рисунка и малка пластика"',
      description: 'Експозиция „Рисунка и малка пластика" в Изложбена зала „Лубор Байер".',
      startDate: DateTime(2025, 5, 13),
      endDate: DateTime(2025, 6, 13),
      location: 'Изложбена зала „Лубор Байер"',
      imageUrl: 'assets/images/image4.jpg',
      type: EventType.cultural,
    ),
    Event(
      title: 'Турнир по вдигане на тежести „Павел Костов"',
      description: 'Традиционен турнир по вдигане на тежести за млади щангисти от шест града – Стара Загора, Сливен, Хасково, Пловдив, Сопот и Карлово.',
      startDate: DateTime(2025, 5, 10),
      endDate: DateTime(2025, 5, 11),
      location: 'Спортна зала „Берое"',
      imageUrl: 'assets/images/image1.jpg',
      type: EventType.sport,
    ),
    Event(
      title: 'Представяне на книгата „Целувам ви, Аспарух Лешников"',
      description: 'Представяне на биографичната книга „Целувам ви, Аспарух Лешников" от д-р Веселина Узунова в Регионален исторически музей.',
      startDate: DateTime(2025, 5, 15),
      endDate: DateTime(2025, 5, 15),
      location: 'Регионален исторически музей – Стара Загора',
      imageUrl: 'assets/images/top_image.jpg',
      type: EventType.cultural,
    ),
    Event(
      title: 'Театрален фестивал „Нови открити сцени +"',
      description: 'За първи път в своята 105-годишна история старозагорският Драматичен театър „Гео Милев" организира театрален фестивал с участието на 7 български театъра и един чуждестранен.',
      startDate: DateTime(2025, 6, 16),
      endDate: DateTime(2025, 6, 21),
      location: 'Драматичен театър „Гео Милев"',
      imageUrl: 'assets/images/image2.jpg',
      type: EventType.cultural,
    ),
    Event(
      title: 'Фолклорен спектакъл „Огънят на любовта"',
      description: 'Фолклорен спектакъл по повод празничния Ден на Светите равноапостоли и просветители Кирил и Методий. Участват детско-юношески танцов състав „Загорци" при НЧ „Родина - 1860".',
      startDate: DateTime(2025, 5, 11),
      endDate: DateTime(2025, 5, 11),
      location: 'Културен център „Стара Загора"',
      imageUrl: 'assets/images/image3.jpg',
      type: EventType.cultural,
    ),
  ];

  List<Event> filteredEvents = [];
  EventType? selectedType;

  @override
  void initState() {
    super.initState();
    filteredEvents = List.from(events);
    _sortEventsByDate();
  }

  void _sortEventsByDate() {
    filteredEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  void _filterEventsByType(EventType? type) {
    setState(() {
      selectedType = type;
      
      if (type == null) {
        filteredEvents = List.from(events);
      } else {
        filteredEvents = events.where((event) => event.type == type).toList();
      }
      
      _sortEventsByDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Събития'),
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/neolithic-dwellings-in-situ-museum-stara-zagora-00.jpg',
            fit: BoxFit.cover,
            height: 150,
            width: double.infinity,
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterChip('Всички', null),
                _buildFilterChip('Култура', EventType.cultural),
                _buildFilterChip('Спорт', EventType.sport),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: Text(
              'Предстоящи събития в Стара Загора',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return _buildEventCard(event);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, EventType? type) {
    final isSelected = selectedType == type;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (isSelected) {
        _filterEventsByType(type);
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue.shade800,
    );
  }

  Widget _buildEventCard(Event event) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    String dateText;
    
    if (event.startDate.year == event.endDate.year &&
        event.startDate.month == event.endDate.month &&
        event.startDate.day == event.endDate.day) {
      dateText = dateFormat.format(event.startDate);
    } else {
      dateText = '${dateFormat.format(event.startDate)} - ${dateFormat.format(event.endDate)}';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              event.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      event.type == EventType.cultural ? Icons.theater_comedy : Icons.sports,
                      color: Colors.blue.shade800,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      event.type == EventType.cultural ? 'Култура' : 'Спорт',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today,
                      color: Colors.grey.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateText,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Implement event details screen
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Повече информация'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum EventType {
  cultural,
  sport,
}

class Event {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String imageUrl;
  final EventType type;

  Event({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.imageUrl,
    required this.type,
  });
} 