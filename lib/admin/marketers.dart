import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Marketers extends StatefulWidget {
  const Marketers({super.key});

  @override
  State<Marketers> createState() => _MarketersState();
}

class _MarketersState extends State<Marketers> {
  Future<List<dynamic>> getMarketers() async {
    try {
      var response = await http
          .get(Uri.parse('https://api.pesafy.africa/marketers/get_users.php'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Marketers'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
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
                    // title: Text('Amount: ${marketersData[index]['username']}'),
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
                            'Email: ${marketersData[index]['phone']}',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
