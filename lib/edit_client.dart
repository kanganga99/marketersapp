import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditClient extends StatefulWidget {
  final String clientId;

  const EditClient({required this.clientId});

  @override
  _EditClientState createState() => _EditClientState();
}

class _EditClientState extends State<EditClient> {
  final _formKey = GlobalKey<FormState>();
  final businessNameController = TextEditingController();
  final contactController = TextEditingController();
  final locationController = TextEditingController();
  final natureController = TextEditingController();
  final acquisitionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchClientDetails();
  }

  Future<void> fetchClientDetails() async {
    try {
      // Make an HTTP request to fetch client details with the specific ID
      final response = await http.get(Uri.parse(
          'http://localhost/pesafy_marketers/view_clients.php?id=${widget.clientId}'));

      if (response.statusCode == 200) {
        // Parse the response body as needed
        final data = jsonDecode(response.body);

        // Update the text editing controllers with the retrieved data
        businessNameController.text = data['business_name'];
        contactController.text = data['contact'];
        locationController.text = data['location'];
        natureController.text = data['nature'];
        acquisitionController.text = data['acquisition'];
      } else {
        throw Exception('Failed to fetch client details');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> updateClient() async {
    try {
      // Retrieve the updated values from the text editing controllers
      final businessName = businessNameController.text;
      final contact = contactController.text;
      final location = locationController.text;
      final nature = natureController.text;
      final acquisition = acquisitionController.text;

      // Make an HTTP request to update the client data
      final response = await http.post(
        Uri.parse('http://localhost/pesafy_marketers/update_client.php'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body:
            'id=${widget.clientId}&business_name=$businessName&contact=$contact&location=$location&nature=$nature&acquisition=$acquisition',
      );

      if (response.statusCode == 200) {
        // Handle the success response as needed
        print('Client updated successfully');
        // You can also show a success message using FlutterToast or a SnackBar
      } else {
        throw Exception('Failed to update client');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void dispose() {
    // Dispose the text editing controllers when the widget is disposed
    businessNameController.dispose();
    contactController.dispose();
    locationController.dispose();
    natureController.dispose();
    acquisitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Client'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: businessNameController,
                  decoration: const InputDecoration(
                    labelText: 'Business Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a business name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a contact';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: natureController,
                  decoration: const InputDecoration(
                    labelText: 'Nature',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a nature';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: acquisitionController,
                  decoration: const InputDecoration(
                    labelText: 'Acquisition',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an acquisition';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateClient();
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
