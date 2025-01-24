import 'package:flutter/material.dart';
import 'database.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    PetFormPage(),
    Text('Home Page'),
    Text('Nav2 Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Yeni',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ayarlar',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class PetFormPage extends StatelessWidget {
  const PetFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Evcil Hayvan Ekleme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPetForm()),
                );
              },
              child: const Text('Yeni Evcil Hayvan Ekleme'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddMealPlanForm()),
                );
              },
              child: const Text('Yemek Düzeni Kaydetme'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddPetForm extends StatelessWidget {
  const AddPetForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    final TextEditingController healthController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evcil Hayvan Bilgileri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Evcil Hayvanın Adı',
                ),
              ),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'Türü',
                ),
              ),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Yaşı',
                ),
              ),
              TextFormField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: 'Ağırlık',
                ),
              ),
              TextFormField(
                controller: healthController,
                decoration: const InputDecoration(
                  labelText: 'Sağlık Durumu',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    DatabaseHelper().insertPet({
                      'name': nameController.text,
                      'type': typeController.text,
                      'age': int.parse(ageController.text),
                      'weight': double.parse(weightController.text),
                      'health': healthController.text,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Evcil hayvan bilgileri kaydedildi')),
                    );
                  }
                },
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddMealPlanForm extends StatelessWidget {
  const AddMealPlanForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController petNameController = TextEditingController();
    final TextEditingController foodTypeController = TextEditingController();
    final TextEditingController mealTimeController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController waterTrackingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yemek Düzeni Kaydetme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: petNameController,
                decoration: const InputDecoration(
                  labelText: 'Evcil Hayvanın Adı',
                ),
              ),
              TextFormField(
                controller: foodTypeController,
                decoration: const InputDecoration(
                  labelText: 'Yemek Türleri (kuru mama, yaş mama, ev yemeği vb.)',
                ),
              ),
              TextFormField(
                controller: mealTimeController,
                decoration: const InputDecoration(
                  labelText: 'Yemek Saatleri (Sabah, öğle, akşam)',
                ),
              ),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Miktar',
                ),
              ),
              TextFormField(
                controller: waterTrackingController,
                decoration: const InputDecoration(
                  labelText: 'Su Takibi (Su içip içmediği)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final petName = petNameController.text;
                    final pet = await DatabaseHelper().getPetByName(petName);
                    if (pet != null) {
                      DatabaseHelper().insertMealPlan({
                        'food_type': foodTypeController.text,
                        'meal_time': mealTimeController.text,
                        'amount': double.parse(amountController.text),
                        'water_tracking': waterTrackingController.text,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Yemek düzeni kaydedildi')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Böyle bir evcil hayvan bulunmamaktadır')),
                      );
                    }
                  }
                },
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}