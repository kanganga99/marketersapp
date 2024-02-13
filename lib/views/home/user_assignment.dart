import 'package:flutter/material.dart';
import 'package:pesafy_marketer/views/home/view_clients.dart';

class UserAssignmentPage extends StatefulWidget {
  final List<User> users;
  UserAssignmentPage({required this.users});
  @override
  _UserAssignmentPageState createState() => _UserAssignmentPageState();
}

class _UserAssignmentPageState extends State<UserAssignmentPage> {
  List<User> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUsers = widget.users; 
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = widget.users.where((user) {
        // Filter users based on the username
        return user.username.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Row(
            children: [
              Container(
                width: 200.0, // Adjust the width as needed
                child: TextField(
                  controller: searchController,
                  onChanged: filterUsers,
                  decoration: InputDecoration(
                    hintText: 'Search by username',
                    // prefixIcon: Icon(Icons.search),
                    border: InputBorder.none, // Remove the border
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Perform search
                },
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return ListTile(
            title: Text(user.username),
            subtitle: Text(user.email),
            onTap: () {
              Navigator.of(context).pop(user);
            },
          );
        },
      ),
    );
  }
}
