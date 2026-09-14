import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:faceui/utils/api_service.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/add_or_edit_person.dart';
import 'package:faceui/widgets/coustom_row.dart';
import 'package:faceui/widgets/face_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:http/http.dart' as http;

class DetailsBox extends StatelessWidget {
  const DetailsBox({
    super.key,
    required this.mController,
    required this.nController,
  });

  final mainController mController;
  final networkController nController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => mController.globalIndex.value == (-1)
        ? SizedBox.shrink()
        : Expanded(
            child: AnimatedCrossFade(
              duration: Duration(milliseconds: 500),
              crossFadeState: mController.isPersonSelected.value
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              secondChild: SizedBox.shrink(),
              firstChild: Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPersonName(context),
                    SizedBox(height: 15),
                    _buildAvatarComparison(),
                    SizedBox(height: 15),
                    _buildPersonDetails(),
                    SizedBox(height: 15),
                    _buildFullImage(context),
                  ],
                ),
              ),
            ),
          ));
  }

  Widget _buildPersonName(context) {
    final person = mController.person;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        person.name == "unknown"
            ? IconButton(
                onPressed: () async {
                  try {
                    final hasCropped =
                        person.croppedFrame?.isNotEmpty ?? false;
                    final imageFile = hasCropped
                        ? person.croppedFrame!
                        : (person.frame ?? '');
                    if (imageFile.isEmpty) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تصویری موجود نیست')),
                        );
                      }
                      return;
                    }

                    final imageUrl =
                        'http://${url}:8091/api/files/collection/${person.id}/$imageFile';
                    final imageResponse =
                        await http.get(Uri.parse(imageUrl));

                    if (imageResponse.statusCode == 200 &&
                        imageResponse.bodyBytes.isNotEmpty) {
                      final detectionResult =
                          await ApiService.detectFaces(
                        imageResponse.bodyBytes,
                        'face_${person.id}.jpg',
                      );

                      if (detectionResult != null &&
                          detectionResult.faces.isNotEmpty &&
                          context.mounted) {
                        final selection = await FaceSelectionWidget.show(
                            context, detectionResult);

                        if (selection != null && context.mounted) {
                          await showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return AddOrEditPerson(
                                    filename: selection.filePath,
                                    filepath:
                                        selection.face.cropBytes,
                                    pcontroller:
                                        Get.find<personController>(),
                                    name: '',
                                    lastName: '',
                                    age: person.age ?? '',
                                    gender: person.gender ?? 'male',
                                    role: 'approve',
                                    socialnumber: '',
                                    selectedRole: '',
                                    isEditing: false);
                              });
                        }
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('چهره‌ای در تصویر یافت نشد')),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('خطا: $e')),
                      );
                    }
                  }
                },
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white54,
                ))
            : person.role == 'approve'
                ? Icon(
                    Icons.check_sharp,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
        Text(
          person.name == "unknown" ? "ناشناس" : person.name!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        IconButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('حذف رخداد'),
                  content: Text('آیا از حذف این رخداد مطمئن هستید؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('لغو'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.red),
                      child: Text('حذف'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await pb.collection('collection').delete(person.id!);
                mController.isPersonSelected.value = false;
              }
            },
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ))
      ],
    );
  }

  Widget _buildAvatarComparison() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetectedAvatar(),
        Icon(Icons.arrow_forward),
        _buildKnownAvatar(),
      ],
    );
  }

  Widget _buildDetectedAvatar() {
    final person = mController.person;
    final hasImage = person.croppedFrame?.isNotEmpty ?? false;

    return CircleAvatar(
      radius: 60,
      backgroundImage: NetworkImage(
        hasImage
            ? 'http://${url}:8091/api/files/collection/${person.id}/${person.croppedFrame}'
            : 'assets/images/unknown-person1.png',
      ),
    );
  }

  Widget _buildKnownAvatar() {
    final person = mController.person;

    try {

      final knownPerson = Get.find<personController>().knownList.firstWhere(
            (p) => p.name == person.name,
          );
          
      final imageProvider = personFaceImage(
        faceCrop: knownPerson.faceCrop,
        recordId: knownPerson.id,
        image: knownPerson.image,
      );
      return CircleAvatar(
        radius: 60,
        backgroundImage: imageProvider,
      );
    } 
    catch (e) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: AssetImage('assets/images/unknown-person1.png'),
      );
    }
  }

  Widget _buildPersonDetails() {
    final person = mController.person;

    String description = '';
    try {
      final know = Get.find<personController>().knownList.firstWhere(
            (p) => p.name == person.name,
          );
      description = know.description ?? '';
    } catch (e) {
      description = '';
    }

    return Column(
      children: [
        CoustomRow(title: "شماره شناسایی", substring: person.trackId ?? '-'),
        SizedBox(height: 10),
        CoustomRow(
            title: "جنسیت",
            substring: person.gender == 'male' ? "مرد" : "زن"),
        SizedBox(height: 10),
        CoustomRow(title: "سن", substring: person.age ?? '-'),
        SizedBox(height: 10),
        CoustomRow(
            title: "تاریخ",
            substring: (person.date ?? '').toPersianDate()),
        SizedBox(height: 10),
        CoustomRow(
            title: "زمان",
            substring: (person.time ?? '').toPersianDigit()),
        SizedBox(height: 10),
        CoustomRow(title: "توضیحات", substring: description),
        SizedBox(height: 10),
        TextButton(
            onPressed: () {
              downloadPbFile(
                'http://${url}:8091/api/files/collection/${person.id}/${person.frame}',
                filename: 'frame_${person.trackId ?? person.id}.jpg',
              );
            },
            child: Text("ذخیره عکس"))
      ],
    );
  }

  Widget _buildFullImage(context) {
    final person = mController.person;
    final hasFrame = person.frame?.isNotEmpty ?? false;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: hasFrame
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: GestureDetector(
                  onTap: () async {
                    await showImageViewer(
                        context,
                        NetworkImage(
                            'http://${url}:8091/api/files/collection/${person.id}/${person.frame}'));
                  },
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 5.0,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl:
                          "http://${url}:8091/api/files/collection/${person.id}/${person.frame}",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress)),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    ),
                  ),
                ),
              )
            : Center(child: Icon(Icons.person)),
      ),
    );
  }
}
