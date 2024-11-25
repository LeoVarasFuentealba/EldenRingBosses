import 'package:flutter/material.dart';
import 'api_service.dart';
import 'boss_model.dart';
import 'boss_detail_screen.dart';

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

  @override
  void initState() {
    super.initState();
    futureBosses = apiService.fetchBosses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elden Ring Bosses'),
      ),
      body: FutureBuilder<List<Boss>>(
        future: futureBosses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bosses found'));
          }

          final bosses = snapshot.data!;
          return ListView.builder(
            itemCount: bosses.length,
            itemBuilder: (context, index) {
              final boss = bosses[index];
              return Card(
                child: ListTile(
                  leading: boss.imageUrl.isNotEmpty
                      ? Image.network(boss.imageUrl, width: 50, height: 50)
                      : Icon(Icons.image_not_supported),
                  title: Text(boss.name),
                  subtitle: Text(boss.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BossDetailScreen(boss: boss),
                      ),
                    );
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
