import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pesafy_marketer/main.dart';

class MarketersSales extends StatefulWidget {
  const MarketersSales({Key? key, required this.sales});

  final List<MarketersSales> sales;

  @override
  State<MarketersSales> createState() => _MarketersSalesState();
}

class _MarketersSalesState extends State<MarketersSales> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate == null || _endDate == null
          ? null
          : DateTimeRange(start: _startDate!, end: _endDate!),
    );

    if (picked != null && picked.start != null && picked.end != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<List<dynamic>> getMarketerSales(
      {DateTime? startDate, DateTime? endDate}) async {
    var url = 'http://api.pesafy.africa/marketers/view_sales.php';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      List<dynamic> sales = responseData;
      int? uid = globalPrefs!.getInt('id');
      print('UID from SharedPreferences: $uid');
      List<dynamic> filteredSales = sales.where((element) {
        if (element['uid'] == null) {
          return false;
        }
        if (element['created_at'] == null) {
          return true;
        }
        DateTime createdAt = DateTime.parse(element['created_at']);
        if (element['uid'].toString() != '$uid') {
          return false;
        }

        if (startDate != null && endDate != null) {
          return createdAt
                  .isAfter(startDate.subtract(const Duration(days: 1))) &&
              createdAt.isBefore(endDate.add(const Duration(days: 1)));
        } else if (startDate != null) {
          return createdAt.isAfter(startDate.subtract(const Duration(days: 1)));
        } else if (endDate != null) {
          return createdAt.isBefore(endDate.add(const Duration(days: 1)));
        }
        return true;
      }).toList();
      print(filteredSales);
      double totalAmount = 0.0;
      for (var sale in filteredSales) {
        totalAmount +=
            double.tryParse(sale['amount']?.toString() ?? '0.0') ?? 0.0;
      }
      print('Total Amount: $totalAmount');
      return filteredSales;
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
        actions: [
          IconButton(
            onPressed: () => _selectDateRange(context),
            icon: Icon(Icons.date_range),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getMarketerSales(
          startDate: _startDate,
          endDate: _endDate,
        ),
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
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'No data available yet',
                    style: TextStyle(
                      fontSize: 16,
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
