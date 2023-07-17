import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'add_clients3.dart';

class ViewClients extends StatefulWidget {
  const ViewClients({Key? key}) : super(key: key);

  @override
  State<ViewClients> createState() => _ViewClientsState();
}

class _ViewClientsState extends State<ViewClients> {
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployeeData();
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await fetchEmployeeData();
  }

  Future<void> deleteEmployee(Employee employee) async {
    try {
      String uri = "http://localhost/pesafy_marketers/delete_clients.php";
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

  Future<void> updateEmployee(Employee employee) async {
    try {
      String uri = "http://localhost/pesafy_marketers/update_clients.php";
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

  Future<void> fetchEmployeeData() async {
    final response = await DatabaseHelper.getData();
    print(response.body);
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      List<dynamic> data = responseData;
      if (data != null && data.isNotEmpty) {
        final List<Employee> fetchedEmployees = data.map<Employee>((item) {
          final int id = int.parse(item['id']);
          final String businessName = item['business_name'];
          final String contact = item['contact'];
          final String location = item['location'];
          final String nature = item['nature'];
          final String acquisition = item['acquisition'];
          return Employee(
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back icon
        titleSpacing: 15, // Remove the default padding around the title
        title: Text(
          'Clients Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddedClients(
                    isEditing: false,
                    id: 0,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: 16.0,
          left: 26.0,
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            child: Icon(Icons.logout_rounded),
            backgroundColor: Colors.green,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            children: [
              SpeedDialChild(
                child: Icon(Icons.logout_rounded),
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
                        title: Text('SIGN OUT?'),
                        content: Text(
                          'Are you sure you want to sign-out?',
                        ),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.pushNamed(context, "/");
                              // deleteEmployee();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.refresh_rounded),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  onTap:
                  refreshData();
                },
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                final heroTag = ''
                    'employee_hero_${employee.id}'; // Unique hero tag
                return Stack(
                  children: [
                    Card(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Hero(
                            tag: heroTag,
                            child: Image.asset(
                              '../images/logoi.jpeg',
                              height: 100,
                              width: 100,
                            ),
                          ),
                          ListTile(
                            title: Center(
                              child: Text(
                                'ID: ${employee.id}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.0),
                                Center(
                                  child: Text(
                                    'Business Name: ${employee.businessName}',
                                    style: TextStyle(
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
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Acquisition: ${employee.acquisition}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) {
                          //         return AlertDialog(
                          //           title: Text(
                          //             'Delete Confirmation',
                          //             style: TextStyle(
                          //               fontWeight: FontWeight.bold,
                          //               color: Colors.black,
                          //               fontSize: 15,
                          //             ),
                          //           ),
                          //           content: Text(
                          //             'Are you sure you want to delete this client?',
                          //           ),
                          //           actions: [
                          //             TextButton(
                          //               child: Text('Cancel'),
                          //               onPressed: () {
                          //                 Navigator.of(context).pop();
                          //               },
                          //             ),
                          //             TextButton(
                          //               child: Text(
                          //                 'Delete',
                          //                 style: TextStyle(color: Colors.red),
                          //               ),
                          //               onPressed: () {
                          //                 Navigator.of(context).pop();
                          //                 deleteEmployee(employee);
                          //               },
                          //             ),
                          //           ],
                          //         );
                          //       },
                          //     );
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.white,
                          //     foregroundColor: Colors.black,
                          //     fixedSize: Size(500, 20),
                          //   ),
                          //   child: Text("Delete"),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 8.0),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: Row(
                          //           children: [
                          //             Expanded(
                          //               child: FloatingActionButton.extended(
                          //                 onPressed: () {
                          //                   showDialog(
                          //                     context: context,
                          //                     builder: (BuildContext context) {
                          //                       return AlertDialog(
                          //                         title: Text(
                          //                           'Delete Confirmation',
                          //                           style: TextStyle(
                          //                             fontWeight:
                          //                                 FontWeight.bold,
                          //                             color: Colors.black,
                          //                             fontSize: 15,
                          //                           ),
                          //                         ),
                          //                         content: Text(
                          //                           'Are you sure you want to delete this client?',
                          //                         ),
                          //                         actions: [
                          //                           TextButton(
                          //                             child: Text('Cancel'),
                          //                             onPressed: () {
                          //                               Navigator.of(context)
                          //                                   .pop();
                          //                             },
                          //                           ),
                          //                           TextButton(
                          //                             child: Text(
                          //                               'Delete',
                          //                               style: TextStyle(
                          //                                   color: Colors.red),
                          //                             ),
                          //                             onPressed: () {
                          //                               Navigator.of(context)
                          //                                   .pop();
                          //                               deleteEmployee(
                          //                                   employee);
                          //                             },
                          //                           ),
                          //                         ],
                          //                       );
                          //                     },
                          //                   );
                          //                 },
                          //                 label: Row(
                          //                   children: [
                          //                     Text(
                          //                       'Delete Client',
                          //                       style: TextStyle(
                          //                         fontSize: 15,
                          //                         fontWeight: FontWeight.bold,
                          //                         color: Colors.black,
                          //                       ),
                          //                     ),
                          //                     Icon(
                          //                       Icons.delete,
                          //                       size: 25,
                          //                       color: Color.fromARGB(
                          //                           255, 53, 49, 49),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 backgroundColor: Colors.white,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8.0,
                      left: 8.0,
                      child: Hero(
                        tag:
                            '${heroTag}_edit_button', // Unique hero tag for edit button
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddedClients(
                                  isEditing: true,
                                  id: employee.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class Employee {
  final int id;
  final String businessName;
  final String contact;
  final String location;
  final String nature;
  final String acquisition;

  Employee({
    required this.id,
    required this.businessName,
    required this.contact,
    required this.location,
    required this.nature,
    required this.acquisition,
  });
}

class EmployeeDataSource extends DataTableSource {
  final List<Employee> employeeData;
  final Function(Employee) deleteEmployee;
  final Function(Employee) updateEmployee;
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
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddedClients(
                    isEditing: true,
                    id: employee.id,
                  ),
                ),
              );
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Confirmation'),
                    content:
                        Text('Are you sure you want to delete this record?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Delete'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          deleteEmployee(employee);
                        },
                      ),
                    ],
                  );
                },
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

class DatabaseHelper {
  static Future<http.Response> getData() async {
    String uri = "http://localhost/pesafy_marketers/view_clients.php";
    var res = await http.get(Uri.parse(uri));
    return res;
  }
}
