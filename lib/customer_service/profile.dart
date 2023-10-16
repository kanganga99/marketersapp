import 'package:flutter/material.dart';
import 'package:pesafy_marketer/main.dart';

class CustomerServiceProfile extends StatefulWidget {
  const CustomerServiceProfile({super.key});

  @override
  State<CustomerServiceProfile> createState() => _CustomerServiceProfileState();
}

class _CustomerServiceProfileState extends State<CustomerServiceProfile> {
  var username = globalPrefs!.getString('username');
  var phone = globalPrefs!.getString('phone');
  var email = globalPrefs!.getString('email');
  var password = globalPrefs!.getString('password');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('User Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/login.jpeg'),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'Welcome',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(username ?? 'Loading...'),
          SizedBox(height: 10),
          _buildDetailsCard(),
          SizedBox(height: 10),
          _buildClientsAssigned(),
          SizedBox(height: 20),
        ],
      )),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(email ?? 'Loading...'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Contact'),
              subtitle: Text(phone ?? 'Loading...'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientsAssigned() {
    return Card();
  }
}
