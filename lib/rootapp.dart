import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pesafy_marketer/admin/profile.dart';
import 'package:pesafy_marketer/admin/sales.dart';
import 'package:pesafy_marketer/customer_service/profile.dart';
import 'package:pesafy_marketer/main.dart';
import 'package:pesafy_marketer/views/home/sales.dart';
import 'package:pesafy_marketer/views/profile/profile.dart';
// import 'package:pesafy_marketer/search.dart';
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
  var role = globalPrefs!.getString('userRole');
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
    var url = 'https://api.pesafy.africa/marketers/view_clients1.php';
    var response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      List<dynamic> data1 = responseData;
      var role = globalPrefs!.getString('userRole');
      List<dynamic> data = [];
      List<dynamic> customerservice = [];
      if (role == 'marketer') {
        var userid = globalPrefs!.getInt('id');
        data = data1.where((element) => element['uid'] == '$userid').toList();
        print(data);
      } else if (role == 'customer service') {
        var userassigned = globalPrefs!.getString('username');
        customerservice = data1
            .where((element) => element['user_assigned'] == '$userassigned')
            .toList();
      } else {
        data = data1;
      }

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
        print('No clients available yet');
        Fluttertoast.showToast(msg: 'No clients available yet');
        setState(() {
          isLoading = false;
        });
      }

      if (customerservice.isNotEmpty) {
        final List<Employee2> fetchedCustomerServiceEmployees =
            customerservice.map<Employee2>((item) {
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
          employees.addAll(fetchedCustomerServiceEmployees);
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
    final userRole = globalPrefs!.getString('userRole')!;
    return Scaffold(
      body: [
        ViewClients(
          employees: isLoading ? [] : employees,
          isLoading: isLoading,
        ),
        if (userRole == 'admin') AdminSales() else Sales(sales: []),
        AddedClients(
          isEditing: false,
          id: 0,
          uid: globalPrefs!.getInt('id') ?? 0,
        ),
        if (userRole == 'admin')
          AdminProfile()
        else if (userRole == 'marketer')
          ProfileScreen()
        else
          CustomerServiceProfile(),
      ][_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        userRole: userRole,
      ),
    );
  }
}
