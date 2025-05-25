import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_assist/presentation/screens/homescreens/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditRecipeScreen extends StatefulWidget {
  final String recipeId;
  final Map<String, dynamic> recipe;

  const EditRecipeScreen({
    super.key,
    required this.recipeId,
    required this.recipe,
  });

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late List<TextEditingController> _stepDescriptionControllers;
  late List<TextEditingController> _stepDurationControllers;
  File? _selectedImage;
  bool _isLoading = false;
  late String _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.recipe['name']);
    _descController = TextEditingController(text: widget.recipe['description']);
    _existingImageUrl = widget.recipe['imageUrl'] ?? '';
    _stepDescriptionControllers = [];
    _stepDurationControllers = [];
    final steps = (widget.recipe['steps'] as List<dynamic>?) ?? [];
    if (steps.isEmpty) {
      _stepDescriptionControllers.add(TextEditingController());
      _stepDurationControllers.add(TextEditingController());
    } else {
      for (var step in steps) {
        _stepDescriptionControllers.add(
            TextEditingController(text: step['description']?.toString() ?? ''));
        _stepDurationControllers.add(
            TextEditingController(text: step['duration']?.toString() ?? '0'));
      }
    }
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

  Future<String?> _uploadImage(File image) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref =
          FirebaseStorage.instance.ref().child('recipe_images/$fileName');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e');
      return null;
    }
  }

  Future<void> _updateRecipe() async {
    setState(() => _isLoading = true);

    try {
      String imageUrl = _existingImageUrl;

      if (_selectedImage != null) {
        final uploadedUrl = await _uploadImage(_selectedImage!);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      final steps = _stepDescriptionControllers.asMap().entries.map((entry) {
        final index = entry.key;
        final description = entry.value.text.trim();
        final duration =
            int.tryParse(_stepDurationControllers[index].text.trim()) ?? 0;
        return {
          'description': description,
          'duration': duration,
        };
      }).toList();

      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipeId)
          .update({
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'imageUrl': imageUrl,
        'steps': steps,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Recipe updated successfully');
      Navigator.pop(context);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update recipe: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteRecipe() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: const Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(ctx, false)),
          TextButton(
              child: const Text('Delete'),
              onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('recipes')
            .doc(widget.recipeId)
            .delete();
        Get.snackbar('Deleted', 'Recipe has been deleted.');
        Get.offAll(() => const HomeScreen());
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete recipe: $e');
      }
    }
  }

  void _addStepField() {
    setState(() {
      _stepDescriptionControllers.add(TextEditingController());
      _stepDurationControllers.add(TextEditingController());
    });
  }

  void _removeStepField(int index) {
    if (_stepDescriptionControllers.length > 1) {
      setState(() {
        _stepDescriptionControllers[index].dispose();
        _stepDurationControllers[index].dispose();
        _stepDescriptionControllers.removeAt(index);
        _stepDurationControllers.removeAt(index);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    for (var controller in _stepDescriptionControllers) {
      controller.dispose();
    }
    for (var controller in _stepDurationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = _selectedImage != null
        ? Image.file(_selectedImage!, fit: BoxFit.cover)
        : _existingImageUrl.isNotEmpty
            ? Image.network(_existingImageUrl, fit: BoxFit.cover)
            : const Center(child: Text("Tap to add image"));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Delete Recipe',
            onPressed: _deleteRecipe,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageWidget,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Recipe Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            const Text(
              "Steps",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._stepDescriptionControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final descController = entry.value;
              final durationController = _stepDurationControllers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: descController,
                        decoration: InputDecoration(
                          labelText: "Step ${index + 1} Description",
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: durationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Min",
                        ),
                      ),
                    ),
                    if (_stepDescriptionControllers.length > 1)
                      IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeStepField(index),
                      ),
                  ],
                ),
              );
            }).toList(),
            TextButton.icon(
              onPressed: _addStepField,
              icon: const Icon(Icons.add),
              label: const Text("Add Step"),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: _updateRecipe,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Changes'),
                  ),
          ],
        ),
      ),
    );
  }
}
