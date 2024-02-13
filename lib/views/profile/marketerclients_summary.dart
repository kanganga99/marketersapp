import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pesafy_marketer/main.dart';

class MarketerClientsSummary extends StatefulWidget {
  const MarketerClientsSummary({super.key});

  @override
  State<MarketerClientsSummary> createState() => _MarketerClientsSummaryState();
}

class _MarketerClientsSummaryState extends State<MarketerClientsSummary> {
  Future<List<dynamic>> getMarketerCustomersSummary() async {
    try {
      var response = await http.get(
          Uri.parse('https://api.pesafy.africa/marketers/view_clients1.php'));
      print(response.body);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        List<dynamic> data1 = responseData;
        List<dynamic> data;
        var userid = globalPrefs!.getInt('id');
        data = data1.where((element) => element['uid'] == '$userid').toList();
        print(data);
        return data;
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
        title: Text('Customers Summary'),
      ),
      body: FutureBuilder(
        future: getMarketerCustomersSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final data = snapshot.data as List<dynamic>? ?? [];
            int firstTimeCount = data
                .where((client) => client['acquisition'] == 'First Time')
                .length;
            int interestedCount = data
                .where((client) => client['acquisition'] == 'Interested')
                .length;
            int onBoardedCount = data
                .where((client) => client['acquisition'] == 'On Boarded')
                .length;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Center(
                        child: Text('First Time Clients:'),
                      ),
                      subtitle: Center(
                        child: Text(
                          '$firstTimeCount',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Center(
                        child: Text('Interested Clients:'),
                      ),
                      subtitle: Center(
                        child: Text(
                          '$interestedCount',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Center(
                        child: Text('On Boarded Clients:'),
                      ),
                      subtitle: Center(
                        child: Text(
                          '$onBoardedCount',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
