import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pesafy_marketer/admin/customerservice_clients.dart';

class CustomerService extends StatefulWidget {
  const CustomerService({super.key});

  @override
  State<CustomerService> createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<List<dynamic>> getMarketers() async {
    try {
      var response = await http.get(Uri.parse(
          'https://api.pesafy.africa/marketers/get_customerservice.php'));
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

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Customer Service'),
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
                      trailing: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientsList(
                                customerServiceData: marketersData[index],
                              ),
                            ),
                          );
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
