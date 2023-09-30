import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;

class EmployeesView extends StatefulWidget {
  const EmployeesView({super.key});

  @override
  State<EmployeesView> createState() => _EmployeesViewState();
}

class _EmployeesViewState extends State<EmployeesView> {
  EmployeeDataSource employeeDataSource = EmployeeDataSource([]);
  get _column => <GridColumn>[
        GridColumn(columnName: 'id', label: const Text('ID')),
        GridColumn(
            columnName: 'business_name', label: const Text('Business Name')),
        GridColumn(columnName: 'contact', label: const Text('Contact')),
        GridColumn(columnName: 'location', label: const Text('Location')),
        GridColumn(columnName: 'nature', label: const Text('Nature')),
        GridColumn(columnName: 'acquisition', label: const Text('Acquisition')),
      ];

  Future<EmployeeDataSource> generateEmployeeList() async {
    var url = 'http://localhost/pesafy_marketers/employees.php';
    try {
      final response = await http.get(Uri.parse(url));
      var list = json.decode(response.body);
      List<Employee> _employees =
          await list.map<Employee>((json) => Employee.fromJson(json)).toList();
      var employeeDataSource = EmployeeDataSource(_employees);
      return employeeDataSource;
    } catch (e) {
      print(e);
      return EmployeeDataSource([]);
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
              Navigator.pushNamed(
                context,
                '/third',
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<Object>(
          future: generateEmployeeList(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? SfDataGrid(
                    source: employeeDataSource,
                    columnWidthMode: ColumnWidthMode.fill,
                    columns: _column)
                : const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: 0.8,
                    ),
                  );
          }),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(this.employees) {
    buildDataGridRow();
  }

  late List<DataGridRow> _employeeDataGridRows;

  void buildDataGridRow() {
    _employeeDataGridRows = employees
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<int>(columnName: 'id', value: e.id),
            DataGridCell<String>(
                columnName: 'businessname', value: e.business_name),
            DataGridCell<String>(columnName: 'contact', value: e.contact),
            DataGridCell<String>(columnName: 'location', value: e.location),
            DataGridCell<String>(columnName: 'nature', value: e.nature),
            DataGridCell<String>(
                columnName: 'acquisition', value: e.acquisition),
          ]),
        )
        .toList();
  }

  List<Employee> employees;

  @override
  List<DataGridRow> get rows => _employeeDataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            e.value.toString(),
          ),
        );
      }).toList(),
    );
  }

  void updateDataGrid() {
    notifyListeners();
  }
}

class Employee {
  int id;
  // ignore: non_constant_identifier_names
  String business_name;
  String contact;
  String location;
  String nature;
  String acquisition;

  Employee({
    required this.id,
    // ignore: non_constant_identifier_names
    required this.business_name,
    required this.contact,
    required this.location,
    required this.nature,
    required this.acquisition,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: int.parse(json['id']),
      business_name: json['business_name'] as String,
      contact: json['contact'] as String,
      location: json['location'] as String,
      nature: json['nature'] as String,
      acquisition: json['acquisition'] as String,
    );
  }
}
