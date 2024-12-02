import 'package:flutter/material.dart';
import 'api_service.dart'; // Servicio para realizar peticiones a la API.
import 'boss_model.dart'; // Modelo que representa a los bosses.
import 'boss_detail_screen.dart'; // Pantalla de detalles de cada boss.

void main() {
  runApp(EldenRingApp()); // Punto de entrada de la aplicación.
}

// Widget principal de la aplicación.
class EldenRingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elden Ring Bosses', // Título de la aplicación.
      theme: ThemeData(
        primarySwatch: Colors.deepOrange, // Tema principal de la app.
      ),
      home: BossListScreen(), // Pantalla inicial que muestra la lista de bosses.
    );
  }
}

// Pantalla que muestra la lista de bosses.
class BossListScreen extends StatefulWidget {
  @override
  _BossListScreenState createState() => _BossListScreenState();
}

// Estado asociado a la pantalla de lista de bosses.
class _BossListScreenState extends State<BossListScreen> {
  final ApiService apiService = ApiService(); // Instancia del servicio de la API.
  late Future<List<Boss>> futureBosses; // Futuro que almacena la lista de bosses.

  @override
  void initState() {
    super.initState();
    futureBosses = apiService.fetchBosses(); // Inicializa el Futuro para obtener los bosses.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elden Ring Bosses'), // Título en la AppBar.
      ),
      body: FutureBuilder<List<Boss>>(
        future: futureBosses, // Futuro que contiene la lista de bosses.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se obtienen los datos.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si la petición falla.
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Muestra un mensaje si no hay datos disponibles.
            return const Center(child: Text('No bosses found'));
          }

          final bosses = snapshot.data!; // Lista de bosses obtenida del snapshot.
          return ListView.builder(
            itemCount: bosses.length, // Número de elementos en la lista.
            itemBuilder: (context, index) {
              final boss = bosses[index]; // Boss actual en la iteración.
              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4.0,
                child: ListTile(
                  leading: boss.imageUrl.isNotEmpty
                      ? Image.network(
                    boss.imageUrl,
                    width: 50,
                    height: 50,
                  ) // Muestra la imagen del boss.
                      : const Icon(Icons.image_not_supported), // Icono alternativo si no hay imagen.
                  title: Text(
                    boss.name, // Nombre del boss.
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        boss.description.isNotEmpty
                            ? boss.description // Descripción del boss (si está disponible).
                            : 'No description available',
                        maxLines: 2, // Límite de líneas para la descripción.
                        overflow: TextOverflow.ellipsis, // Muestra "..." si el texto es muy largo.
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.grey, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${boss.rating.toInt()}/10', // Nota del boss.
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () async {
                    // Navega a la pantalla de detalles al tocar la tarjeta.
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BossDetailScreen(boss: boss),
                      ),
                    );
                    setState(() {}); // Actualiza la pantalla principal al regresar.
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
