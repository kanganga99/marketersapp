import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pesafy_marketer/main.dart';

//shows transactions based on uid

class MarketersSales extends StatefulWidget {
  const MarketersSales({Key? key, required this.sales});
  final List<MarketersSales> sales;

  @override
  State<MarketersSales> createState() => _MarketersSalesState();
}

class _MarketersSalesState extends State<MarketersSales> {
  Future<List<dynamic>> getMarketerSales() async {
    var url = 'http://api.pesafy.africa/marketers/view_sales.php';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      List<dynamic> sales = responseData;
      int? uid = globalPrefs!.getInt('id');
      print('UID from SharedPreferences: $uid');
      List<dynamic> filteredSales =
          sales.where((element) => element['uid'] == '$uid').toList();
      print(filteredSales);
      double totalAmount = 0.0;
      for (var sale in filteredSales) {
        totalAmount += double.tryParse(sale['amount'].toString()) ?? 0.0;
      }
      print('Total Amount: $totalAmount');
      return filteredSales; // Return the filtered sales data
    } else {
      throw Exception('Failed to load sales data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Transactions Breakdown'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getMarketerSales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment,
                    size: 100,
                    color: Colors.grey,
                  ),
                  Text(
                    'No data available',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            List<dynamic> salesData = snapshot.data!;
            return ListView.builder(
              itemCount: salesData.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Center(
                      child: Text('Service: ${salesData[index]['service']}'),
                    ),
                    subtitle: Column(
                      children: [
                        Text('Amount: ${salesData[index]['amount']}'),
                        Text(
                            'Transaction Code: ${salesData[index]['transaction_code']}'),
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
