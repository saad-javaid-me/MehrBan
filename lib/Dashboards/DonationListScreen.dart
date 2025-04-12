import 'package:donation_app/Dashboards/DonationDetailsScreen.dart';
import 'package:donation_app/Models/DonationItem.dart';
import 'package:flutter/material.dart';

class DonationListScreen extends StatelessWidget {
  final List<DonationItem> donations = [
    DonationItem(
      imageUrl: 'assets/images/donationbg.png',
      name: 'Winter Jacket',
      description: 'A warm jacket for winter.',
      category: 'Clothing',
      location: 'Karachi',
    ),
    DonationItem(
      imageUrl: 'assets/images/donationbg.png',
      name: 'School Bag',
      description: 'A school bag with books and stationery.',
      category: 'Education',
      location: 'Multan',
    ),
    DonationItem(
      imageUrl: 'assets/images/donationbg.png',
      name: 'Canned Food',
      description: 'Pack of canned food items.',
      category: 'Food',
      location: 'Lahore',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Donations', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: donations.length,
          itemBuilder: (context, index) {
            final item = donations[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DonationDetailsScreen(item: item),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              item.category,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.red),
                                SizedBox(width: 5),
                                Text(
                                  item.location,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
