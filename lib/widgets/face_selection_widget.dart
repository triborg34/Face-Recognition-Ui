import 'package:faceui/utils/api_service.dart';
import 'package:faceui/utils/consts.dart';
import 'package:flutter/material.dart';

/// A reusable face selection dialog.
///
/// Shows the original image with bounding boxes around detected faces,
/// face thumbnails for selection, and a confirmation step.
///
/// Usage:
/// ```dart
/// final result = await FaceSelectionWidget.show(context, detectionResult);
/// if (result != null) {
///   // result.faceIndex, result.filePath
/// }
/// ```
class FaceSelectionWidget extends StatefulWidget {
  final FaceDetectionResult detectionResult;

  const FaceSelectionWidget({super.key, required this.detectionResult});

  /// Show the face selection dialog and return the user's choice.
  ///
  /// Returns null if the user cancels.
  static Future<FaceSelectionResult?> show(
    BuildContext context,
    FaceDetectionResult detectionResult,
  ) {
    return showDialog<FaceSelectionResult>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => FaceSelectionWidget(detectionResult: detectionResult),
    );
  }

  @override
  State<FaceSelectionWidget> createState() => _FaceSelectionWidgetState();
}

/// Returned when the user confirms a face selection.
class FaceSelectionResult {
  final int faceIndex;
  final String filePath;
  final DetectedFace face;

  FaceSelectionResult({
    required this.faceIndex,
    required this.filePath,
    required this.face,
  });
}

class _FaceSelectionWidgetState extends State<FaceSelectionWidget> {
  int _selectedIndex = -1;
  final GlobalKey _imageKey = GlobalKey();

  FaceDetectionResult get _result => widget.detectionResult;
  bool get _hasOneFace => _result.faces.length == 1;

  @override
  void initState() {
    super.initState();
    // Auto-select if only one face
    if (_hasOneFace) {
      _selectedIndex = 0;
    }
  }

  void _onFaceSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onConfirm() {
    if (_selectedIndex < 0 || _selectedIndex >= _result.faces.length) return;
    Navigator.of(context).pop(FaceSelectionResult(
      faceIndex: _selectedIndex,
      filePath: _result.fileLocation,
      face: _result.faces[_selectedIndex],
    ));
  }

  void _onCancel() {
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          constraints: BoxConstraints(maxWidth: 640, maxHeight: 680),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Flexible(child: _buildBody()),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final count = _result.faces.length;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24)),
      ),
      child: Row(
        children: [
          Icon(Icons.face, color: Colors.indigo, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              count == 1
                  ? 'یک چهره شناسایی شد'
                  : '$count چهره شناسایی شد',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: _onCancel,
            icon: Icon(Icons.close, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildImageWithBoxes(),
          SizedBox(height: 16),
          _buildFaceThumbnails(),
          if (_selectedIndex >= 0) ...[
            SizedBox(height: 12),
            _buildSelectedPreview(),
          ],
        ],
      ),
    );
  }

  Widget _buildImageWithBoxes() {
    final imageWidth = _result.imageWidth.toDouble();
    final imageHeight = _result.imageHeight.toDouble();

    return Container(
      key: _imageKey,
      constraints: BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Original image
            Image.memory(
              _result.fullImageBytes,
              fit: BoxFit.contain,
              width: double.infinity,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                child: Center(child: Icon(Icons.error, color: Colors.red)),
              ),
            ),
            // Bounding boxes overlay
            if (imageWidth > 0 && imageHeight > 0)
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final scaleX = constraints.maxWidth / imageWidth;
                    final scaleY = constraints.maxHeight / imageHeight;
                    return Stack(
                      children: [
                        for (int i = 0; i < _result.faces.length; i++)
                          _buildBoundingBox(
                            i, _result.faces[i], scaleX, scaleY,
                          ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoundingBox(
    int index,
    DetectedFace face,
    double scaleX,
    double scaleY,
  ) {
    final isSelected = _selectedIndex == index;
    final bbox = face.bbox;
    final left = bbox[0] * scaleX;
    final top = bbox[1] * scaleY;
    final width = (bbox[2] - bbox[0]) * scaleX;
    final height = (bbox[3] - bbox[1]) * scaleY;

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: () => _onFaceSelected(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.green : Colors.red,
              width: isSelected ? 3 : 2,
            ),
            color: isSelected
                ? Colors.green.withOpacity(0.15)
                : Colors.red.withOpacity(0.05),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaceThumbnails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'چهره‌ها را انتخاب کنید:',
          style: TextStyle(fontSize: 13, color: Colors.white70),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _result.faces.length,
            separatorBuilder: (_, __) => SizedBox(width: 10),
            itemBuilder: (context, index) {
              final face = _result.faces[index];
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => _onFaceSelected(index),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.white24,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.memory(
                            face.cropBytes,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.black45,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          '${index + 1} - ${face.age}سال',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedPreview() {
    final face = _result.faces[_selectedIndex];
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              face.cropBytes,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'چهره انتخاب شده: #${_selectedIndex + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'جنسیت: ${face.gender == 'male' ? 'مرد' : 'زن'}  |  سن: ${face.age}',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                Text(
                  'دقت: ${(face.detScore * 100).toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.green, size: 28),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _onCancel,
            child: Text('لغو', style: TextStyle(color: Colors.white54)),
          ),
          SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _selectedIndex >= 0 ? _onConfirm : null,
            icon: Icon(Icons.check, size: 18),
            label: Text('استفاده از این چهره'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedIndex >= 0 ? Colors.green : Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
