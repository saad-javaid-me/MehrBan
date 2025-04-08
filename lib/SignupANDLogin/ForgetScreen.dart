import 'package:http/http.dart' as http;
import 'dart:convert'; // To decode the response
import 'package:donation_app/Custom/customtextfeild.dart';
import 'package:donation_app/colors/colors.dart';
import 'package:flutter/material.dart';

class ForgetScreen extends StatefulWidget {
  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _resetPassword() async {
    if (_emailController.text.isEmpty) {
      // Show error if email is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an email address.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading state
    });

    try {
      final response = await http.post(
        Uri.parse('https://donor-app-backend.vercel.app/api/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success']) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        } else {
          // Show error message if login fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        // Show a general server error if the response status code is not 200
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send the reset link. Please try again later.')),
        );
      }
    } catch (e) {
      // Catch any errors (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.8;
    double buttonHeight = screenWidth * 0.12;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
            const SizedBox(height: 40),
            const Text(
              "FORGET PASSWORD? ",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontFamily: "poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            const Text(
              "Enter your email",
              style: TextStyle(
                fontSize: 19,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
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
            SizedBox(height: 25),
            Center(
              child: SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
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
                  child: Text(_isLoading ? 'Sending...' : 'Send Mail'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
