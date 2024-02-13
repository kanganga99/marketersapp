import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Marketers extends StatefulWidget {
  const Marketers({super.key});

  @override
  State<Marketers> createState() => _MarketersState();
}

class _MarketersState extends State<Marketers> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<List<dynamic>> getMarketers() async {
    try {
      var response = await http.get(
          Uri.parse('https://api.pesafy.africa/marketers/get_marketers.php'));
      print(response.body);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch users');
    }
  }

  final List<String> userRoles = ['admin', 'marketer', 'customer service'];
  Future<void> updateMarketer(dynamic marketerData) async {
    try {
      var data = {
        'id': marketerData['id'].toString(),
        'username': marketerData['username'],
        'phone': marketerData['phone'],
        'email': marketerData['email'],
        'userRole': marketerData['userRole'],
      };

      var response = await http.post(
        Uri.parse('https://api.pesafy.africa/marketers/update_marketer.php'),
        body: data,
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Check if the update was successful
      if (response.statusCode == 200) {
        print('Update success');
        Fluttertoast.showToast(
          msg: "Record Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Update Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print('Update failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void editMarketerDetails(dynamic marketerData) {
    TextEditingController usernameController =
        TextEditingController(text: marketerData['username']);
    TextEditingController phoneController =
        TextEditingController(text: marketerData['phone']);
    TextEditingController emailController =
        TextEditingController(text: marketerData['email']);

    // Initialize selectedUserRole with the current value
    String selectedUserRole = marketerData['userRole'];
    // Show the AlertDialog with input fields for editing
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Marketer Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 10),
                // Dropdown for selecting User Role
                DropdownButtonFormField<String>(
                  value: selectedUserRole,
                  onChanged: (newValue) {
                    setState(() {
                      selectedUserRole = newValue!;   
                    });
                  },
                  items: userRoles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'User Role'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Update the marketerData object with new values
                setState(() {
                  marketerData['username'] = usernameController.text;
                  marketerData['phone'] = phoneController.text;
                  marketerData['email'] = emailController.text;
                  marketerData['userRole'] = selectedUserRole;
                });
                Navigator.of(context).pop();
                // Call the updateMarketer function to send the updated data to the API
                updateMarketer(marketerData);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Marketers'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: FutureBuilder<List<dynamic>>(
          future: getMarketers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              List<dynamic> marketersData = snapshot.data!;
              return ListView.builder(
                itemCount: marketersData.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Name: ${marketersData[index]['username']}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Text(
                              'Email: ${marketersData[index]['email']}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Text(
                              'Phone: ${marketersData[index]['phone']}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Text(
                              'User Role: ${marketersData[index]['userRole']}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      // Add an edit icon that triggers the edit action
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          editMarketerDetails(marketersData[index]);
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
