import 'package:flutter/material.dart';
import 'login1.dart';
import 'sign_up.dart';
import 'view_clients.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      title: 'Pesafy Affiliates',
      initialRoute: '/',
      routes: {
        '/': (context) => const FormScreen(),
        '/register': (context) => const SignUp(),
        // '/third': (context) => const AddClients(),
        // '/third': (context) => AddedClients(),
        '/clients': (context) => const ViewClients(),
      },
    ),
  );
}
