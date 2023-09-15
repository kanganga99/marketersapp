import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pesafy_marketer/views/home/sales.dart';
import 'package:pesafy_marketer/views/profile/profile.dart';
import 'package:pesafy_marketer/search.dart';
import './views/home/view_clients.dart';
import 'views/home/add_clients3.dart';
import 'bottom_navigation_bar.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;
  bool isLoading = true;
  List<Employee2> employees = <Employee2>[];

  late EmployeeDataSource employeeDataSource;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await fetchEmployeeData();
  }

  @override
  void initState() {
    super.initState();
    fetchEmployeeData();
  }

  Future<void> updateEmployee(Employee2 employee) async {
    try {
      String uri = "https://api.pesafy.africa/marketers/update_clients.php";
      var res = await http.post(Uri.parse(uri), body: {
        "id": employee.id.toString(),
        "business_name": employee.businessName,
        "contact": employee.contact,
        "location": employee.location,
        "nature": employee.nature,
        "acquisition": employee.acquisition,
      });
      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
        print("Record updated");
      } else {
        print("Record not updated");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteEmployee(Employee2 employee) async {
    try {
      String uri = "https://api.pesafy.africa/marketers/delete_clients.php";
      var res =
          await http.post(Uri.parse(uri), body: {"id": employee.id.toString()});
      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
        Fluttertoast.showToast(
          msg: "Record Deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Record Not Deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchEmployeeData() async {
    final response = await DatabaseHelper.getData();
    print(response.body);
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      List<dynamic> data = responseData;
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
          employeeDataSource = EmployeeDataSource(
            employeeData: employees,
            deleteEmployee: deleteEmployee,
            updateEmployee: updateEmployee,
            context: context,
          );
          isLoading = false;
        });
      } else {
        print('Invalid response data');
        Fluttertoast.showToast(msg: 'Invalid response data');
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
    final userRole = 'admin';
    return Scaffold(
      body: [
        ViewClients(
          employees: isLoading ? [] : employees,
          isLoading: isLoading,
        ),
        if (userRole == 'admin')
          // Search(
          //   employees: isLoading ? [] : employees,
          // )
          Sales()
        else
          Search(
            employees: isLoading ? [] : employees,
          ),
        const AddedClients(
          isEditing: false,
          id: 0,
        ),
        ProfileScreen(),
      ][_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        userRole: userRole,
      ),
    );
  }
}
