import 'package:donation_app/Admin/AdminDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donation_app/Controllers/user_controller.dart';
import 'package:donation_app/Widgets/UserCard.dart';

class AdminHomeScreen extends StatelessWidget {
  final UserController userController = Get.find();
  final String screen;

  AdminHomeScreen({Key? key, this.screen = 'Dashboard'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userController.setCurrentScreen(screen);

    return Scaffold(
      appBar: AppBar(
        title: Text(screen),
        centerTitle: true,
      ),
      drawer: AdminDrawer(),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ngos = userController.ngos;
        final donors = userController.donors;
        final users = userController.regularUsers;

        return RefreshIndicator(
          onRefresh: userController.refreshData,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Dashboard Layout
              if (screen == 'Dashboard') ...[
                if (ngos.isNotEmpty) ...[
                  sectionTitle('NGOs'),
                  ...ngos.map((user) => UserCard(user: user)).toList(),
                  const SizedBox(height: 16),
                ],
                if (donors.isNotEmpty) ...[
                  sectionTitle('Donors'),
                  ...donors.map((user) => UserCard(user: user)).toList(),
                  const SizedBox(height: 16),
                ],
                if (users.isNotEmpty) ...[
                  sectionTitle('Users'),
                  ...users.map((user) => UserCard(user: user)).toList(),
                ],
              ]
              // Specific Categories Layout
              else if (screen == 'NGOs') ...[
                sectionTitle('NGOs'),
                ...ngos.map((user) => UserCard(user: user)).toList(),
              ]
              else if (screen == 'Donors') ...[
                  sectionTitle('Donors'),
                  ...donors.map((user) => UserCard(user: user)).toList(),
                ]
                else if (screen == 'Users') ...[
                    sectionTitle('Users'),
                    ...users.map((user) => UserCard(user: user)).toList(),
                  ],
              // Empty State Handling
              if (ngos.isEmpty && donors.isEmpty && users.isEmpty)
                const Center(child: Text('No data available')),
            ],
          ),
        );
      }),
    );
  }

  Widget sectionTitle(String title) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
    ],
  );
}
