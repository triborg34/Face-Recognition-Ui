import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:faceui/models/knownPModels.dart';
import 'package:faceui/utils/api_service.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/widgets/multi_image_picker.dart';
import 'package:flutter/material.dart';

/// Full-screen page showing a person's details, all reference faces, and
/// controls for adding/removing faces.
class PersonDetailScreen extends StatefulWidget {
  const PersonDetailScreen({super.key, required this.person});

  final knowPerson person;

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  List<Map<String, dynamic>> _faceDetails = [];
  bool _isLoadingFaces = true;
  String? _faceError;
  final List<SelectedImage> _newFaces = [];
  bool _isAddingFaces = false;

  @override
  void initState() {
    super.initState();
    _loadFaceDetails();
  }

  Future<void> _loadFaceDetails() async {
    setState(() {
      _isLoadingFaces = true;
      _faceError = null;
    });

    try {
      final result = await ApiService.getPersonFaces(widget.person.name ?? '');
      if (result != null && mounted) {
        setState(() {
          _faceDetails = List<Map<String, dynamic>>.from(
              result['person']?['faces'] ?? []);
          _isLoadingFaces = false;
        });
      } else {
        setState(() {
          _isLoadingFaces = false;
          _faceError = 'خطا در بارگذاری اطلاعات چهره';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingFaces = false;
          _faceError = 'خطا: $e';
        });
      }
    }
  }

  Future<void> _addFaces() async {
    if (_newFaces.isEmpty || _isAddingFaces) return;

    setState(() => _isAddingFaces = true);

    try {
      for (final face in _newFaces) {
        await ApiService.addFaceReference(
          name: widget.person.name ?? '',
          imagePath: face.serverPath,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_newFaces.length} تصویر اضافه شد')),
        );
        _newFaces.clear();
        await _loadFaceDetails();
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

  Future<void> _removeFace(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف تصویر مرجع'),
        content: Text('آیا از حذف این تصویر مطمئن هستید؟'),
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
      final result = await ApiService.removeFaceReference(
        name: widget.person.name ?? '',
        embeddingIndex: index,
      );
      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تصویر حذف شد')),
          );
          await _loadFaceDetails();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'خطا در حذف')),
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
    final faceCount = person.embeddingCount ?? _faceDetails.length;

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
    final hasImage = (person.image ?? '').isNotEmpty;

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
              child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: fileUrl(person.id, person.image),
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (_, __, ___) =>
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تصاویر مرجع ($faceCount)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        if (_isLoadingFaces)
          Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(color: Colors.indigo),
            ),
          )
        else if (_faceError != null)
          Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 40),
                  SizedBox(height: 8),
                  Text(_faceError!, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: _loadFaceDetails,
                    child: Text('تلاش مجدد'),
                  ),
                ],
              ),
            ),
          )
        else if (_faceDetails.isEmpty)
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'هیچ تصویر مرجعی یافت نشد',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _calculateCrossAxisCount(context),
              childAspectRatio: 1.0,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _faceDetails.length,
            itemBuilder: (context, index) => _buildFaceCard(index),
          ),
      ],
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1000) return 6;
    if (width > 700) return 4;
    if (width > 500) return 3;
    return 2;
  }

  Widget _buildFaceCard(int index) {
    final face = _faceDetails[index];
    final imagePath = face['image_path'] ?? '';
    final hasImage = imagePath.isNotEmpty;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: hasImage
                ? GestureDetector(
                    onTap: () {
                      showImageViewer(
                        context,
                        NetworkImage(
                            'http://$url:8091/api/files/known_face/${widget.person.id}/$imagePath'),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl:
                          'http://$url:8091/api/files/known_face/${widget.person.id}/$imagePath',
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (_, __, ___) =>
                          Icon(Icons.person, color: Colors.white38),
                    ),
                  )
                : Container(
                    color: Colors.grey[800],
                    child: Icon(Icons.person, color: Colors.white38, size: 40),
                  ),
          ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: GestureDetector(
            onTap: () => _removeFace(index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(4),
              child: Icon(Icons.delete, color: Colors.white, size: 16),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
            ),
            child: Text(
              '#${index + 1}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
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
