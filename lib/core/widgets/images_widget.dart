
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagesWidget extends StatefulWidget {
   final List<File> selectedImages ;
  final int numberOfImage ;

   const ImagesWidget({required this.selectedImages,super.key, required this.numberOfImage,});

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  // Update _pickImage to add a new image to the list
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        setState(() {
          // Limit the maximum number of images to 4
          if (widget.selectedImages.length < widget.numberOfImage) {
            widget.selectedImages.add(imageFile);
          } else {
            // Optionally, display a message that only 4 images can be added
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Maximum of ${widget.numberOfImage} images allowed.')),
            );
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
    }
  }

// Remove image at a given index
  void _removeImage(int index) {
    setState(() {
      if (index >= 0 && index < widget.selectedImages.length) {
        widget.selectedImages.removeAt(index);
      }
    });
  }

  Widget _buildImagesPreview() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(widget.selectedImages.length, (index) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Image.file(
              widget.selectedImages[index],
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
            IconButton(
              onPressed: () => _removeImage(index),
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
              tooltip: "Remove Image",
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.selectedImages.isNotEmpty ? Column(
          children: [
            const Text(
              "Selected Image:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildImagesPreview()
          ],
        )
            : const Text("No Image Selected"),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera),
              label: const Text("Camera"),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text("Gallery"),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),

      ],
    );
  }


}
