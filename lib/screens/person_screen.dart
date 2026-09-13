import 'package:faceui/models/knownPModels.dart';
import 'package:faceui/screens/person_detail_screen.dart';
import 'package:faceui/utils/api_service.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/add_or_edit_person.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:faceui/utils/consts.dart';

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pcontroller = Get.find<personController>();

    return Obx(() => AnimatedOpacity(
          opacity: pcontroller.isVisible.value ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await showAdaptiveDialog(
                            context: context,
                            builder: (context) => AddOrEditPerson(
                              pcontroller: pcontroller,
                              name: '',
                              lastName: '',
                              age: '',
                              filename: '',
                              filepath: null,
                              gender: 'male',
                              role: 'approve',
                              isEditing: false,
                              description: '',
                              socialnumber: '',
                            ),
                          );
                          // Refresh list and embedding counts after dialog closes
                          await pcontroller.fetchFirstData();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        child: const Text(
                          "اضافه کردن",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'افراد ثبت شده (${pcontroller.knownList.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: pcontroller.knownList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add_alt_1,
                                    size: 64, color: Colors.white24),
                                SizedBox(height: 16),
                                Text(
                                  'هنوز شخصی ثبت نشده است',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'روی دکمه "اضافه کردن" کلیک کنید',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              childAspectRatio: 200 / 400,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: pcontroller.knownList.length,
                            itemBuilder: (context, index) => PersonCard(
                              person: pcontroller.knownList[index],
                              pcontroller: pcontroller,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class PersonCard extends StatelessWidget {
  const PersonCard({
    super.key,
    required this.person,
    required this.pcontroller,
  });

  final knowPerson person;
  final personController pcontroller;

  @override
  Widget build(BuildContext context) {
    final faceCount = person.embeddingCount ?? 1;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryColor),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                _PersonAvatar(person: person),
                const SizedBox(height: 10),
                Text(
                  person.name ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(person.age ?? '', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Text(person.gender == 'male' ? 'مرد' : 'زن',
                    style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                if ((person.socialNumber ?? '').isNotEmpty)
                  Text(person.socialNumber ?? '',
                      style: TextStyle(fontSize: 11, color: Colors.white70)),
                const SizedBox(height: 4),
                // Face count badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.face, size: 12, color: Colors.white70),
                      SizedBox(width: 4),
                      Text(
                        '$faceCount',
                        style: TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Icon(
                  person.role == 'approve'
                      ? Icons.check_box
                      : Icons.cancel,
                  color: person.role == 'approve' ? Colors.green : Colors.red,
                  size: 20,
                ),
              ],
            ),
          ),
          // Edit button (top-left in RTL)
          Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () async {
                final nameParts = (person.name ?? '').split(' ');
                await showAdaptiveDialog(
                  context: context,
                  builder: (context) => AddOrEditPerson(
                    id: person.id,
                    imagePath: person.image,
                    pcontroller: pcontroller,
                    name: nameParts.isNotEmpty ? nameParts[0] : '',
                    lastName: nameParts.length > 1 ? nameParts[1] : '',
                    age: person.age ?? '',
                    gender: person.gender ?? 'male',
                    role: person.role ?? 'approve',
                    socialnumber: person.socialNumber ?? '',
                    description: person.description ?? '',
                    isEditing: true,
                  ),
                );
                // Refresh after edit dialog closes
                await pcontroller.fetchFirstData();
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.edit, size: 16, color: Colors.white70),
              ),
            ),
          ),
          // Delete button (top-right in RTL)
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('حذف شخص'),
                    content:
                        Text('آیا از حذف "${person.name}" مطمئن هستید؟'),
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
                  try {
                    await pb.collection('known_face').delete(person.id!);
                    await ApiService.refreshDb();
                  } catch (e) {
                    debugPrint('Delete failed: $e');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('خطا در حذف شخص')),
                      );
                    }
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.delete, size: 16, color: Colors.red.shade300),
              ),
            ),
          ),
          // Detail button (bottom-center)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 28),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PersonDetailScreen(person: person),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'جزئیات',
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonAvatar extends StatelessWidget {
  const _PersonAvatar({required this.person});

  final knowPerson person;

  @override
  Widget build(BuildContext context) {
    final imageProvider = personFaceImage(
      faceCrop: person.faceCrop,
      recordId: person.id,
      image: person.image,
    );
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: imageProvider != null
            ? Image(
                image: imageProvider,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person,
                  size: 36,
                  color: primaryColor,
                ),
              )
            : const Icon(
                Icons.person,
                size: 36,
                color: primaryColor,
              ),
      ),
    );
  }
}
