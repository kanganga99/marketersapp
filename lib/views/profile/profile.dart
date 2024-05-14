import 'package:flutter/material.dart';
import 'package:pesafy_marketer/main.dart';
import 'package:pesafy_marketer/views/profile/marketerclients_summary.dart';
import 'package:pesafy_marketer/views/profile/marketersales.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
            _buildDetailsCard(),
            const SizedBox(height: 10),
            _buildSalesBreakDownCard(),
            SizedBox(height: 10),
            _buildClientsSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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

  Widget _buildSalesBreakDownCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MarketersSales(
                sales: [],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales Breakdown',
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

  Widget _buildClientsSummary() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MarketerClientsSummary(),
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
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
