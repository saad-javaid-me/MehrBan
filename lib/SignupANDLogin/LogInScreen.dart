import 'package:donation_app/Admin/AdminHomeScreen.dart';
import 'package:donation_app/Custom/customtextfeild.dart';
import 'package:donation_app/SignupANDLogin/ForgetScreen.dart';
import 'package:donation_app/SignupANDLogin/SignUpScreen.dart';
import 'package:donation_app/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final url = Uri.parse('https://donor-app-backend.vercel.app/api/auth/signin');

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "email": _emailController.text.trim(),
            "password": _passwordController.text,
          }),
        );

        if (!mounted) return;

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['success'] == true) {
          // Successful login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );

          // Get the user role
          String role = responseData['user']['role'];

          // Navigate to different dashboards based on the role
          if (role == 'Admin') {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminHomeScreen()));
          } else if (role == 'User') {
            // Navigator.pushReplacementNamed(context, '/userDashboard');
          } else if (role == 'Donor') {
            // Navigator.pushReplacementNamed(context, '/donorDashboard');
          } else if (role == 'NGO') {
            // Navigator.pushReplacementNamed(context, '/ngoDashboard');
          } else {
            // Default to user dashboard if the role is unrecognized
            // Navigator.pushReplacementNamed(context, '/userDashboard');
          }
        } else {
          // Login failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Login failed')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: ${e.toString()}")),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.8;
    double buttonHeight = screenWidth * 0.12;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
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
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Sign in to your account",
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _emailController,
                    labeltext: 'Email',
                    hinttext: "Enter your email",
                    hidetext: false,
                    borderradius: 10,
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter your email';
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Enter a valid email';
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
                    validator: (value) =>
                    value!.length < 6 ? 'Password must be at least 6 characters' : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          // Navigate to Forgot Password Screen
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ForgetScreen()));
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      width: buttonWidth,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _loginUser,
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(width: 1, color: FColors.barPurple),
                          elevation: 10,
                          backgroundColor: FColors.barPurple,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontFamily: "poppins",
                          ),
                        ),
                        child: Text(_isLoading ? 'Logging in...' : 'Login'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontFamily: "poppins",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}