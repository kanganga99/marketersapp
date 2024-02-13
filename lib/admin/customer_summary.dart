import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerSummary extends StatefulWidget {
  const CustomerSummary({super.key});

  @override
  State<CustomerSummary> createState() => _CustomerSummaryState();
}

class _CustomerSummaryState extends State<CustomerSummary> {
  Future<List<dynamic>> getCustomersSummary() async {
    try {
      var response = await http.get(
          Uri.parse('https://api.pesafy.africa/marketers/view_clients1.php'));
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
        title: Text('Customers Summary'),
      ),
      body: FutureBuilder(
        future: getCustomersSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Handle the possibility of snapshot.data being null
            final responseData = snapshot.data as List<dynamic>? ?? [];
            int firstTimeCount = responseData.where((client) => client['acquisition'] == 'First Time').length;
            int interestedCount = responseData.where((client) => client['acquisition'] == 'Interested').length;
            int onBoardedCount = responseData.where((client) => client['acquisition'] == 'On Boarded').length;
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
