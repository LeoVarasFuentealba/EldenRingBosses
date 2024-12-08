import 'package:flutter/material.dart';
import 'boss_model.dart';

class AddBossScreen extends StatefulWidget {
  final Function(Boss) onBossAdded; // Callback para notificar que se agregó un boss.

  const AddBossScreen({Key? key, required this.onBossAdded}) : super(key: key);

  @override
  _AddBossScreenState createState() => _AddBossScreenState();
}

class _AddBossScreenState extends State<AddBossScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Boss'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Llave para validar el formulario.
          child: ListView(
            children: [
              // Campo para ingresar el nombre.
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Campo para ingresar la descripción.
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Campo para ingresar la URL de la imagen.
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Slider para seleccionar la calificación.
              Text(
                'Rating: ${_rating.toInt()}/10',
                style: const TextStyle(fontSize: 16),
              ),
              Slider(
                value: _rating,
                min: 0,
                max: 10,
                divisions: 10,
                label: _rating.toInt().toString(),
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Botón para guardar.
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Crear un nuevo boss y pasar al callback.
                    final newBoss = Boss(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      imageUrl: _imageUrlController.text,
                      rating: _rating,
                    );
                    widget.onBossAdded(newBoss);
                    Navigator.pop(context); // Volver a la pantalla anterior.
                  }
                },
                child: const Text('Add Boss'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
