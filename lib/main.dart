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
    HomePage(),
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evcil Hayvanlar'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getAllPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Kayıtlı evcil hayvan bulunmamaktadır'));
          } else {
            final pets = snapshot.data!;
            return ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailPage(pet: pet),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adı: ${pet['name']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Türü: ${pet['type']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class PetDetailPage extends StatelessWidget {
  final Map<String, dynamic> pet;

  const PetDetailPage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adı: ${pet['name']}'),
            Text('Türü: ${pet['type']}'),
            Text('Yaşı: ${pet['age']}'),
            Text('Ağırlık: ${pet['weight']}'),
            Text('Sağlık Durumu: ${pet['health']}'),
            const SizedBox(height: 20),
            const Text('Yemek Düzeni:'),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper().getMealPlansByPetName(pet['name']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Bir hata oluştu'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Yemek düzeni bulunmamaktadır');
                } else {
                  final mealPlans = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: mealPlans.map((mealPlan) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Yemek Türü: ${mealPlan['food_type']}'),
                          Text('Yemek Saati: ${mealPlan['meal_time']}'),
                          Text('Miktar: ${mealPlan['amount']}'),
                          Text('Su Takibi: ${mealPlan['water_tracking']}'),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Evcil Hayvanı Sil'),
                    content: const Text('Bu evcil hayvanı silmek istiyor musunuz?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Hayır'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await DatabaseHelper().deletePet(pet['id']);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Evet'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Evcil Hayvanı Sil'),
            ),
          ],
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPetForm()),
                );
              },
              child: const Text('Yeni Evcil Hayvan Ekleme'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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