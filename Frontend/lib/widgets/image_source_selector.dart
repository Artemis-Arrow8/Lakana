import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Widget réutilisable pour la sélection et l'aperçu d'images (Décrets, Affiches, SMS)
class ImageSourceSelector extends StatefulWidget {
  final Function(File?) onImageSelected;

  const ImageSourceSelector({
    Key? key,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  State<ImageSourceSelector> createState() => _ImageSourceSelectorState();
}

class _ImageSourceSelectorState extends State<ImageSourceSelector> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  /// Ouvre la galerie ou la caméra selon la source choisie
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      widget.onImageSelected(_selectedImage);
    }
  }

  /// Réinitialise l'image sélectionnée
  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedImage != null) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: DecorationImage(
                image: FileImage(_selectedImage!),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _clearImage,
            icon: const CircleAvatar(
              backgroundColor: Colors.black54,
              child: Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: () => _showPickerModal(context),
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(
              "Importer un décret ou une affiche",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Formats acceptés : PNG, JPG",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  /// Modale de choix de la source d'image
  void _showPickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text("Choisir depuis la galerie"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text("Prendre une photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}