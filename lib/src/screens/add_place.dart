import 'dart:io';

import 'package:favorite_places/src/controllers/places_controller.dart';
import 'package:favorite_places/src/models/place.dart';
import 'package:favorite_places/src/widgets/image_input.dart';
import 'package:favorite_places/src/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPlaceState();
}

class _NewPlaceState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  void _addPlace() {
    if (_formKey.currentState!.validate() &&
        _selectedImage != null &&
        _selectedLocation != null) {
      ref
          .read(placesProvider.notifier)
          .addPlace(_titleController.text, _selectedImage!, _selectedLocation!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  autocorrect: false,
                  controller: _titleController,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ImageInput(
                  onPickImage: (image) => _selectedImage = image,
                ),
                const SizedBox(height: 10),
                LocationInput(
                    onSelectLocation: (location) =>
                        _selectedLocation = location),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _addPlace,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Place'),
                )
              ],
            )),
      ),
    );
  }
}
