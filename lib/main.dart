import 'package:flutter/material.dart';
import 'login1.dart';
import 'sign_up.dart';
import 'add_clients1.dart';
import 'add_clients3.dart';
import 'view_clients.dart';
import 'employees.dart';  


void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      title: 'Field Marketing',
      initialRoute: '/',
      routes: {
        '/': (context) => const FormScreen(),
        '/second': (context) => const SignUp(),
        // '/third': (context) => const AddClients(),
        // '/third': (context) => AddedClients(),
        '/fourth': (context) => const ViewClients(),
        '/fifth': (context) => const EmployeesView(),
      },
    ),
  );
}













