import 'package:flutter/material.dart';
import 'api_service.dart'; // Servicio para realizar peticiones a la API.
import 'boss_model.dart'; // Modelo que representa a los bosses.
import 'boss_detail_screen.dart'; // Pantalla de detalles de cada boss.
import 'new_boss.dart'; // Pantalla para agregar un nuevo boss.

void main() {
  runApp(EldenRingApp());
}

class EldenRingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elden Ring Bosses',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: BossListScreen(),
    );
  }
}

class BossListScreen extends StatefulWidget {
  @override
  _BossListScreenState createState() => _BossListScreenState();
}

class _BossListScreenState extends State<BossListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Boss>> futureBosses;

  List<Boss> bosses = []; // Lista local para manejar bosses dinámicamente.

  @override
  void initState() {
    super.initState();
    fetchBosses();
  }

  Future<void> fetchBosses() async {
    final fetchedBosses = await apiService.fetchBosses();
    setState(() {
      bosses = fetchedBosses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elden Ring Bosses'),
      ),
      body: bosses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: bosses.length,
        itemBuilder: (context, index) {
          final boss = bosses[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4.0,
            child: ListTile(
              leading: boss.imageUrl.isNotEmpty
                  ? Image.network(
                boss.imageUrl,
                width: 50,
                height: 50,
              )
                  : const Icon(Icons.image_not_supported),
              title: Text(
                boss.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    boss.description.isNotEmpty
                        ? boss.description
                        : 'No description available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Colors.grey, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${boss.rating.toInt()}/10',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BossDetailScreen(boss: boss),
                  ),
                );
                setState(() {});
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBossScreen(
                onBossAdded: (newBoss) {
                  setState(() {
                    bosses.add(newBoss); // Agrega el nuevo boss a la lista.
                  });
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add New Boss',
      ),
    );
  }
}
