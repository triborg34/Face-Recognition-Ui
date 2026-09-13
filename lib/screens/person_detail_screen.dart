import 'package:faceui/models/knownPModels.dart';
import 'package:faceui/utils/api_service.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/multi_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Full-screen page showing a person's details, all reference faces, and
/// controls for adding/removing faces.
class PersonDetailScreen extends StatefulWidget {
  const PersonDetailScreen({super.key, required this.person});

  final knowPerson person;

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  final List<SelectedImage> _newFaces = [];
  bool _isAddingFaces = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addFaces() async {
    if (_newFaces.isEmpty || _isAddingFaces) return;

    setState(() => _isAddingFaces = true);

    try {
      for (final face in _newFaces) {
        // Use registerFace to register the specific selected face
        await ApiService.registerFace(
          filePath: face.serverPath,
          faceIndex: face.faceIndex,
          name: widget.person.name ?? '',
          gender: widget.person.gender ?? 'male',
          age: widget.person.age ?? '',
          role: widget.person.role ?? 'approve',
          socialnumber: widget.person.socialNumber ?? '',
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_newFaces.length} تصویر اضافه شد')),
        );
        _newFaces.clear();
        // Refresh the person data from PocketBase
        await Get.find<personController>().fetchFirstData();
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در افزودن تصویر: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAddingFaces = false);
    }
  }

  Future<void> _deletePerson() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف شخص'),
        content: Text('آیا از حذف "${widget.person.name}" مطمئن هستید؟\nتمام تصاویر چهره حذف خواهند شد.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('لغو'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final success = await ApiService.deletePerson(widget.person.name ?? '');
      if (success) {
        await ApiService.refreshDb();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('شخص حذف شد')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطا در حذف شخص')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final person = widget.person;
    final faceCount = person.embeddingCount ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(person.name ?? '', textDirection: TextDirection.rtl),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: _deletePerson,
            tooltip: 'حذف شخص',
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Person info header
              _buildPersonHeader(person),
              SizedBox(height: 24),
              // Reference faces section
              _buildFacesSection(faceCount),
              SizedBox(height: 24),
              // Add new faces section
              _buildAddFacesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonHeader(knowPerson person) {
    final imageProvider = personFaceImage(
      faceCrop: person.faceCrop,
      recordId: person.id,
      image: person.image,
    );

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryColor),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.indigo, width: 2),
            ),
            child: ClipOval(
              child: imageProvider != null
                  ? Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.person, size: 40, color: Colors.indigo),
                    )
                  : Icon(Icons.person, size: 40, color: Colors.indigo),
            ),
          ),
          SizedBox(width: 20),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name ?? '',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _infoChip(person.gender == 'male' ? 'مرد' : 'زن'),
                    SizedBox(width: 8),
                    _infoChip('سن: ${person.age ?? '-'}'),
                    SizedBox(width: 8),
                    _infoChip(person.role == 'approve' ? 'مجاز' : 'غیر مجاز'),
                  ],
                ),
                if ((person.socialNumber ?? '').isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text('کد ملی: ${person.socialNumber}',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
                if ((person.description ?? '').isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text('توضیحات: ${person.description}',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 12)),
    );
  }

  Widget _buildFacesSection(int faceCount) {
    final person = widget.person;
    final imageProvider = personFaceImage(
      faceCrop: person.faceCrop,
      recordId: person.id,
      image: person.image,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تصاویر مرجع ($faceCount)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Face crop preview
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: imageProvider != null
                        ? Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[800],
                              child: Icon(Icons.person,
                                  color: Colors.white38, size: 48),
                            ),
                          )
                        : Container(
                            color: Colors.grey[800],
                            child: Icon(Icons.person,
                                color: Colors.white38, size: 48),
                          ),
                  ),
                ),
                SizedBox(width: 20),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'چهره مرجع',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$faceCount بردار چهره ثبت شده',
                        style:
                            TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                      SizedBox(height: 4),
                      if (imageProvider != null)
                        Text(
                          'تصویر چهره: موجود',
                          style: TextStyle(
                              fontSize: 12, color: Colors.green),
                        )
                      else
                        Text(
                          'تصویر چهره: موجود نیست',
                          style: TextStyle(
                              fontSize: 12, color: Colors.white54),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAddFacesSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'افزودن تصاویر مرجع جدید',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          MultiImagePicker(
            images: _newFaces,
            onImagesChanged: (images) {
              setState(() {
                _newFaces.clear();
                _newFaces.addAll(images);
              });
            },
            isEnabled: !_isAddingFaces,
          ),
          SizedBox(height: 12),
          if (_newFaces.isNotEmpty)
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      _isAddingFaces ? Colors.grey : Colors.indigo,
                ),
                onPressed: _isAddingFaces ? null : _addFaces,
                child: _isAddingFaces
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('در حال افزودن...'),
                        ],
                      )
                    : Text('افزودن ${_newFaces.length} تصویر مرجع'),
              ),
            ),
        ],
      ),
    );
  }
}
