import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static Future<String?> pickImage(
      {int imageQuality = 70,
      required ImageSource source,
      required CameraDevice preferredCamera}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final ImagePicker picker = ImagePicker();
    // final CameraDevice preferredCamera = CameraDevice.front;
    final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCamera,
        // 0-100, lower = more compression
        maxWidth: 1920,
        maxHeight: 1920);
    if (image != null) {
      final File originalFile = File(image.path);
      final int originalSize = originalFile.lengthSync();
      // print("Original file size: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB");
      // If still too large, try with lower quality
      if (originalSize > 2 * 1024 * 1024 && imageQuality > 30) {
        // print("File too large, trying with lower quality...");
        return await pickImage(
            imageQuality: imageQuality - 20,
            source: source,
            preferredCamera: preferredCamera);
      }
      return image.path;
    }
    return null;
  }
}
