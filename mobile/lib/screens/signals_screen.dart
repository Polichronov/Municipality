import 'package:flutter/material.dart';

class SignalType {
  final String name;
  final IconData icon;
  final int count;

  SignalType(this.name, this.icon, this.count);
}

class SignalsScreen extends StatefulWidget {
  const SignalsScreen({super.key});

  @override
  State<SignalsScreen> createState() => _SignalsScreenState();
}

class _SignalsScreenState extends State<SignalsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Сигнали', 'Предложения', 'Въпроси'];
  
  final List<SignalType> _signalTypes = [
    SignalType('Опасна сграда или съоръжение', Icons.house_outlined, 1),
    SignalType('Неработещо улично осветление', Icons.lightbulb_outline, 3),
    SignalType('Боклук/сметище', Icons.delete_outline, 0),
    SignalType('Опасна детска площадка', Icons.child_care, 0),
    SignalType('Опасна улична дупка', Icons.warning, 0),
    SignalType('Повредена/липсваща табела/пътен знак', Icons.report_problem, 0),
    SignalType('Неправилно паркиране', Icons.local_parking, 0),
    SignalType('Опасни висящи кабели', Icons.power, 0),
    SignalType('Теч на вода', Icons.opacity, 0),
    SignalType('Паднало дърво', Icons.nature, 12),
    SignalType('Пропаднал път', Icons.directions_off, 0),
    SignalType('Незаконно строителство', Icons.construction, 0),
    SignalType('Неработещ светофар', Icons.traffic, 0),
    SignalType('Безстопанствени кучета', Icons.pets, 6),
    SignalType('Проблеми със зимното почистване', Icons.ac_unit, 0),
    SignalType('Нарушаване на обществения ред/шум', Icons.volume_up, 0),
    SignalType('Изоставен автомобил', Icons.directions_car, 0),
    SignalType('Друго', Icons.more_horiz, 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сигнали'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Горещ телефон
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.phone, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  '0800 157 37',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'горещ телефон за сигнали',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          
          // Tab bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTabIndex == index
                                ? Colors.blue
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        _tabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: _selectedTabIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _selectedTabIndex == index
                              ? Colors.blue
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Съдържание според избрания таб
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                // Таб Сигнали
                _buildSignalsTab(),
                // Таб Предложения
                _buildProposalsTab(),
                // Таб Въпроси
                _buildQuestionsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showSubmitDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text('Подай сигнал'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildSignalsTab() {
    return Column(
      children: [
        // Филтри и търсене
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Търси сигнал...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.map),
                onPressed: () {},
                tooltip: 'Карта на сигналите',
              ),
            ],
          ),
        ),
        
        // Списък на типове сигнали
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _signalTypes.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final signalType = _signalTypes[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(signalType.icon, color: Colors.blue),
                ),
                title: Text(
                  signalType.name,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: signalType.count > 0 ? Colors.blue : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${signalType.count}',
                    style: TextStyle(
                      color: signalType.count > 0 ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  _showSignalTypeDetails(signalType);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProposalsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lightbulb_outline, size: 64, color: Colors.amber),
          const SizedBox(height: 16),
          const Text(
            'Направете предложение',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Проект, идея или план, към който желаете да насочите фокуса на институциите.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.send),
            label: const Text('Изпрати предложение'),
            onPressed: () {
              _showProposalDialog();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.question_answer, size: 64, color: Colors.green),
          const SizedBox(height: 16),
          const Text(
            'Задайте въпрос',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Запитване към община Стара Загора по тема, която ви вълнува.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.send),
            label: const Text('Задай въпрос'),
            onPressed: () {
              _showQuestionDialog();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignalTypeDetails(SignalType signalType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          signalType.name,
          overflow: TextOverflow.ellipsis,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(signalType.icon, size: 48, color: Colors.blue),
            const SizedBox(height: 16),
            Text('Брой активни сигнали: ${signalType.count}'),
            const SizedBox(height: 24),
            const Text(
              'Искате ли да подадете нов сигнал от този тип?',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Отказ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSubmitDialog(initialType: signalType.name);
            },
            child: const Text('Подай сигнал'),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog({String? initialType}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подай сигнал'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Тип сигнал',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  isExpanded: true,
                  value: initialType,
                  items: _signalTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type.name,
                      child: SizedBox(
                        width: 200, // Ограничаваме ширината на текста
                        child: Text(
                          type.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Заглавие',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Описание',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Адрес/Местоположение',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Добави снимка'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Вашите имена',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Телефон за връзка',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Имейл',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Отказ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSubmitConfirmation();
            },
            child: const Text('Изпрати'),
          ),
        ],
      ),
    );
  }

  void _showProposalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изпрати предложение'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Заглавие',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Описание на предложението',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Вашите имена',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Имейл за обратна връзка',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Отказ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSubmitConfirmation();
            },
            child: const Text('Изпрати'),
          ),
        ],
      ),
    );
  }

  void _showQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Задай въпрос'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Тема на въпроса',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Вашият въпрос',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Вашите имена',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Имейл за отговор',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Отказ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSubmitConfirmation();
            },
            child: const Text('Изпрати'),
          ),
        ],
      ),
    );
  }

  void _showSubmitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Благодарим Ви!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Вашият сигнал/предложение/въпрос беше успешно изпратен.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ще получите отговор на посочения от Вас имейл адрес.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 