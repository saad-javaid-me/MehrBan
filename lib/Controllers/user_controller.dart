import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../Models/UserModel.dart';

class UserController extends GetxController {
  final RxList<UserModel> _users = <UserModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString donorFilter = 'All'.obs; // 'All', 'Approved', 'Pending'
  final RxString currentScreen = 'Home'.obs; // 'Home', 'NGOs', 'Donors', 'Users'

  // ----- Screen Management -----
  void setCurrentScreen(String screen) {
    currentScreen.value = screen;
    searchQuery.value = '';
    if (screen != 'Donors') donorFilter.value = 'All';
  }

  // ----- Getters -----
  List<UserModel> get allUsers => _sorted(_users);

  List<UserModel> get ngos => _sorted(
    _users.where((u) => u.role == 'NGO'),
  );

  List<UserModel> get donors {
    var result = _users.where((u) => u.role == 'Donor');
    if (donorFilter.value == 'Approved') {
      result = result.where((u) => u.isApproved);
    } else if (donorFilter.value == 'Pending') {
      result = result.where((u) => !u.isApproved);
    }
    return _sorted(result);
  }

  List<UserModel> get regularUsers => _sorted(
    _users.where((u) => u.role == 'User'),
  );

  // ----- Search Filter -----
  List<UserModel> applySearch(List<UserModel> list) {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) return list;
    return list.where((u) =>
    u.name.toLowerCase().contains(query) ||
        u.email.toLowerCase().contains(query)).toList();
  }

  // ----- Core Actions -----
  Future<void> fetchUsers() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('https://donor-app-backend.vercel.app/api/auth/all-users'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final users = data['users'] as List;

        _users.clear();
        for (var userData in users) {
          UserModel user = UserModel(
            id: userData['_id'],
            name: userData['username'],
            email: userData['email'],
            role: userData['role'],
            registrationDate: DateTime.parse(userData['createdAt']),
            isApproved: userData['status'] == 'approved',
            imageUrl: '', // You can add an image URL if available in the response
          );
          _users.add(user);
        }
      } else {
        // Handle the error if the request fails
        print('Failed to load users');
      }
    } catch (e) {
      // Handle exceptions such as no internet or JSON parse errors
      print('Error fetching users: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshData() async {
    await fetchUsers();  // This will fetch fresh data
  }

  void addUser(UserModel user) {
    _users.add(user);
    _users.sort((a, b) => b.registrationDate.compareTo(a.registrationDate));
  }

  // Approve a user locally (change isApproved to true)
  void approveUser(String id) {
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      _users[index].approve();  // Using the approve method
      _users.refresh();
    }
  }

  // Reject a user locally (remove from the list)
  void rejectUser(String id) {
    _users.removeWhere((u) => u.id == id);
  }

  // ----- Approve All Users -----
  void approveAllUsers() {
    for (var user in _users) {
      user.approve();  // Approve each user
    }
    _users.refresh();
  }

  // ----- Reject All Users -----
  void rejectAllUsers() {
    _users.clear();  // Reject all users by clearing the list
  }

  // ----- Helper -----
  List<UserModel> _sorted(Iterable<UserModel> users) {
    final list = users.toList();
    list.sort((a, b) => b.registrationDate.compareTo(a.registrationDate));
    return list;
  }

  // ----- Dummy Data Init -----
  @override
  void onInit() {
    super.onInit();
    fetchUsers();  // Fetch real data from the API when the controller is initialized
  }
}
