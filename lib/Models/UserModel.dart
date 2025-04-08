class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final DateTime registrationDate;
   bool isApproved;
  final String imageUrl;

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
      id: json['_id'],
      name: json['username'],
      email: json['email'],
      role: json['role'],
      registrationDate: DateTime.parse(json['createdAt']),
      isApproved: json['status'] == 'approved',
      imageUrl: '', // Add image URL if available
    );
  }

  // You can also add a method to update approval status
  void approve() {
    isApproved = true;
  }

  void reject() {
    isApproved = false;
  }
}
