import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/user_controller.dart';
import '../Widgets/UserCard.dart';

class AdminDonorsScreen extends StatelessWidget {
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    userController.setCurrentScreen('Donors');

    return Scaffold(
      appBar: AppBar(
        title: Text('All Donors'),
        actions: [/* filter button */],
      ),
      body: Obx(() {
        final donors = userController.donors; // Use the donors getter
        if (donors.isEmpty) return Center(child: Text('No donors found'));

        return ListView.builder(
          itemCount: donors.length,
          itemBuilder: (ctx, i) => UserCard(user: donors[i]),
        );
      }),
    );
  }
}