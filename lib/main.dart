import 'package:flutter/material.dart';
import 'package:pesafy_marketer/rootapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login1.dart';
import 'sign_up.dart';
// import './views/home/view_clients.dart';

SharedPreferences? globalPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globalPrefs = await SharedPreferences.getInstance();
  runApp(MarketersApp());
}

class MarketersApp extends StatelessWidget {
  const MarketersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      title: 'Pesafy Affiliates',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            bool newuser = (globalPrefs!.getBool('login') ?? true);
            return MaterialPageRoute(builder: (_) {
              if (newuser) {
                return FormScreen();
              } else {
                return Root();
              }
            });
          case '/register':
            return MaterialPageRoute(builder: (_) {
              return SignUp();
            });
          default:
            return MaterialPageRoute(builder: (_) {
              return Root();
            });
        }
      },
    );
  }
}
