import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class donorDashboard extends StatefulWidget {
  final String donorId;

  donorDashboard({Key? key, required this.donorId}) : super(key: key);
  @override
  _donorDashboardState createState() => _donorDashboardState();
}

class _donorDashboardState extends State<donorDashboard> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _LocationController = TextEditingController();
  String _selectedCategory = 'Clothing';
  final List<String> _categories = ['Clothing', 'Electronics', 'Furniture', 'Books', 'Others'];


  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _postDonation() async {
    final url = Uri.parse("https://donor-app-backend.vercel.app/api/donation/donate");

    String imageUrl = "https://picsum.photos/seed/donation/400/300"; // Demo image URL

    final Map<String, dynamic> donationData = {
      "donorId": widget.donorId,
      "image": imageUrl,
      "name": _nameController.text.trim(),
      "description": _descriptionController.text.trim(),
      "address": _LocationController.text.trim(),
      "category": _selectedCategory,
    };

    print("📦 Sending donation data: ${json.encode(donationData)}");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(donationData),
      );

      print("📡 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      final responseBody = json.decode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && responseBody['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Donation posted successfully")),
        );
        _clearFields();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to post donation")),
        );
      }
    } catch (e) {
      print("🚨 Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Something went wrong")),
      );
    }
  }

  void _clearFields() {
    _nameController.clear();
    _descriptionController.clear();
    _LocationController.clear();
    setState(() {
      _image = null;
      _selectedCategory = 'Clothing';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Donate an Item', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Item Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _LocationController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value.toString();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: _postDonation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  child: Text('Post Donation', style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
