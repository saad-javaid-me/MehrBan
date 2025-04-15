class UserModel {
  final String id;
  late final String name;
  late final String email;
  late final String role;
  late final DateTime registrationDate;
  bool isApproved;
  late final String imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.registrationDate,
    required this.isApproved,
    required this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['username'] ?? 'Unknown',
      email: json['email'] ?? '',
      role: json['role'] ?? 'User',
      registrationDate: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isApproved: (json['status'] ?? '').toString().toLowerCase() == 'approved',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  // Method to approve the user
  void approve() {
    isApproved = true;
  }

  // Method to reject the user
  void reject() {
    isApproved = false;
  }

  // Method to update user info with new data
  void updateUser(UserModel newUser) {
    name = newUser.name;
    email = newUser.email;
    role = newUser.role;
    registrationDate = newUser.registrationDate;
    isApproved = newUser.isApproved;
    imageUrl = newUser.imageUrl;
  }
}
