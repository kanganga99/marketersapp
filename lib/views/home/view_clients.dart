import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pesafy_marketer/main.dart';
import 'package:pesafy_marketer/search.dart';
import 'package:pesafy_marketer/views/home/sales.dart';
import 'add_clients3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

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
  late List<Employee2> filteredEmployees = List.from(
    widget.employees.where((element) => element.acquisition == "First Time"),
  );

  late EmployeeDataSource employeeDataSource;
  final Map<int, String> acquisitionTypes = {
    0: "First Time",
    1: "Intrested",
    2: "On Boarded",
  };
  int selectedAcquisitionIndex = 0; // Default to "Not Yet"
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

  @override

  
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
                  'First Time',
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
                  'Intrested',
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
                  'On Boarded',
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

// class DatabaseHelper {
//   static Future<http.Response> getData() async {
//     String uri = "https://api.pesafy.africa/marketers/view_clients1.php";
//     var res = await http.get(Uri.parse(uri));
//     return res;
//   }
// }
