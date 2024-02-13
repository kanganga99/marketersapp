import 'package:flutter/material.dart';
import 'package:pesafy_marketer/admin/customer_service.dart';
import 'package:pesafy_marketer/admin/customer_summary.dart';
import 'package:pesafy_marketer/admin/marketers.dart';
// import 'package:pesafy_marketer/admin/sales.dart';
import 'package:pesafy_marketer/admin/salesbreakdown.dart';
import 'package:pesafy_marketer/main.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  // User? userProfile;
  var username = globalPrefs!.getString('username');
  var phone = globalPrefs!.getString('phone');
  var email = globalPrefs!.getString('email');
  var password = globalPrefs!.getString('password');
  @override
  void initState() {
    super.initState();
    // fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/login.jpeg'),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Welcome.',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              (username ?? 'Loading...'),
            ),
            const SizedBox(height: 10),
            _buildProfileCard(),
            const SizedBox(height: 10),
            _buildMarketersCard(),
            SizedBox(height: 10),
            _buildCustomerServiceCard(),
            SizedBox(
              height: 10,
            ),
            _buildSalesBreakdownCard(),
            SizedBox(height: 10),
            _buildCustomerSummaryCard(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(email ?? 'Loading'),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle:
                  Text(phone ?? 'Loading...'), // Use the phone variable here
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketersCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Marketers(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Marketers',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerServiceCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CustomerService(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Service',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesBreakdownCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AllBreakDown(),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales Breakdown',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerSummaryCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CustomerSummary(),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Summary',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
