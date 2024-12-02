import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'boss_model.dart';

class BossDetailScreen extends StatefulWidget {
  final Boss boss; // Boss que se mostrará en la pantalla.

  const BossDetailScreen({Key? key, required this.boss}) : super(key: key);

  @override
  _BossDetailScreenState createState() => _BossDetailScreenState();
}

class _BossDetailScreenState extends State<BossDetailScreen> {
  late double _tempRating; // Calificación temporal.
  late int _currentRating; // Calificación confirmada.
  Color _backgroundColor = Colors.lightBlue[100]!; // Color de fondo inicial.

  @override
  void initState() {
    super.initState();
    _currentRating = widget.boss.rating.toInt();
    _tempRating = _currentRating.toDouble();
    _extractDominantColor(); // Extrae el color dominante de la imagen.
  }

  // Obtiene el color dominante de la imagen del boss.
  Future<void> _extractDominantColor() async {
    if (widget.boss.imageUrl.isNotEmpty) {
      try {
        final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
          NetworkImage(widget.boss.imageUrl),
        );

        setState(() {
          _backgroundColor =
              paletteGenerator.dominantColor?.color ?? Colors.lightBlue[100]!;
        });
      } catch (e) {
        debugPrint('Error extracting color: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet ${widget.boss.name}'),
        backgroundColor: _backgroundColor, // Color dinámico basado en la imagen.
        iconTheme: const IconThemeData(color: Colors.white), // Iconos blancos.
      ),
      body: Container(
        color: _backgroundColor, // Fondo dinámico.
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen del boss o icono de reemplazo.
              widget.boss.imageUrl.isNotEmpty
                  ? CircleAvatar(
                backgroundImage: NetworkImage(widget.boss.imageUrl),
                radius: 70,
              )
                  : const CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey,
                child: Icon(Icons.image_not_supported, size: 50),
              ),
              const SizedBox(height: 20),
              // Nombre y descripción del boss.
              Text(
                widget.boss.name,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                widget.boss.description.isNotEmpty
                    ? widget.boss.description
                    : 'No description available',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Calificación actual del boss.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.white),
                  const SizedBox(width: 4),
                  Text('$_currentRating/10', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              // Slider para ajustar la calificación.
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                  thumbColor: Colors.white,
                ),
                child: Slider(
                  value: _tempRating,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _tempRating.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      _tempRating = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Botón para guardar la calificación.
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentRating = _tempRating.toInt();
                    widget.boss.rating = _currentRating.toDouble();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: Text('Submit', style: TextStyle(color: _backgroundColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
