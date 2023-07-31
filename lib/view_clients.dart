import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'add_clients3.dart';

class ViewClients extends StatefulWidget {
  const ViewClients({Key? key, required this.employees, required this.isLoading}) : super(key: key);
 final List<Employee2> employees;
  final bool isLoading;
  @override
  State<ViewClients> createState() => _ViewClientsState();
}

class _ViewClientsState extends State<ViewClients> {

  late EmployeeDataSource employeeDataSource;




  Future<void> refreshData() async {
    // setState(() {
    //   isLoading = true;
    // });
    // await fetchEmployeeData();
  }

  Future<void> _handleRefresh() async {
    // await fetchEmployeeData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back icon
        titleSpacing: 15, // Remove the default padding around the title
        title: const Text(
          'Clients Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const AddedClients(
        //             isEditing: false,
        //             id: 0,
        //           ),
        //         ),
        //       );
        //     },
        //     icon: const Icon(Icons.add),
        //   ),
        // ],
      ),
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
                child: const Icon(Icons.refresh_rounded),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  refreshData();
                },
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: widget.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: widget.employees.length,
                itemBuilder: (context, index) {
                  final employee = widget.employees[index];
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
                                child: Text(
                                  'ID: ${employee.id}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      'Acquisition: ${employee.acquisition}',
                                      style: const TextStyle(
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
                            //                     builder:
                            //                         (BuildContext context) {
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
                            //                                   color:
                            //                                       Colors.red),
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
                            icon: const Icon(Icons.edit),
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
      ),
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
                  ),
                ),
              );
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete Confirmation'),
                    content: const Text(
                        'Are you sure you want to delete this record?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
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
    String uri = "https://api.pesafy.africa/marketers/view_clients.php";
    var res = await http.get(Uri.parse(uri));
    return res;
  }
}
