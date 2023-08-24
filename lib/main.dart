import 'package:flutter/material.dart';
import 'package:pesafy_marketer/rootapp.dart';
import 'login1.dart';
import 'sign_up.dart';
import './views/home/view_clients.dart';
import 'views/profile/profile.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      title: 'Pesafy Affiliates',
      initialRoute: '/',
      routes: {
        '/': (context) => const FormScreen(),
        '/register': (context) => const SignUp(),
        // '/third': (context) => const AddClients(),
        // '/third': (context) => AddedClients(),
        '/root': (context) => const Root(),
        '/profile': (context) => ProfileScreen(),
      },
    ),
  );
}
