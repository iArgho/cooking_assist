import 'dart:io';
import 'package:cooking_assist/auth/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  // Steps list: each step has a 'step' and 'time' controller
  final List<Map<String, TextEditingController>> _steps = [];

  @override
  void initState() {
    super.initState();
    _addStep(); // start with one step by default
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (var step in _steps) {
      step['step']?.dispose();
      step['time']?.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final fileId = const Uuid().v4();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('recipe_images')
          .child('$fileId.jpg');

      final uploadTask = await storageRef.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Get.snackbar("Upload Error", "Failed to upload image: $e");
      return null;
    }
  }

  void _addStep() {
    setState(() {
      _steps.add({
        'step': TextEditingController(),
        'time': TextEditingController(),
      });
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps[index]['step']?.dispose();
      _steps[index]['time']?.dispose();
      _steps.removeAt(index);
    });
  }

  void _saveRecipe() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      String? imageUrl;

      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!);
      }

      // Collect steps data
      final stepsData = _steps
          .map((e) => {
                'instruction': e['step']!.text.trim(),
                'time': e['time']!.text.trim(),
              })
          .toList();

      try {
        await Auth().saveRecipe(
          name: name,
          description: description,
          imageUrl: imageUrl,
          steps: stepsData, // Add this to your saveRecipe method
        );
        Get.snackbar("Success", "Recipe added successfully!");
        Navigator.pop(context);
      } catch (e) {
        Get.snackbar("Error", e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Recipe")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_selectedImage!,
                                    fit: BoxFit.cover),
                              )
                            : const Center(
                                child: Text("Tap to optionally add image"),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Recipe Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Please enter a recipe name" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Please enter a description" : null,
                    ),
                    const SizedBox(height: 24),
                    Text("Steps",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ..._steps.asMap().entries.map((entry) {
                      final index = entry.key;
                      final stepController = entry.value['step']!;
                      final timeController = entry.value['time']!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: stepController,
                            decoration: InputDecoration(
                              labelText: "Step ${index + 1}",
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) => value!.isEmpty
                                ? "Enter step ${index + 1}"
                                : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: timeController,
                            decoration: const InputDecoration(
                              labelText: "Time (e.g. 5 min, optional)",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_steps.length > 1)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => _removeStep(index),
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                label: const Text("Remove",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ),
                          const Divider(thickness: 1),
                        ],
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: _addStep,
                        icon: const Icon(Icons.add),
                        label: const Text("Add Step"),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveRecipe,
                        child: const Text("Save Recipe"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
