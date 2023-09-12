import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  late final String username;
  final String phone;
  final String email;

  User({
    required this.username,
    required this.phone,
    required this.email,
  });
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? userProfile;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String apiUrl = "http://localhost/pesafy_marketers/get_onboarded.php";
      var res = await http.get(Uri.parse(apiUrl));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        List<String> businessNames = [];
        for (var clientData in data) {
          String businessName = clientData['business_name'];
          businessNames.add(businessName);
        }
        setState(() {
          userProfile = User(
            username:
                'Loading...', // Set a default value for username (if needed)
            phone: 'Loading...', // Set a default value for phone (if needed)
            email: 'Loading...', // Set a default value for email (if needed)
          );
          // Show only the first business_name in the list, assuming there is at least one client
          if (businessNames.isNotEmpty) {
            userProfile?.username = businessNames.first;
          }
        });
      } else {
        // Handle API error or data not found
      }
    } catch (e) {
      // Handle network or decoding error
      print(e);
    }
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
                  radius: 60,
                  backgroundImage: AssetImage('images/login.jpeg'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              userProfile?.username ?? 'Loading...',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              userProfile?.phone ?? 'Loading...',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildDetailsCard(),
            const SizedBox(height: 20),
            _buildProjectsCard(),
            const SizedBox(height: 20),
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
              title: const Text('Email'),
              subtitle: Text(userProfile?.email ?? 'Loading...'),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(userProfile?.phone ?? 'Loading...'),
            ),
            const ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Location'),
              subtitle: Text('Kasarani Goshen Gardens'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsCard() {
    return const Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Client 1'),
              subtitle: Text('Queens Classy'),
            ),
            ListTile(
              title: Text('Client 2'),
              subtitle: Text('TECH GIANT'),
            ),
            ListTile(
              title: Text('Client 3'),
              subtitle: Text('Belani SPA'),
            ),
          ],
        ),
      ),
    );
  }
}