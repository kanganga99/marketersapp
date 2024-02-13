import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Employee {
  int id;
  String businessName;
  String contact;
  String location;
  String nature;
  String acquisition;

  Employee({
    required this.id,
    required this.businessName,
    required this.contact,
    required this.location,
    required this.nature,
    required this.acquisition,
  });
}

Employee? editingEmployee; // Holds the employee being edited, if any

class AddedClients extends StatefulWidget {
  final bool isEditing;
  const AddedClients(
      {Key? key, required this.isEditing, required int id, required int uid})
      : super(key: key);

  @override
  _AddedClientsState createState() => _AddedClientsState();
}

class _AddedClientsState extends State<AddedClients> {
  TextEditingController businessnameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController natureController = TextEditingController();
  TextEditingController acquisitionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isEditing = false;
  late Employee editedEmployee; // Track the edited employee object

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      isEditing = true;
      fetchEmployeeData(); // Fetch the employee data for editing
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void fetchEmployeeData() async {
    var url = Uri.parse('http://localhost/pesafy_marketers/get_employee.php');
    final response = await http.post(url, body: {
      'id': editedEmployee.id.toString(),
    });

    if (response.statusCode == 200) {
      // Parse the response body to get the employee data
      Map<String, dynamic> data = json.decode(response.body);
      // Set the initial values of the text controllers with the employee data
      setState(() {
        editedEmployee = Employee(
          id: editedEmployee.id,
          businessName: data['business_name'],
          contact: data['contact'],
          location: data['location'],
          nature: data['nature'],
          acquisition: data['acquisition'],
        );

        businessnameController.text = editedEmployee.businessName;
        contactController.text = editedEmployee.contact;
        locationController.text = editedEmployee.location;
        natureController.text = editedEmployee.nature;
        acquisitionController.text = editedEmployee.acquisition;
      });
    } else {
      showToast('Failed to fetch employee data');
    }
  }

  void addOrUpdateEmployee() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with adding/updating employee
      _formKey.currentState!.save();
      // Add your http request logic here
      showToast(isEditing ? 'Record updated' : 'Record added');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Client' : 'Add Client'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: businessnameController,
                  decoration: const InputDecoration(
                    labelText: 'Business Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter business name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.contact_phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    } else if (value.length < 10) {
                      return 'Phone number must have 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: natureController,
                  decoration: const InputDecoration(
                    labelText: 'Nature',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.nature),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter nature of the business';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: acquisitionController,
                  decoration: const InputDecoration(
                    labelText: 'Acquisition',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_atm),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter acquisition';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: addOrUpdateEmployee,
                  child: Text(isEditing ? 'Update' : 'Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
