import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkingScreen extends StatelessWidget {
  const ParkingScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Не може да се отвори $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Зелена зона'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildParkingRegulations(),
              const SizedBox(height: 24),
              _buildParkingZones(),
              const SizedBox(height: 24),
              _buildPaymentMethods(),
              const SizedBox(height: 24),
              _buildParkingPrices(),
              const SizedBox(height: 24),
              _buildDecreesList(),
              const SizedBox(height: 40),
              _buildContactInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Режим на кратковременно платено паркиране "Зелена зона"',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.green, thickness: 2),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/green_zone.jpg',
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                width: double.infinity,
                color: Colors.green.shade100,
                child: Center(
                  child: Icon(
                    Icons.directions_car,
                    size: 64,
                    color: Colors.green.shade700,
                  ),
                ),
              );
            },
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildParkingRegulations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Режим на паркиране'),
        const SizedBox(height: 12),
        _buildInfoCard(
          Icons.access_time,
          'Работно време',
          'В работни дни от 08:00 часа до 18:00 часа\nВ събота от 08:00 часа до 14:00 часа',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          Icons.no_crash_outlined,
          'Неработни дни',
          'Неделя и официалните празници',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          Icons.timer_outlined,
          'Максимално време за престой',
          '3 (три) часа',
        ),
      ],
    );
  }

  Widget _buildParkingZones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Граници на "Зелена зона"'),
        const SizedBox(height: 12),
        const Text(
          'Границите на „Зелена зона" и местата за кратковременно платено паркиране се определят със заповед на кмета на Община Стара Загора.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          Icons.map_outlined,
          'Централна градска част',
          'Обхваща централните булеварди и улици в града, включително бул. Цар Симеон Велики, бул. Митрополит Методий Кусев, бул. Патриарх Евтимий, ул. Цар Иван Шишман, ул. Хаджи Димитър Асенов, ул. Христо Ботев, ул. Петко Р. Славейков, ул. Св. Княз Борис I и други.',
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Начини за заплащане'),
        const SizedBox(height: 12),
        _buildPaymentMethod(
          Icons.phone_android,
          'Мобилно приложение',
          'Чрез мобилно приложение "Паркиране Стара Загора"',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildPaymentMethod(
          Icons.message,
          'SMS',
          'Чрез SMS на кратък номер 13596',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildPaymentMethod(
          Icons.credit_card,
          'Паркомат',
          'На място чрез наличните паркомати',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildPaymentMethod(
          Icons.local_police_outlined,
          'Талон от контрольор',
          'На място от контрольорите на "Зелена зона"',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildParkingPrices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Цени за паркиране'),
        const SizedBox(height: 12),
        _buildPriceRow('За 1 (един) час', '1.00 лв.'),
        _buildPriceRow('SMS за 1 (един) час', '1.00 лв.'),
        _buildPriceRow('Дневен абонамент', '6.00 лв.'),
        _buildPriceRow('Месечен абонамент за 1 автомобил', '36.00 лв.'),
        _buildPriceRow('За живущи в зоната (месечно)', '5.00 лв.'),
        _buildPriceRow('За фирми със седалище в зоната (месечно)', '20.00 лв.'),
      ],
    );
  }

  Widget _buildDecreesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Заповеди на кмета'),
        const SizedBox(height: 12),
        _buildDecreeItem('Заповед № 10-00-1416 от 02.07.2014 г.'),
        _buildDecreeItem('Заповед № 10-00-2403 от 16.10.2014 г.'),
        _buildDecreeItem('Заповед № 10-00-1328 от 16.06.2015 г.'),
        _buildDecreeItem('Заповед № 10-00-721 от 20.04.2016 г.'),
        _buildDecreeItem('Заповед № 10-00-89 от 18.01.2018 г.'),
        _buildDecreeItem('Заповед № 10-00-2099 от 20.09.2019 г.'),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Card(
      elevation: 3,
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.green.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.support_agent, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'За контакти и информация',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Община Стара Загора',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text('6000 Стара Загора, бул. Цар Симеон Велики №107'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchUrl('tel:042614614'),
              child: const Row(
                children: [
                  Icon(Icons.phone, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Телефон за информация: (042) 614 614',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchUrl('tel:080015737'),
              child: const Row(
                children: [
                  Icon(Icons.phone, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Горещ телефон за сигнали: 0800 157 37',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchUrl('mailto:contact@starazagora.bg'),
              child: const Row(
                children: [
                  Icon(Icons.email, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'contact@starazagora.bg',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const Divider(color: Colors.green, thickness: 1),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.green, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(
    IconData icon,
    String title,
    String description, {
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.green.shade800),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
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

  Widget _buildPriceRow(String service, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(service, style: const TextStyle(fontSize: 16)),
          ),
          const Expanded(
            flex: 1,
            child: Text('-', style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              price,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecreeItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          // Действие при натискане на заповед
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.description, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 