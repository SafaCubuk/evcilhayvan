import 'package:flutter/material.dart';

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
                decoration: const InputDecoration(
                  labelText: 'Evcil Hayvanın Adı',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Türü',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Yaşı',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Ağırlık',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Sağlık Durumu',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form verilerini işleme kodu buraya gelecek
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
                decoration: const InputDecoration(
                  labelText: 'Yemek Türleri (kuru mama, yaş mama, ev yemeği vb.)',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Yemek Saatleri (Sabah, öğle, akşam)',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Miktar',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Su Takibi (Su içip içmediği)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form verilerini işleme kodu buraya gelecek
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