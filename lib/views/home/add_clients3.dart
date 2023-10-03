import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pesafy_marketer/main.dart';
import 'package:pesafy_marketer/rootapp.dart';

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

Employee? editingEmployee;

class AddedClients extends StatefulWidget {
  final bool isEditing;
  final int id;
  final int uid;

  const AddedClients({
    Key? key,
    required this.isEditing,
    required this.id,
    required this.uid,
  }) : super(key: key);

  @override
  _AddedClientsState createState() => _AddedClientsState();
}

class _AddedClientsState extends State<AddedClients> {
  TextEditingController businessnameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController natureController = TextEditingController();
  // TextEditingController uidController = TextEditingController();

  List<String> acquisitionOptions = [
    'First Time',
    'Interested',
    'On Boarded',
  ];
  String selectedAcquisition = "First Time";

  final _formKey = GlobalKey<FormState>();
  bool isEditing = false; // Track if editing mode is active
  late Employee editedEmployee; // Track the edited employee object

  @override
  void initState() {
    super.initState();
    // Check if editing mode is enabled
    if (widget.isEditing) {
      isEditing = true;
      editedEmployee = Employee(
        id: widget.id, // Assign the id from the widget parameter
        businessName: '',
        contact: '',
        location: '',
        nature: '',
        acquisition: '',
      );
      fetchEmployeeData(); // Fetch the employee data for editing
    }
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

  void fetchEmployeeData() async {
    var url = Uri.parse('https://api.pesafy.africa/marketers/get_clients.php');
    final response = await http.post(url, body: {
      'id': editedEmployee.id.toString(),
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        editedEmployee = Employee(
          id: editedEmployee.id,
          businessName: data['business_name'] ?? '',
          contact: data['contact'] ?? '',
          location: data['location'] ?? '',
          nature: data['nature'] ?? '',
          acquisition: data['acquisition'] ?? selectedAcquisition,
        );
        businessnameController.text = editedEmployee.businessName;
        contactController.text = editedEmployee.contact;
        locationController.text = editedEmployee.location;
        natureController.text = editedEmployee.nature;
        if (editedEmployee.acquisition.isNotEmpty) {
          selectedAcquisition = editedEmployee.acquisition;
        }
      });
    } else {
      showToast('Failed to fetch clients data');
    }
  }

  void addOrUpdateEmployee() async {
    var url;
    int? uid = globalPrefs!.getInt('id');
    print('UID from SharedPreferences: $uid');

    if (isEditing) {
      url = Uri.parse('https://api.pesafy.africa/marketers/update_clients.php');
    } else {
      url = Uri.parse('https://api.pesafy.africa/marketers/added_clients.php');
    }

    final response = await http.post(url, body: {
      'id': isEditing ? editedEmployee.id.toString() : '',
      'business_name': businessnameController.text,
      'contact': contactController.text,
      'location': locationController.text,
      'nature': natureController.text,
      'acquisition': selectedAcquisition,
      'uid': uid.toString(),
    });

    if (response.statusCode == 200) {
      showToast(isEditing ? 'Record updated' : 'Record added');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Root(),
        ),
      );
    } else {
      showToast(isEditing ? 'Failed to update record' : 'Failed to add record');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(isEditing ? 'Edit Client' : 'Add Client'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
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
                    }),
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
                      return "Please enter nature of the business";
                    }
                    return null;
                  },
                ),
                //  TextFormField(
                //   keyboardType: TextInputType.text,
                //   controller: uidController,
                //   decoration: const InputDecoration(
                //     labelText: 'UID',
                //     border: OutlineInputBorder(),
                //     prefixIcon: Icon(Icons.nature),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter nature of the business";
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedAcquisition,
                  items: acquisitionOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Acquisition',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_atm),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedAcquisition = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select acquisition';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addOrUpdateEmployee();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: Text(isEditing ? 'Update' : 'Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
