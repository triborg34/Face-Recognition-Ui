import 'dart:convert';
import 'package:faceui/models/userClass.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/add_or_edit_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserBoxPageOne extends StatelessWidget {
  const UserBoxPageOne({
    super.key,
    required this.ucontroller,
  });

  final userController ucontroller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: primaryColor,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "کاربران",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(15)),
              child: Obx(() => ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 0,
                    ),
                    itemBuilder: (context, index) => Container(
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Container(
                            width: 50,
                            child: Center(
                              child: Text((index + 1).toString()),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.indigo,
                          ),
                          Container(
                            width: 100,
                            child: Center(
                              child: Text(
                                ucontroller.users[index].nickname!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.indigo,
                          ),
                          Container(
                            width: 100,
                            child: Center(
                              child: Text(
                                ucontroller.users[index].username!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.indigo,
                          ),
                          Container(
                            width: 200,
                            child: Center(
                              child: Text(
                                ucontroller.users[index].email!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.indigo,
                          ),
                          Container(
                            width: 100,
                            child: Center(
                              child: Text(
                                ucontroller.users[index].role! ==
                                        'admin'
                                    ? "مدیر"
                                    : "ناظر",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.indigo,
                          ),
                          Container(
                            width: 100,
                            child: Center(
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  UsersClass user =
                                      ucontroller.users[index];
                                  String name =
                                      user.nickname!.split(' ')[0];
                                  String lastName =
                                      user.nickname!.split(' ')[1];
                                  String username = user.username!;
                                  String password = utf8.decode(
                                      base64.decode(user.password!));
                                  String email = user.email!;
                                  bool isEdit = true;
                                  String role = user.role!;
    
                                  await showAdaptiveDialog(
                                    context: context,
                                    builder: (context) =>
                                        add_or_edit_user(
                                            name: name,
                                            lastName: lastName,
                                            username: username,
                                            password: password,
                                            email: email,
                                            isEdit: isEdit,
                                            role: role,
                                            index: index,
                                            ucontroller: ucontroller),
                                  );
                                },
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.indigo,
                          ),
                          Container(
                            width: 100,
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  UsersClass user =
                                      ucontroller.users[index];
                                  await pb
                                      .collection('users')
                                      .delete(user.id!);
                                },
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.indigo,
                          )
                        ],
                      ),
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: index == 0
                              ? BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10))
                              : index == ucontroller.users.length - 1
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight:
                                          Radius.circular(10))
                                  : BorderRadius.circular(0),
                          border: Border.all(color: Colors.indigo)),
                    ),
                    itemCount: ucontroller.users.length,
                    shrinkWrap: true,
                  )),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
              onPressed: () async {
                String name = '';
                String lastName = '';
                String username = '';
                String password = '';
                String email = '';
                bool isEdit = false;
                String role = 'admin';
                await showAdaptiveDialog(
                  context: context,
                  builder: (context) => add_or_edit_user(
                      name: name,
                      lastName: lastName,
                      username: username,
                      password: password,
                      email: email,
                      isEdit: isEdit,
                      role: role,
                      ucontroller: ucontroller),
                );
              },
              child: Text(
                "اضافه کردن",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
