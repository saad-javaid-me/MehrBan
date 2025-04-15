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

        if (data is Map<String, dynamic>) {
          final usersData = data['users'] as List;

          _users.clear();
          for (var userData in usersData) {
            UserModel user = UserModel.fromJson(userData);
            _users.add(user);
          }
        }
      } else {
        print('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshData() async {
    await fetchUsers();  // Fetch fresh data from the API
  }

  void addUser(UserModel user) {
    _users.add(user);
    _users.sort((a, b) => b.registrationDate.compareTo(a.registrationDate));
  }

  // Approve a user on the backend and locally
  Future<void> approveUser(String id) async {
    try {
      final response = await http.patch(
        Uri.parse('https://donor-app-backend.vercel.app/api/auth/user-status/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'status': 'approved',
        }),
      );

      if (response.statusCode == 200) {
        final user = _users.firstWhere((u) => u.id == id);
        user.approve();
        _users.refresh();
      } else {
        print('Failed to approve user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error approving user: $e');
    }
  }

  // Reject a user on the backend and locally
  Future<void> rejectUser(String id) async {
    try {
      final response = await http.patch(
        Uri.parse('https://donor-app-backend.vercel.app/api/auth/user-status/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'status': 'rejected',
        }),
      );

      if (response.statusCode == 200) {
        _users.removeWhere((u) => u.id == id);
        _users.refresh();
      } else {
        print('Failed to reject user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error rejecting user: $e');
    }
  }

  // ----- Approve All Users -----
  Future<void> approveAllUsers() async {
    for (var user in _users) {
      await approveUser(user.id);  // Approve each user
    }
    _users.refresh();
  }

  // ----- Reject All Users -----
  Future<void> rejectAllUsers() async {
    for (var user in _users) {
      await rejectUser(user.id);  // Reject each user
    }
    _users.clear();
    _users.refresh();
  }

  // ----- Helper -----
  List<UserModel> _sorted(Iterable<UserModel> users) {
    final list = users.toList();
    list.sort((a, b) => b.registrationDate.compareTo(a.registrationDate));
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsers();  // Fetch real data from the API when the controller is initialized
  }
}
