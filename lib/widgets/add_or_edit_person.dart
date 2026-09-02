import 'dart:convert';
import 'dart:typed_data';

import 'package:faceui/utils/api_service.dart';
import 'package:faceui/widgets/camera_feed.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/coustom_text_field.dart';
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

    if (!widget.isEditing) {
      _pc.filename.value = widget.filename ?? '';
      _pc.filepath.value = widget.filepath ?? Uint8List(0);
    } else {
      _pc.filename.value = '';
      _pc.filepath.value = Uint8List(0);
    }
  }

  Future<void> _pickSingleImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) return;

    final name = file.name;
    final dotIndex = name.lastIndexOf('.');
    final ext = dotIndex != -1 ? name.substring(dotIndex) : '';
    final uniqueName = 'img_${DateTime.now().microsecondsSinceEpoch}$ext';

    try {
      final data = await ApiService.uploadImage(file.bytes!, uniqueName);
      if (data != null && mounted) {
        setState(() {
          _pc.filepath.value = data['imageData'];
          _pc.filename.value = data['fileLocation'];
        });
      }
    } catch (e) {
      debugPrint('Upload error: $e');
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
        // For editing: update via PocketBase directly (no face reprocessing)
        final body = <String, dynamic>{
          'name': name,
          'age': _pc.ageNumber.text,
          'gender': _pc.genterP.value,
          'socialnumber': _pc.socialNumber.text,
          'role': _pc.roleP.value,
          'description': _pc.description.text,
          'userwhom': unames,
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
        // For new person: use backend API for face processing
        if (_selectedImages.isNotEmpty) {
          // Multi-image registration
          final imagePaths = _selectedImages.map((img) => img.serverPath).toList();
          final result = await ApiService.insertPersonMulti(
            name: name,
            imagePaths: imagePaths,
            age: _pc.ageNumber.text,
            gender: _pc.genterP.value,
            role: _pc.roleP.value,
            socialnumber: _pc.socialNumber.text,
          );
          if (mounted) {
            final msg = result['message'] ?? 'شخص اضافه شد';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
            Navigator.pop(context);
          }
        } else if (_pc.filename.value.isNotEmpty) {
          // Single image registration (from camera capture or file upload)
          final result = await ApiService.insertPersonSingle(
            name: name,
            imagePath: _pc.filename.value,
            age: _pc.ageNumber.text,
            gender: _pc.genterP.value,
            role: _pc.roleP.value,
            socialnumber: _pc.socialNumber.text,
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
          constraints: BoxConstraints(maxWidth: 540, maxHeight: 600),
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
                // Camera capture and image upload row
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Camera buttons
                    Container(
                      height: 110,
                      width: 200,
                      child: Wrap(
                        spacing: 10,
                        direction: Axis.vertical,
                        children: [
                          for (var cam in Get.find<cameraController>().cameras)
                            InkWell(
                              onTap: () async {
                                try {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        width: 500,
                                        height: 350,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 500,
                                              height: 300,
                                              child: CameraFeed(
                                                streamUrl:
                                                    'http://$url:$port/rt${cam.hashCode}?source=${cam.rtspUrl}&role=True',
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final data = await ApiService.takePicture(
                                                  cam.rtspUrl!,
                                                  cam.name!,
                                                );
                                                if (data != null) {
                                                  _pc.filepath.value =
                                                      base64Decode(data['image_data']);
                                                  _pc.filename.value =
                                                      data['file_location'];
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Text('عکس بگیر'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  debugPrint(e.toString());
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('خطا در ارسال داده')),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.indigo),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.all(12),
                                child: Text(cam.name!),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Spacer(),
                    // Image preview / upload button
                    InkWell(
                      onTap: _pickSingleImage,
                      child: Obx(() {
                        final bytes = _pc.filepath.value;
                        final ImageProvider image =
                            (bytes != null && bytes.isNotEmpty)
                                ? MemoryImage(bytes)
                                : (widget.isEditing
                                    ? NetworkImage(
                                        fileUrl(widget.id, widget.imagePath))
                                    : AssetImage(
                                        'assets/images/unknown-person1.png'));
                        return Container(
                          width: 128,
                          height: 128,
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
                  ],
                ),
                SizedBox(height: 15),
                // Multi-image picker (only for new person)
                if (!widget.isEditing)
                  MultiImagePicker(
                    images: _selectedImages,
                    onImagesChanged: (images) {
                      setState(() => _selectedImages.clear());
                      setState(() => _selectedImages.addAll(images));
                    },
                    isEnabled: !_isSubmitting,
                  ),
                SizedBox(height: 10),
                // Form fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 165,
                      child: CoustomTextField3(
                        hint: 'نام',
                        tcontroller: _pc.name,
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 165,
                      child: CoustomTextField3(
                        hint: 'نام خانوادگی',
                        tcontroller: _pc.lastName,
                      ),
                    ),
                    SizedBox(width: 10),
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
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(15),
                              value: _pc.genterP.value,
                              items: [
                                DropdownMenuItem(value: 'male', child: Text('مرد')),
                                DropdownMenuItem(value: 'female', child: Text('زن')),
                              ],
                              onChanged: (value) => _pc.genterP.value = value!,
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 165,
                      child: CoustomTextField3(
                        hint: 'کد ملی',
                        tcontroller: _pc.socialNumber,
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 165,
                      child: CoustomTextField3(
                        hint: 'سن',
                        tcontroller: _pc.ageNumber,
                      ),
                    ),
                    SizedBox(width: 10),
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
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(15),
                              value: _pc.roleP.value,
                              items: [
                                DropdownMenuItem(value: 'approve', child: Text('مجاز')),
                                DropdownMenuItem(value: 'denied', child: Text('غیر مجاز')),
                              ],
                              onChanged: (value) => _pc.roleP.value = value!,
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 500,
                  child: CoustomTextField3(
                    hint: 'توضیحات',
                    tcontroller: _pc.description,
                  ),
                ),
                Spacer(),
                // Submit button
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: _isSubmitting ? Colors.grey : Colors.indigo,
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
}
