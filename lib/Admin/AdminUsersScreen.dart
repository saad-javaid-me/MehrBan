import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/user_controller.dart';
import '../Widgets/UserCard.dart';

class AdminUsersScreen extends StatelessWidget {
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    userController.setCurrentScreen('Users');

    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
        actions: [/* search button */],
      ),
      body: Obx(() {
        final users = userController.regularUsers; // Use the regularUsers getter
        if (users.isEmpty) return Center(child: Text('No users found'));

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (ctx, i) => UserCard(user: users[i]),
        );
      }),
    );
  }
}