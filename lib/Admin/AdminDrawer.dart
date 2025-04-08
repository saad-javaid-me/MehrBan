import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:donation_app/Admin/AdminHomeScreen.dart';

class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Admin Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          drawerItem(title: 'Dashboard', screen: 'Dashboard'),
          drawerItem(title: 'NGOs', screen: 'NGOs'),
          drawerItem(title: 'Donors', screen: 'Donors'),
          drawerItem(title: 'Users', screen: 'Users'),
        ],
      ),
    );
  }

  ListTile drawerItem({required String title, required String screen}) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Get.offAll(() => AdminHomeScreen(screen: screen));
      },
    );
  }
}
