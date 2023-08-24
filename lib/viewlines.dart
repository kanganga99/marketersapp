import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'views/home/add_clients3.dart';

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
        "acquisition": employee.acquisition
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
      if (data.isNotEmpty) {
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
        Fluttertoast.showToast(
          msg: "Failed to fetch data",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      Fluttertoast.showToast(
        msg: "Failed to fetch data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddedClients(
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                final heroTag =
                    'employee_hero_${employee.id}'; // Unique hero tag
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Hero(
                      tag: heroTag,
                      child: Image.asset(
                        '../images/logoi.jpeg',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    title: Text(
                      'Business Name: ${employee.businessName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        Text(
                          'Location: ${employee.location}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Acquisition: ${employee.acquisition}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hero(
                          tag: '${heroTag}_editButton',
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
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Confirmation'),
                                  content: const Text(
                                    'Are you sure you want to delete this client?',
                                  ),
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
                      ],
                    ),
                  ),
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
  DataRow? getRow(int index) {
    if (index >= employeeData.length) {
      return null;
    }
    final employee = employeeData[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Hero(
            tag: 'employee_hero_${employee.id}',
            child: Image.asset(
              '../images/logoi.jpeg',
              height: 50,
              width: 50,
            ),
          ),
        ),
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
                      'Are you sure you want to delete this client?',
                    ),
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
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employeeData.length;

  @override
  int get selectedRowCount => 0;
}

class DatabaseHelper {
  static const String url =
      "http://localhost/pesafy_marketers/view_clients.php";
  static Future<http.Response> getData() async {
    return await http.get(Uri.parse(url));
  }
}
