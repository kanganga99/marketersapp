import 'package:flutter/material.dart';
import 'package:pesafy_marketer/main.dart';
import 'views/home/add_clients3.dart';
import './views/home/view_clients.dart';

class Search extends StatefulWidget {
  final List<Employee2> employees; // Pass the list of all employees

  const Search({
    Key? key,
    required this.employees,
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isLoading = true;
  List<Employee2> filteredEmployees = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    filteredEmployees = widget.employees;
    super.initState();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      filteredEmployees = widget.employees;
    });
  }

  void _search(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredEmployees = widget.employees;
      });
      return;
    }

    List<Employee2> searchResults = [];
    for (var employee in widget.employees) {
      if (employee.businessName.toLowerCase().contains(query.toLowerCase())) {
        searchResults.add(employee);
      }
    }
    setState(() {
      filteredEmployees = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(35.0, 35.0, 35.0, 0),
            child: TextField(
              controller: _searchController, // Set the controller
              onChanged: _search,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(width: 0.8),
                ),
                hintText: 'Business Name',
                prefixIcon: const Icon(
                  Icons.search,
                  size: 25.0,
                ),
                suffixIcon: IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              // padding: const EdgeInsets.symmetric(horizontal: 35.0),
              itemCount: filteredEmployees.length,
              itemBuilder: (context, index) {
                final employee = filteredEmployees[index];
                final heroTag =
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
                                  uid: globalPrefs!.getInt('id') ?? 0,
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
        ],
      ),
    );
  }
}
