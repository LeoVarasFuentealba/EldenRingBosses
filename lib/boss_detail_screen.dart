import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'boss_model.dart';

class BossDetailScreen extends StatefulWidget {
  final Boss boss;

  const BossDetailScreen({Key? key, required this.boss}) : super(key: key);

  @override
  _BossDetailScreenState createState() => _BossDetailScreenState();
}

class _BossDetailScreenState extends State<BossDetailScreen> {
  late double _tempRating; // Calificación temporal antes de confirmar
  late int _currentRating; // Calificación actual confirmada
  Color _backgroundColor = Colors.lightBlue[100]!; // Color de fondo inicial

  @override
  void initState() {
    super.initState();
    _currentRating = widget.boss.rating.toInt();
    _tempRating = _currentRating.toDouble();
    _extractDominantColor();
  }

  // Función para obtener el color dominante de la imagen
  Future<void> _extractDominantColor() async {
    try {
      if (widget.boss.imageUrl.isNotEmpty) {
        final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
          NetworkImage(widget.boss.imageUrl),
        );

        final Color dominantColor =
            paletteGenerator.dominantColor?.color ?? Colors.lightBlue[100]!;

        setState(() {
          _backgroundColor = dominantColor;
        });
      }
    } catch (e) {
      debugPrint('Error extracting color: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meet ${widget.boss.name}',
          style: const TextStyle(color: Colors.white), // Texto blanco
        ),
        backgroundColor: _backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white), // Iconos blancos
      ),
      body: Container(
        width: double.infinity,
        color: _backgroundColor, // Color dinámico basado en la imagen
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen del boss
              widget.boss.imageUrl.isNotEmpty
                  ? CircleAvatar(
                backgroundImage: NetworkImage(widget.boss.imageUrl),
                radius: 70,
              )
                  : CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Nombre del boss
              Text(
                widget.boss.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto blanco
                ),
              ),
              const SizedBox(height: 8),
              // Descripción del boss
              Text(
                widget.boss.description.isNotEmpty
                    ? widget.boss.description
                    : 'No description available',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Texto blanco
                ),
              ),
              const SizedBox(height: 20),
              // Calificación actual
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.white), // Icono blanco
                  const SizedBox(width: 4),
                  Text(
                    '$_currentRating/10',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto blanco
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Slider para calificar (valor temporal)
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.black, // Texto del label del slider
                  ),
                  activeTrackColor: Colors.white, // Barra activa blanca
                  inactiveTrackColor: Colors.white.withOpacity(0.3), // Barra inactiva
                  thumbColor: Colors.white, // Icono del slider blanco
                  overlayColor: Colors.white.withOpacity(0.2), // Resplandor blanco
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
              // Botón para guardar
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentRating = _tempRating.toInt();
                    widget.boss.rating = _currentRating.toDouble();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 10),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(color: _backgroundColor), // Texto del botón
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}