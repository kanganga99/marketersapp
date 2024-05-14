import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllBreakDown extends StatefulWidget {
  const AllBreakDown({Key? key});

  @override
  State<AllBreakDown> createState() => _AllBreakDownState();
}

class _AllBreakDownState extends State<AllBreakDown> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<List<dynamic>> getAllBreakdown(
      DateTime startDate, DateTime endDate) async {
    var url = 'https://api.pesafy.africa/marketers/view_sales.php';
    var body = {
      'start_date':
          '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
      'end_date':
          '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}',
    };
    print('Request Body: $body');
    try {
      var response = await http.post(Uri.parse(url), body: body, headers: {});
      print(response.body);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        List<dynamic> sales = responseData;
        print('Sales :$sales');
        return sales;
      } else {
        throw Exception('Failed to load sales data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred while fetching data');
    }
  }

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

      try {
        await getAllBreakdown(_startDate!, _endDate!);
      } catch (error) {
        print('Error selecting date range: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        future: getAllBreakdown(
          _startDate ?? DateTime.now().subtract(Duration(days: 7)),
          _endDate ?? DateTime.now(),
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
