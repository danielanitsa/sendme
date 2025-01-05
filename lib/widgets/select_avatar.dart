import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SelectAvatar {
  Future<void> showAvatarSelectionDialog(BuildContext context) async {
    File? selectedImageFile;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Avatar'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedImageFile != null)
                      Container(
                        height: 200,
                        width: 200,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(selectedImageFile!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Take a photo'),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            selectedImageFile = File(image.path);
                          });
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Choose from gallery'),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            selectedImageFile = File(image.path);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                if (selectedImageFile != null)
                  TextButton(
                    child: const Text('Select'),
                    onPressed: () =>
                        Navigator.of(context).pop(selectedImageFile),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
