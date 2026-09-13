import 'dart:typed_data';

import 'package:faceui/utils/api_service.dart';
import 'package:faceui/widgets/face_selection_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// Holds a single selected face: the cropped face bytes, server-side file path,
/// and the face index from detection.
class SelectedImage {
  final Uint8List bytes;
  final String serverPath;
  final String displayName;
  final int faceIndex;

  SelectedImage({
    required this.bytes,
    required this.serverPath,
    required this.displayName,
    this.faceIndex = 0,
  });
}

/// A grid of selected face images with add / remove controls.
///
/// When images are picked, they go through the face detection + selection
/// workflow before being added to the list.
class MultiImagePicker extends StatelessWidget {
  const MultiImagePicker({
    super.key,
    required this.images,
    required this.onImagesChanged,
    this.maxImages = 10,
    this.isEnabled = true,
  });

  final List<SelectedImage> images;
  final ValueChanged<List<SelectedImage>> onImagesChanged;
  final int maxImages;
  final bool isEnabled;

  Future<void> _pickImages(BuildContext context) async {
    if (images.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('حداکثر $maxImages تصویر مجاز است'),
          ),
        ),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return;

    final remaining = maxImages - images.length;
    final files = result.files.take(remaining).toList();
    final newImages = List<SelectedImage>.from(images);

    for (final file in files) {
      if (file.bytes == null) continue;

      final name = file.name;
      final dotIndex = name.lastIndexOf('.');
      final ext = dotIndex != -1 ? name.substring(dotIndex) : '';
      final uniqueName = 'face_${DateTime.now().microsecondsSinceEpoch}$ext';

      // Detect faces in the image
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('در حال شناسایی چهره...'),
                ],
              ),
            ),
          ),
        );
      }

      try {
        final detectionResult = await ApiService.detectFaces(file.bytes!, uniqueName);
        if (detectionResult == null || detectionResult.faces.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('چهره‌ای در تصویر "$name" یافت نشد'),
                ),
              ),
            );
          }
          continue;
        }

        // Show face selection dialog
        if (!context.mounted) return;
        final selection = await FaceSelectionWidget.show(context, detectionResult);
        if (selection == null) continue; // User cancelled

        newImages.add(SelectedImage(
          bytes: selection.face.cropBytes,
          serverPath: selection.filePath,
          displayName: name,
          faceIndex: selection.faceIndex,
        ));
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text('خطا در آپلود تصویر "$name"'),
              ),
            ),
          );
        }
      }
    }

    onImagesChanged(newImages);
  }

  void _removeImage(int index) {
    final newImages = List<SelectedImage>.from(images);
    newImages.removeAt(index);
    onImagesChanged(newImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Text(
              'تصاویر مرجع (${images.length})',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Spacer(),
            if (isEnabled && images.length < maxImages)
              TextButton.icon(
                onPressed: () => _pickImages(context),
                icon: Icon(Icons.add_a_photo, color: Colors.white70, size: 18),
                label: Text(
                  'افزودن تصویر',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        if (images.isEmpty)
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: isEnabled ? () => _pickImages(context) : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      color: Colors.white38, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'تصویر انتخاب کنید (چهره شناسایی و انتخاب می‌شود)',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length + (isEnabled ? 1 : 0),
              separatorBuilder: (_, __) => SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (isEnabled && index == images.length) {
                  return _buildAddButton(context);
                }
                return _buildImageTile(context, index);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      onTap: () => _pickImages(context),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24, width: 1),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white38, size: 28),
            SizedBox(height: 4),
            Text(
              'افزودن',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTile(BuildContext context, int index) {
    final image = images[index];
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.memory(
              image.bytes,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[800],
                child: Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
        ),
        if (isEnabled)
          Positioned(
            top: 4,
            left: 4,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(2),
                child: Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        Positioned(
          bottom: 4,
          right: 4,
          left: 4,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              image.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 9),
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ],
    );
  }
}
