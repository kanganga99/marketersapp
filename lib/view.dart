import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      print('Error fetching data: ${response.statusCode}');
      Fluttertoast.showToast(msg: 'Error fetching data');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients Details'),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SfDataGrid(
              source: employeeDataSource,
              columnWidthMode: ColumnWidthMode.fill,
              columns: <GridColumn>[
                GridColumn(
                  columnName: 'id',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('ID'),
                  ),
                ),
                GridColumn(
                  columnName: 'business_name',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Business Name'),
                  ),
                ),
                GridColumn(
                  columnName: 'contact',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Contact'),
                  ),
                ),
                GridColumn(
                  columnName: 'location',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Location'),
                  ),
                ),
                GridColumn(
                  columnName: 'nature',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Nature'),
                  ),
                ),
                GridColumn(
                  columnName: 'acquisition',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Acquisition'),
                  ),
                ),
                GridColumn(
                  columnName: 'actions',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Actions'),
                  ),
                ),
              ],
            ),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({
    required this.employeeData,
    required this.deleteEmployee,
    required this.updateEmployee,
    required this.context,
  }) {
    buildDataGridRow();
  }

  final List<Employee> employeeData;
  final List<DataGridRow> _dataGridRows = [];
  final Function deleteEmployee;
  final Function updateEmployee;
  final BuildContext context;

  void buildDataGridRow() {
    _dataGridRows.clear();
    for (var i = 0; i < employeeData.length; i++) {
      final employee = employeeData[i];
      _dataGridRows.add(
        DataGridRow(cells: [
          DataGridCell<int>(columnName: 'id', value: employee.id),
          DataGridCell<String>(
              columnName: 'business_name', value: employee.businessName),
          DataGridCell<String>(columnName: 'contact', value: employee.contact),
          DataGridCell<String>(
              columnName: 'location', value: employee.location),
          DataGridCell<String>(columnName: 'nature', value: employee.nature),
          DataGridCell<String>(
              columnName: 'acquisition', value: employee.acquisition),
          DataGridCell<String>(
            columnName: 'Actions',
            value: '',
          ),
        ]),
      );
    }
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;
  @override
  @override
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cells = row.getCells();
    final actionCellIndex = cells.length - 1;

    final employeeId = cells[0].value as int;

    final employee = employeeData.firstWhere((emp) => emp.id == employeeId);

    return DataGridRowAdapter(
      cells: cells.map<Widget>((dataGridCell) {
        final columnName = dataGridCell.columnName;
        final cellValue = dataGridCell.value.toString();

        if (columnName == 'Actions') {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddedClients(isEditing: true, id: employeeId),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Confirmation'),
                          content: Text(
                              'Are you sure you want to delete this record?'),
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
              ],
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(cellValue),
          );
        }
      }).toList(),
    );
  }
}

class Employee {
  Employee({
    required this.id,
    required this.businessName,
    required this.contact,
    required this.location,
    required this.nature,
    required this.acquisition,
  });

  final int id;
  final String businessName;
  final String contact;
  final String location;
  final String nature;
  final String acquisition;
}

class DatabaseHelper {
  static Future<http.Response> getData() async {
    const url = 'http://localhost/pesafy_marketers/view_clients.php';
    return await http.get(Uri.parse(url));
  }
}
