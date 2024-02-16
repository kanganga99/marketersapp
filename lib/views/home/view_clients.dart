import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pesafy_marketer/main.dart';
import 'package:pesafy_marketer/search.dart';
// import 'package:pesafy_marketer/views/home/sales.dart';
import 'package:pesafy_marketer/views/home/user_assignment.dart';
import 'add_clients3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String id;
  final String username;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(), // Parse 'id' as a string
      username: json['username'],
      email: json['email'],
    );
  }
}

class ViewClients extends StatefulWidget {
  const ViewClients(
      {Key? key, required this.employees, required this.isLoading})
      : super(key: key);
  final List<Employee2> employees;
  final bool isLoading;
  @override
  State<ViewClients> createState() => _ViewClientsState();
}

class _ViewClientsState extends State<ViewClients> {
  var role = globalPrefs!.getString('userRole');

  Future<void> deleteEmployee(Employee employee) async {
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

  Future<List<User>> fetchUsers() async {
    final response = await http
        .get(Uri.parse('http://api.pesafy.africa/marketers/get_users.php'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final filteredJsonList = jsonList
          .where((userJson) => userJson['userRole'] == 'customer service')
          .toList();
      final users =
          filteredJsonList.map((userJson) => User.fromJson(userJson)).toList();
      print(users);
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> updateCustomerService(dynamic customerService) async {
    try {
      var data = {
        'id': customerService['id'].toString(),
        'user_assigned': customerService['user_assigned'],
      };

      var response = await http.post(
        Uri.parse('https://api.pesafy.africa/marketers/customer_service.php'),
        body: data,
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        print('Update success');
        Fluttertoast.showToast(
          msg: "Customer Service Assigned",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushNamed(context, "/");
      } else {
        Fluttertoast.showToast(
          msg: "Assigning Customer Service Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print('Update failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  late List<Employee2> filteredEmployees = List.from(
    widget.employees.where((element) => element.acquisition == "On Boarded"),
  );

  late EmployeeDataSource employeeDataSource;
  final Map<int, String> acquisitionTypes = {
    0: "On Boarded",
    1: "Interested",
    2: "First Time",
  };
  int selectedAcquisitionIndex = 0;
  int selectedSegmentIndex = 0;
  final _formKey = GlobalKey<FormState>();
  final serviceController = TextEditingController();
  final amountController = TextEditingController();
  final transaction_codeController = TextEditingController();

  @override
  void dispose() {
    serviceController.dispose();
    amountController.dispose();
    transaction_codeController.dispose();
    super.dispose();
  }

  Future<http.Response> makeSale(
    String service,
    String amount,
    String transaction_code,
  ) async {
    int? uid = globalPrefs!.getInt('id');
    print('UID from SharedPreferences: $uid');
    final response = await http.post(
      Uri.parse('https://api.pesafy.africa/marketers/sales.php'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body:
          'service=$service&amount=$amount&transaction_code=$transaction_code&uid=$uid',
    );
    return response;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
    );
  }

  Future<void> _handleRefresh() async {
    // await fetchEmployeeData();
  }

  late SharedPreferences logindata;
  late String email;
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      email = logindata.getString('email')!;
    });
  }

  Map customerService = {};

  @override
  final userRole = globalPrefs!.getString('userRole')!;
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 26.0,
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            child: Icon(Icons.logout_rounded),
            backgroundColor: Colors.blueGrey,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.logout_rounded),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // label: 'Sign Out',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('SIGN OUT?'),
                        content: const Text(
                          'Are you sure you want to sign-out?',
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Ok'),
                            onPressed: () {
                              logindata.setBool('login', true);
                              Navigator.pushNamed(context, "/");
                              //  Navigator.push( context,
                              //     MaterialPageRoute(
                              //       builder: (context) => FormScreen(),
                              //     ),
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SpeedDialChild(
                  child: Icon(Icons.search),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            Search(employees: List.from(widget.employees)),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      body: Column(children: [
        SizedBox(
          height: 40.0,
        ),
        CupertinoSlidingSegmentedControl<int>(
          groupValue: selectedSegmentIndex,
          backgroundColor: Colors.blueGrey,
          children: {
            0: Container(
              height: 40,
              child: Center(
                child: Text(
                  'On Boarded',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            1: Container(
              height: 40,
              child: Center(
                child: Text(
                  'Interested',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            2: Container(
              height: 40,
              child: Center(
                child: Text(
                  'First Time',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          },
          onValueChanged: (index) {
            setState(() {
              filteredEmployees = List.from(
                widget.employees.where((element) =>
                    element.acquisition == acquisitionTypes[index]),
              );
              selectedSegmentIndex = index!;
            });
          },
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = filteredEmployees[index];
                      final heroTag = ''
                          'employee_hero_${employee.id}'; // Unique hero tag
                      return Stack(
                        children: [
                          Card(
                            margin: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Hero(
                                  tag: heroTag,
                                  child: Image.asset(
                                    'images/logoi.jpeg',
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                ListTile(
                                  title: Center(
                                      // child: Text(
                                      //   'ID: ${employee.id}',
                                      //   style: const TextStyle(
                                      //     fontSize: 16,
                                      //     fontWeight: FontWeight.bold,
                                      //   ),
                                      //   textAlign: TextAlign.center,
                                      // ),
                                      ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8.0),
                                      Center(
                                        child: Text(
                                          'Business Name: ${employee.businessName}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          'Contact: ${employee.contact}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          'Location: ${employee.location}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            // fontWeight: FontWeight.bold,
                                            // color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddedClients(
                                      isEditing: true,
                                      id: employee.id,
                                      uid: globalPrefs!.getInt('id') ?? 0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: SizedBox(
                                        height: 420,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Material(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white,
                                              ),
                                              child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Attach Sale',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 10),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      controller:
                                                          serviceController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: 'Service',
                                                        border:
                                                            OutlineInputBorder(),
                                                        prefixIcon:
                                                            Icon(Icons.nature),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter service sold';
                                                        } else
                                                          return null;
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      controller:
                                                          amountController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: 'Amount',
                                                        border:
                                                            OutlineInputBorder(),
                                                        prefixIcon:
                                                            Icon(Icons.money),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter amount';
                                                        } else
                                                          return null;
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      controller:
                                                          transaction_codeController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Transaction Code',
                                                        border:
                                                            OutlineInputBorder(),
                                                        prefixIcon:
                                                            Icon(Icons.code),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter transaction code';
                                                        } else
                                                          return null;
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextButton(
                                                      child: Text('Save'),
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.blueGrey,
                                                        foregroundColor:
                                                            Colors.white,
                                                        fixedSize: Size(
                                                            double.maxFinite,
                                                            20),
                                                      ),
                                                      onPressed: () async {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          final service =
                                                              serviceController
                                                                  .text;
                                                          final amount =
                                                              amountController
                                                                  .text;
                                                          final transaction_code =
                                                              transaction_codeController
                                                                  .text;

                                                          final response =
                                                              await makeSale(
                                                            service,
                                                            amount,
                                                            transaction_code,
                                                          );

                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            showToast(
                                                                'Sale Completed');
                                                            print(
                                                                'Form submitted successfully');
                                                            Navigator.pushNamed(
                                                                context, "/");
                                                          } else {
                                                            throw Exception(
                                                                'Failed to submit form');
                                                          }

                                                          // Clear the form fields
                                                          serviceController
                                                              .clear();
                                                          amountController
                                                              .clear();
                                                          transaction_codeController
                                                              .clear();
                                                          // }
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          if (userRole == 'admin')
                            Positioned(
                              bottom: 8.0,
                              right: 8.0,
                              child: TextButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: SizedBox(
                                          height: 300,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Material(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white,
                                                ),
                                                child: Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Assign Customer Service',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(height: 10),
                                                      TextFormField(
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller:
                                                            serviceController,
                                                        onTap: () async {
                                                          try {
                                                            final usersList =
                                                                await fetchUsers();
                                                            final selectedUser =
                                                                await Navigator.of(
                                                                        context)
                                                                    .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return UserAssignmentPage(
                                                                      users:
                                                                          usersList);
                                                                },
                                                              ),
                                                            );

                                                            if (selectedUser !=
                                                                null) {
                                                              serviceController
                                                                      .text =
                                                                  selectedUser
                                                                      .username;
                                                            }
                                                          } catch (e) {
                                                            print(
                                                                'Error fetching users: $e');
                                                          }
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText:
                                                              'Customer Service',
                                                          border:
                                                              OutlineInputBorder(),
                                                          prefixIcon: Icon(
                                                              Icons.person),
                                                        ),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please enter customer service';
                                                          } else
                                                            return null;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      TextButton(
                                                        child: Text('Save'),
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.blueGrey,
                                                          foregroundColor:
                                                              Colors.white,
                                                          fixedSize: Size(
                                                              double.maxFinite,
                                                              40),
                                                        ),
                                                        onPressed: () async {
                                                          customerService[
                                                                  'id'] =
                                                              employee.id;
                                                          customerService[
                                                                  'user_assigned'] =
                                                              serviceController
                                                                  .text;
                                                          await updateCustomerService(
                                                            customerService,
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text('Assign'),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ]),
    );
  }
}

class Employee2 {
  final int id;
  final String businessName;
  final String contact;
  final String location;
  final String nature;
  final String acquisition;

  Employee2({
    required this.id,
    required this.businessName,
    required this.contact,
    required this.location,
    required this.nature,
    required this.acquisition,
  });
}

class EmployeeDataSource extends DataTableSource {
  final List<Employee2> employeeData;
  final Function(Employee2) deleteEmployee;
  final Function(Employee2) updateEmployee;
  final BuildContext context;

  EmployeeDataSource({
    required this.employeeData,
    required this.deleteEmployee,
    required this.updateEmployee,
    required this.context,
  });

  @override
  DataRow getRow(int index) {
    final employee = employeeData[index];
    return DataRow(
      cells: [
        DataCell(Text('ID: ${employee.id}')),
        DataCell(Text(employee.businessName)),
        DataCell(Text(employee.contact)),
        DataCell(Text(employee.location)),
        DataCell(Text(employee.nature)),
        DataCell(Text(employee.acquisition)),
        DataCell(
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddedClients(
                    isEditing: true,
                    id: employee.id,
                    uid: globalPrefs!.getInt('id') ?? 0,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => employeeData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
