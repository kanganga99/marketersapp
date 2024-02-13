import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllBreakDown extends StatefulWidget {
  const AllBreakDown({super.key});

  @override
  State<AllBreakDown> createState() => _AllBreakDownState();
}

class _AllBreakDownState extends State<AllBreakDown> {
  Future<List<dynamic>> getAllBreakdown() async {
    var url = 'http://api.pesafy.africa/marketers/view_sales.php';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      List<dynamic> sales = responseData;
      print(sales);
      return sales;
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
        future: getAllBreakdown(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
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
                        Text('Transaction Code: ${salesData[index]['transaction_code']}'),
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
