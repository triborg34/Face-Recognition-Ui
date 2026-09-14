import 'dart:typed_data';

import 'package:faceui/utils/api_service.dart';
import 'package:faceui/widgets/camera_feed.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/coustom_text_field.dart';
import 'package:faceui/widgets/face_selection_widget.dart';
import 'package:faceui/widgets/multi_image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOrEditPerson extends StatefulWidget {
  const AddOrEditPerson({
    super.key,
    required this.pcontroller,
    required this.name,
    required this.lastName,
    this.filepath,
    this.filename,
    required this.age,
    required this.gender,
    required this.role,
    required this.socialnumber,
    required this.isEditing,
    required this.selectedRole,

    this.description,
    this.id,
    this.imagePath,
  });

  final personController pcontroller;
  final String name;
  final String lastName;
  final Uint8List? filepath;
  final String? filename;
  final String age;
  final String gender;
  final String role;
  final String socialnumber;
  final bool isEditing;
  final String? imagePath;
  final String? id;
  final String? description;
  final String selectedRole;

  @override
  State<AddOrEditPerson> createState() => _AddOrEditPersonState();
}

class _AddOrEditPersonState extends State<AddOrEditPerson> {
  late final personController _pc;
  final List<SelectedImage> _selectedImages = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _pc = widget.pcontroller;
    _pc.name.text = widget.name;
    _pc.lastName.text = widget.lastName;
    _pc.socialNumber.text = widget.socialnumber;
    _pc.ageNumber.text = widget.age;
    _pc.description.text = widget.description ?? '';
    _pc.roleP.value = widget.role;
    _pc.genterP.value = widget.gender;
    _pc.selectedRole.value=widget.selectedRole;

    if (!widget.isEditing) {
      _pc.filename.value = widget.filename ?? '';
      _pc.filepath.value = widget.filepath ?? Uint8List(0);

      if (widget.filepath != null &&
          widget.filepath!.isNotEmpty &&
          widget.filename != null &&
          widget.filename!.isNotEmpty) {
        _selectedImages.add(SelectedImage(
          bytes: widget.filepath!,
          serverPath: widget.filename!,
          displayName: widget.filename!,
          faceIndex: 0,
        ));
      }
    } else {
      _pc.filename.value = '';
      _pc.filepath.value = Uint8List(0);
    }
  }

  /// Opens camera dialog, captures frame, uploads for face detection,
  /// and adds the detected face to the reference images list.
  Future<void> _captureFromCamera() async {
    final cameras = Get.find<cameraController>().cameras;
    if (cameras.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('هیچ دوربینی یافت نشد')),
        );
      }
      return;
    }

    // If only one camera, use it directly. Otherwise show selection.
    if (cameras.length == 1) {
      await _showCameraDialog(cameras.first);
    } else {
      await showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: Text('انتخاب دوربین', textDirection: TextDirection.rtl),
          children: cameras
              .map((cam) => SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showCameraDialog(cam);
                    },
                    child: Text(cam.name ?? 'دوربین'),
                  ))
              .toList(),
        ),
      );
    }
  }

  Future<void> _showCameraDialog(dynamic cam) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          bool isCapturing = false;

          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              width: 520,
              height: 420,
              child: Column(
                children: [
                  Container(
                    width: 520,
                    height: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: CameraFeed(
                        streamUrl:
                            'http://$url:$port/rt${cam.hashCode}?source=${cam.rtspUrl}&role=True',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  isCapturing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Text('در حال پردازش چهره...',
                                style: TextStyle(color: Colors.white70)),
                          ],
                        )
                      : ElevatedButton.icon(
                          icon: Icon(Icons.camera_alt, color: Colors.white),
                          label: Text('عکس بگیر',
                              style: TextStyle(color: Colors.white)),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.indigo,
                          ),
                          onPressed: () async {
                            setDialogState(() => isCapturing = true);

                            try {
                              final data = await ApiService.takePicture(
                                cam.rtspUrl!,
                                cam.name!,
                              );

                              if (data != null &&
                                  data['file_location'] != null) {
                                final serverPath = data['file_location'] ?? '';

                                // Detect all faces in the captured frame
                                final detectionResult =
                                    await ApiService.detectFacesFromPath(
                                        serverPath);

                                if (detectionResult != null &&
                                    detectionResult.faces.isNotEmpty &&
                                    mounted) {
                                  // Show face selection dialog
                                  final selection =
                                      await FaceSelectionWidget.show(
                                          context, detectionResult);

                                  if (selection != null && mounted) {
                                    setState(() {
                                      _selectedImages.add(SelectedImage(
                                        bytes: selection.face.cropBytes,
                                        serverPath: selection.filePath,
                                        displayName: 'camera_${cam.name}',
                                        faceIndex: selection.faceIndex,
                                      ));
                                    });
                                    Navigator.pop(dialogContext);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'چهره ${selection.faceIndex + 1} اضافه شد')),
                                    );
                                  }
                                } else {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'چهره‌ای در تصویر یافت نشد')),
                                    );
                                  }
                                }
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('خطا در گرفتن عکس')),
                                  );
                                }
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('خطا در گرفتن عکس: $e')),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setDialogState(() => isCapturing = false);
                              }
                            }
                          },
                        ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Pick file from device, detect faces, let user select, add to reference list.
  Future<void> _pickAndAddImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) return;

    final name = file.name;
    final dotIndex = name.lastIndexOf('.');
    final ext = dotIndex != -1 ? name.substring(dotIndex) : '';
    final uniqueName = 'img_${DateTime.now().microsecondsSinceEpoch}$ext';

    try {
      final detectionResult =
          await ApiService.detectFaces(file.bytes!, uniqueName);
      if (detectionResult != null &&
          detectionResult.faces.isNotEmpty &&
          mounted) {
        // Show face selection dialog
        final selection =
            await FaceSelectionWidget.show(context, detectionResult);
        if (selection != null && mounted) {
          setState(() {
            _selectedImages.add(SelectedImage(
              bytes: selection.face.cropBytes,
              serverPath: selection.filePath,
              displayName: name,
              faceIndex: selection.faceIndex,
            ));
          });
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('چهره‌ای در تصویر یافت نشد')),
        );
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در آپلود تصویر')),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final name = '${_pc.name.text} ${_pc.lastName.text}'.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لطفا نام را وارد کنید')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (widget.isEditing) {
        // Editing: update via PocketBase directly
        final body = <String, dynamic>{
          'name': name,
          'age': _pc.ageNumber.text,
          'gender': _pc.genterP.value,
          'socialnumber': _pc.socialNumber.text,
          'role': _pc.roleP.value,
          'description': _pc.description.text,
          'userwhom': _pc.selectedRole.value,
        };
        if (_pc.filename.value.isNotEmpty) {
          body['imagePath'] = _pc.filename.value;
        }
        await pb.collection('known_face').update(widget.id!, body: body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('شخص با موفقیت ویرایش شد')),
          );
          Navigator.pop(context);
        }
      } else {
        // New person: use backend API for face processing
        if (_selectedImages.isNotEmpty) {
          final List<String> imagePaths = [];
          for (final img in _selectedImages) {
            final serverPath = await ApiService.uploadCroppedFace(
              img.bytes,
              '${name}_${img.faceIndex}.jpg',
            );
            if (serverPath != null) {
              imagePaths.add(serverPath);
            }
          }
          if (imagePaths.isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('خطا در آپلود تصاویر')),
              );
            }
            return;
          }
          final result = await ApiService.insertPersonMulti(
            name: name,
            imagePaths: imagePaths,
            age: _pc.ageNumber.text,
            gender: _pc.genterP.value,
            role: _pc.roleP.value,
            socialnumber: _pc.socialNumber.text,
            userwhom:_pc.selectedRole.value,
            description:_pc.description.text
          );
          if (mounted) {
            final msg = result['message'] ?? 'شخص اضافه شد';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
            Navigator.pop(context);
          }
        } else if (_pc.filename.value.isNotEmpty) {
          // Single image registration (legacy path)
          final result = await ApiService.insertPersonSingle(
            name: name,
            imagePath: _pc.filename.value,
            age: _pc.ageNumber.text,
            gender: _pc.genterP.value,
            role: _pc.roleP.value,
            socialnumber: _pc.socialNumber.text,
            userwhom:_pc.selectedRole.value,
            description:_pc.description.text
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['message'] ?? 'شخص اضافه شد')),
            );
            Navigator.pop(context);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('لطفا حداقل یک تصویر انتخاب کنید'),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          padding: EdgeInsets.all(15),
          constraints: BoxConstraints(maxWidth: 560, maxHeight: 620),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.isEditing ? 'ویرایش شخص' : 'اضافه کردن شخص',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),

                // Camera and file upload buttons
                if (!widget.isEditing)
                  Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionChip(
                        icon: Icons.camera_alt,
                        label: 'عکس با دوربین',
                        onTap: _captureFromCamera,
                      ),
                      SizedBox(width: 12),
                      _buildActionChip(
                        icon: Icons.photo_library,
                        label: 'انتخاب از فایل',
                        onTap: _pickAndAddImage,
                      ),
                    ],
                  ),
                if (!widget.isEditing) SizedBox(height: 12),

                // Reference images list (only for new person)
                if (!widget.isEditing)
                  MultiImagePicker(
                    images: _selectedImages,
                    onImagesChanged: (images) {
                      setState(() {
                        _selectedImages.clear();
                        _selectedImages.addAll(images);
                      });
                    },
                    isEnabled: !_isSubmitting,
                  ),

                // For editing: show current avatar with upload option
                if (widget.isEditing)
                  Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _pickAndAddImage,
                        child: Obx(() {
                          final bytes = _pc.filepath.value;
                          final ImageProvider image =
                              (bytes != null && bytes.isNotEmpty)
                                  ? MemoryImage(bytes)
                                  : NetworkImage(
                                      fileUrl(widget.id, widget.imagePath));
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: image,
                                fit: BoxFit.fill,
                                onError: (_, __) {},
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.indigo),
                            ),
                          );
                        }),
                      ),
                      SizedBox(width: 12),
                      Column(
                        children: [
                          Text('عکس پروفایل', style: TextStyle(fontSize: 12)),
                          SizedBox(height: 4),
                          ElevatedButton.icon(
                            icon: Icon(Icons.upload, size: 16),
                            label: Text('تغییر'),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                            ),
                            onPressed: _pickAndAddImage,
                          ),
                        ],
                      ),
                    ],
                  ),

                SizedBox(height: 12),

                // Form fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      child: CoustomTextField3(
                        hint: 'نام',
                        tcontroller: _pc.name,
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 160,
                      child: CoustomTextField3(
                        hint: 'نام خانوادگی',
                        tcontroller: _pc.lastName,
                      ),
                    ),
                    SizedBox(width: 8),
                    Obx(() => SizedBox(
                          width: 100,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                focusColor: Colors.transparent,
                                fillColor: Colors.indigo,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(15),
                              value: _pc.genterP.value,
                              items: [
                                DropdownMenuItem(
                                    value: 'male', child: Text('مرد')),
                                DropdownMenuItem(
                                    value: 'female', child: Text('زن')),
                              ],
                              onChanged: (value) => _pc.genterP.value = value!,
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      child: CoustomTextField3(
                        hint: 'کد ملی',
                        tcontroller: _pc.socialNumber,
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 160,
                      child: CoustomTextField3(
                        hint: 'سن',
                        tcontroller: _pc.ageNumber,
                      ),
                    ),
                    SizedBox(width: 8),
                    Obx(() => SizedBox(
                          width: 100,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                focusColor: Colors.transparent,
                                fillColor: Colors.indigo,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(15),
                              value: _pc.roleP.value,
                              items: [
                                DropdownMenuItem(
                                    value: 'approve', child: Text('مجاز')),
                                DropdownMenuItem(
                                    value: 'denied', child: Text('غیر مجاز')),
                              ],
                              onChanged: (value) => _pc.roleP.value = value!,
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Obx(() => RadioGroup<String>(
      groupValue:_pc.selectedRole.value,
      onChanged: (String? value) {
        if (value != null) {
          _pc.selectedRole.value= value;
   
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Option: Colleague (همکار)
          const Text("همکار"),
          const Radio<String>(
            value: "colleague", // The hardcoded value for this option
          ),
          
          const SizedBox(width: 50),
          
          // 2. Option: Visitor (ارباب رجوع)
          const Text("ارباب رجوع"),
          const Radio<String>(
            value: "visitor", // The hardcoded value for this option
          ),
        ],
      ),
    )),
                SizedBox(height: 8),
                SizedBox(
                  width: 500,
                  child: CoustomTextField3(
                    hint: 'توضیحات',
                    tcontroller: _pc.description,
                  ),
                ),
                Spacer(),

                // Image count indicator
                if (!widget.isEditing && _selectedImages.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${_selectedImages.length} تصویر مرجع انتخاب شده',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),

                // Submit button
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          _isSubmitting ? Colors.grey : Colors.indigo,
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                widget.isEditing
                                    ? 'در حال ویرایش...'
                                    : 'در حال ثبت...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        : Text(
                            widget.isEditing ? 'ویرایش' : 'ثبت',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            SizedBox(width: 6),
            Text(label, style: TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
