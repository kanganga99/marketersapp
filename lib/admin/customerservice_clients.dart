import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pesafy_marketer/views/home/view_clients.dart';

class ClientsList extends StatefulWidget {
  final dynamic customerServiceData;

  ClientsList({required this.customerServiceData});

  @override
  State<ClientsList> createState() => _ClientsListState();
}

class _ClientsListState extends State<ClientsList> {
  bool isLoading = true;
  List<Employee2> employees = <Employee2>[];
  List<Employee2> filteredEmployees = <Employee2>[];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCustomerServiceDetails();
  }

  Future<void> getCustomerServiceDetails() async {
    var url = 'https://api.pesafy.africa/marketers/view_clients1.php';
    var response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      List<dynamic> data1 = responseData;
      List<dynamic> data;
      var username = widget.customerServiceData['username'];
      data = data1
          .where((element) => element['user_assigned'] == username)
          .toList();
      if (data.isNotEmpty) {
        final List<Employee2> fetchedEmployees = data.map<Employee2>((item) {
          final int id = int.parse(item['id']);
          final String businessName = item['business_name'];
          final String contact = item['contact'];
          final String location = item['location'];
          final String nature = item['nature'];
          final String acquisition = item['acquisition'];
          return Employee2(
            id: id,
            businessName: businessName,
            contact: contact,
            location: location,
            nature: nature,
            acquisition: acquisition,
          );
        }).toList();
        setState(() {
          employees = fetchedEmployees;
          isLoading = false;
        });
      } else {
        print('No Clients Available Yet');
        Fluttertoast.showToast(msg: 'No Clients Available Yet');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('Failed to fetch data');
      Fluttertoast.showToast(msg: 'Failed to fetch data');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.customerServiceData['username']}' 'Clients'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : employees.isEmpty
              ? Center(child: Text('No Clients Available Yet'))
              : ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                'Business Name: ${employees[index].businessName}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Center(
                              child: Text(
                                'Contact: ${employees[index].contact}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Center(
                              child: Text(
                                'Location: ${employees[index].location}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Center(
                              child: Text(
                                'Nature: ${employees[index].nature}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
