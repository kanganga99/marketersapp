import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminSales extends StatefulWidget {
  const AdminSales({Key? key});

  @override
  State<AdminSales> createState() => _AdminSalesState();
}

class _AdminSalesState extends State<AdminSales> {
  Future<Map<String, dynamic>> getAllTotalSales() async {
    var url = 'https://api.pesafy.africa/marketers/view_sales.php';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        List<dynamic> sales = responseData;

        Map<String, double> totalSalesByUid = {};
        for (var sale in sales) {
          String uid = sale['uid'].toString();
          double amount = double.tryParse(sale['amount'].toString()) ?? 0.0;
          totalSalesByUid[uid] = (totalSalesByUid[uid] ?? 0.0) + amount;
        }
        return totalSalesByUid;
      } else {
        print('Request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load sales');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred while fetching data');
    }
  }

  // Generate cards from totalSalesByUid data
  // Generate cards from totalSalesByUid data including commission
  Widget buildSalesCards(Map<String, double> totalSalesByUid) {
    return Column(
      children: totalSalesByUid.entries.map((entry) {
        String uid = entry.key;
        double totalAmount = entry.value;
        double commission =
            totalAmount * 0.10; // Calculate the commission (10%)
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('UID: $uid'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Amount: $totalAmount'),
                Text('Commission: $commission'),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sales Summary'),
        centerTitle: true,
        elevation: 1,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getAllTotalSales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            // Cast the data to Map<String, double>
            Map<String, double> totalSalesByUid =
                Map<String, double>.from(snapshot.data!);
            return SingleChildScrollView(
              child: buildSalesCards(totalSalesByUid),
            );
          }
        },
      ),
    );
  }
}
