import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pesafy_marketer/main.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key, required this.sales});
  final List<Sales> sales;

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  Future<double> getMarketerTotalSales() async {
    var url = 'https://api.pesafy.africa/marketers/view_sales.php';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      List<dynamic> sales = responseData;
      int? uid = globalPrefs!.getInt('id');
      List<dynamic> filteredSales =
          sales.where((element) => element['uid'] == '$uid').toList();
      double totalAmount = 0.0;
      for (var sale in filteredSales) {
        totalAmount += double.tryParse(sale['amount'].toString()) ?? 0.0;
      }
      return totalAmount;
    } else {
      throw Exception('Failed to load sales data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sales Summary'),
        centerTitle: true,
        elevation: 1,
      ),
      body: FutureBuilder<double>(
        future: getMarketerTotalSales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            double totalAmount = snapshot.data!;
            double commission =
                totalAmount * 0.10; // Calculate commission (10% of totalAmount)
            return Container(
              height: 250,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Icon(Icons.bar_chart),
                        title: Text('Total Amount'),
                        subtitle: Text(
                          '$totalAmount',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.bar_chart),
                        title: Text('Commissions'),
                        subtitle: Text(
                          '$commission', // Display the commission
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
