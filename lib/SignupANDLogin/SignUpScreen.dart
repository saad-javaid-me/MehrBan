import 'package:donation_app/Custom/customtextfeild.dart';
import 'package:donation_app/SignupANDLogin/LogInScreen.dart';
import 'package:donation_app/colors/colors.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form and state variables
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _termsAccepted = false;
  File? _ngoImage;
  final ImagePicker _picker = ImagePicker();

  // Constants
  static const List<String> _roles = ['Donor', 'NGO', 'User'];
  String? _selectedRole;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final status = await Permission.storage.request();

      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          await _showPermissionDialog(context);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Photo library access denied')),
            );
          }
        }
        return;
      }

      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null && mounted) {
        setState(() {
          _ngoImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _showPermissionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'Please enable photo library access in settings to upload images'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<bool> _signUpUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return false;

    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role")),
      );
      return false;
    }

  

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept the terms and conditions")),
      );
      return false;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('https://donor-app-backend.vercel.app/api/auth/signup');

      final body = {
        "username": _usernameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
        "role": _selectedRole!
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (!mounted) return false;

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        return true; // ✅ Sign-up successful
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Registration failed')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: ${e.toString()}")),
      );
      return false;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonWidth = screenSize.width * 0.8;
    final buttonHeight = screenSize.width * 0.12;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    "MehrBan",
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.black,
                      fontFamily: "dancing",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontFamily: "poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Create a new account",
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                _buildFormFields(context),
                const SizedBox(height: 15),
                _buildRoleDropdown(context),
                _buildLoginLink(context),
                _buildTermsCheckbox(context),
                const SizedBox(height: 15),
                _buildRegisterButton(context, buttonWidth, buttonHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _usernameController,
          labeltext: 'Username',
          hinttext: "Enter your name",
          hidetext: false,
          borderradius: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Username is required';
            }
            if (value.length < 3) {
              return 'Username must be at least 3 characters';
            }
            if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
              return 'Username can only contain letters, numbers and underscore';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        CustomTextField(
          controller: _emailController,
          labeltext: 'Email',
          hinttext: "Enter your email",
          hidetext: false,
          borderradius: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!RegExp(r'^[a-zA-Z0-9]{5,}@(gmail|yahoo|hotmail)\.com$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }

            return null;
          },
        ),
        const SizedBox(height: 15),
        CustomTextField(
          controller: _passwordController,
          labeltext: 'Password',
          hinttext: "Enter your password",
          hidetext: true,
          borderradius: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            if (!RegExp(r'[A-Z]').hasMatch(value)) {
              return 'Password must contain at least one uppercase letter';
            }
            if (!RegExp(r'[0-9]').hasMatch(value)) {
              return 'Password must contain at least one number';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        CustomTextField(
          controller: _confirmPasswordController,
          labeltext: 'Confirm Password',
          hinttext: "Retype your password",
          hidetext: true,
          borderradius: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRoleDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      hint: const Text("Select Role"),
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        errorText: _selectedRole == null ? "Please select a role" : null,
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: _roles.map((String role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role),
        );
      }).toList(),
      onChanged: (String? value) => setState(() => _selectedRole = value),
      validator: (value) => value == null ? "Please select a role" : null,
    );
  }


  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: const Text(
            "Login?",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontFamily: "poppins",
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LogInScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _termsAccepted,
          onChanged: (bool? newValue) => setState(() => _termsAccepted = newValue ?? false),
          side: const BorderSide(color: Colors.black, width: 2),
          checkColor: Colors.white,
          activeColor: Colors.black,
        ),
        const Flexible(
          child: Text(
            "By creating an account, you agree to our terms and conditions",
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: "poppins"),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context, double width, double height) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child:ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
            setState(() => _isLoading = true);

            bool success = await _signUpUser(context); // Now it returns a boolean

            setState(() => _isLoading = false);

            if (success) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LogInScreen()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(width: 1, color: FColors.barPurple),
            elevation: 10,
            backgroundColor: FColors.barPurple,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 20, fontFamily: "poppins"),
          ),
          child: Text(_isLoading ? 'Registering...' : 'Register'),
        ),
      ),
    );
  }
}