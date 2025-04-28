import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../Controllers/user_controller.dart';
import '../Models/UserModel.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final bool showActions;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy hh:mm a');

  UserCard({
    Key? key,
    required this.user,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _showUserDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeader(),
              const SizedBox(height: 12),
              _buildUserFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Row(
      children: [
        _buildUserAvatar(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _buildRoleChip(),
      ],
    );
  }

  Widget _buildUserFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Registered: ${_dateFormat.format(user.registrationDate)}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showActions) _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    final userController = Get.find<UserController>();

    return !user.isApproved
        ? ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: ElevatedButton(
              onPressed: () => _handleUserApproval(userController),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                minimumSize: const Size(0, 0),
              ),
              child: const FittedBox(
                child: Text(
                  'Approve',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: OutlinedButton(
              onPressed: () => _handleUserRejection(userController),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                minimumSize: const Size(0, 0),
              ),
              child: const FittedBox(
                child: Text(
                  'Reject',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        : Chip(
      label: const Text(
        'Approved',
        style: TextStyle(color: Colors.green),
      ),
      backgroundColor: Colors.green.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Future<void> _handleUserApproval(UserController controller) async {
    await controller.approveUser(user.id);
    user.approve();  // Locally update the user status after successful approval
  }

  Future<void> _handleUserRejection(UserController controller) async {
    await controller.rejectUser(user.id);
    user.reject();  // Locally remove the user after successful rejection
  }

  Widget _buildUserAvatar() {
    return user.imageUrl?.isNotEmpty == true
        ? ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: CachedNetworkImage(
        imageUrl: user.imageUrl!,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 60,
            height: 60,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => _buildDefaultAvatar(),
      ),
    )
        : _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: _getRoleColor(user.role).withOpacity(0.3),
      child: Icon(
        _getRoleIcon(user.role),
        color: _getRoleColor(user.role),
        size: 30,
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'NGO':
        return Icons.people;
      case 'Donor':
        return Icons.volunteer_activism;
      default:
        return Icons.person;
    }
  }

  Widget _buildRoleChip() {
    return Chip(
      label: Text(
        user.role,
        style: TextStyle(
          fontSize: 12,
          color: _getRoleColor(user.role),
        ),
      ),
      backgroundColor: _getRoleColor(user.role).withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  void _showUserDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'User Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(child: _buildUserAvatar()),
              const SizedBox(height: 20),
              _buildDetailRow('Name', user.name),
              _buildDetailRow('Email', user.email),
              _buildDetailRow('Role', user.role),
              _buildDetailRow(
                'Date',
                _dateFormat.format(user.registrationDate),
              ),
              _buildDetailRow(
                'Status',
                user.isApproved ? 'Approved' : 'Pending Approval',
                valueColor: user.isApproved ? Colors.green : Colors.orange,
              ),
              const SizedBox(height: 16),
              if (showActions) _buildDialogActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogActionButtons() {
    final userController = Get.find<UserController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (!user.isApproved)
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                await _handleUserApproval(userController);
                Navigator.of(Get.context!).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('APPROVE'),
            ),
          ),
        if (!user.isApproved) const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              await _handleUserRejection(userController);
              Navigator.of(Get.context!).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('REJECT'),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'NGO':
        return Colors.blue;
      case 'Donor':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
