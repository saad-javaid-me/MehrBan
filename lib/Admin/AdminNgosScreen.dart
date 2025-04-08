import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/user_controller.dart';
import '../Widgets/UserCard.dart';

class AdminNgosScreen extends StatelessWidget {
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    userController.setCurrentScreen('NGOs');

    return Scaffold(
      appBar: AppBar(
        title: Text('All NGOs'),
        actions: [/* search button */],
      ),
      body: Obx(() {
        final ngos = userController.ngos; // Use the ngos getter
        if (ngos.isEmpty) return Center(child: Text('No NGOs found'));

        return ListView.builder(
          itemCount: ngos.length,
          itemBuilder: (ctx, i) => UserCard(user: ngos[i]),
        );
      }),
    );
  }
}