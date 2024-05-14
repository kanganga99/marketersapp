import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminSales extends StatefulWidget {
  const AdminSales({Key? key});

  @override
  State<AdminSales> createState() => _AdminSalesState();
}

class _AdminSalesState extends State<AdminSales> {
  Map<String, String> userDataByUid = {};
  DateTime? _startDate;
  DateTime? _endDate;
  @override
  void initState() {
    super.initState();
    getUsersData().then((userData) {
      setState(() {
        userDataByUid = userData;
      });
    });
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
        await getAllTotalSales(_startDate!, _endDate!);
      } catch (error) {
        print('Error selecting date range: $error');
      }
    }
  }

  Future<Map<String, dynamic>> getAllTotalSales(
      DateTime startDate, DateTime endDate) async {
    var url = 'https://api.pesafy.africa/marketers/view_sales.php';
    var body = {
      'start_date':
          '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
      'end_date':
          '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}',
    };
    try {
      var response = await http.post(Uri.parse(url), body: body, headers: {});
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        List<dynamic> sales = responseData;
        Map<String, double> totalSalesByUid = {};
        for (var sale in sales) {
          String uid = sale['uid'].toString();
          double amount = double.tryParse(sale['amount'].toString()) ?? 0.0;
          totalSalesByUid[uid] = (totalSalesByUid[uid] ?? 0.0) + amount;
          print(totalSalesByUid);
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

  Future<Map<String, String>> getUsersData() async {
    var url = 'https://api.pesafy.africa/marketers/get_users.php';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        List<dynamic> users = responseData;
        Map<String, String> userDataByUid = {};
        for (var user in users) {
          String uid = user['id'].toString();
          String username = user['username'].toString();
          userDataByUid[uid] = username;
        }
        return userDataByUid;
      } else {
        print('Request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred while fetching user data');
    }
  }

  Widget buildSalesCards(Map<String, double> totalSalesByUid) {
    return Column(
      children: totalSalesByUid.entries.map((entry) {
        String uid = entry.key;
        double totalAmount = entry.value;
        double commission =
            totalAmount * 0.10; // Calculate the commission (10%)
        String username = userDataByUid[uid] ?? 'N/A';
        return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Username: $username',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Total Amount: $totalAmount',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Commission: $commission',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ));
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sales Summary'),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () => _selectDateRange(context),
            icon: Icon(Icons.date_range),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getAllTotalSales(
          _startDate ?? DateTime.now().subtract(Duration(days: 7)),
          _endDate ?? DateTime.now(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || (snapshot.data as Map).isEmpty) {
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
                    'No data available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
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
