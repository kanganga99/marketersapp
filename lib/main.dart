import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pesafy_marketer/rootapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pesafy_marketer/login1.dart';
import 'package:pesafy_marketer/sign_up.dart';
// import './views/home/view_clients.dart';

SharedPreferences? globalPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globalPrefs = await SharedPreferences.getInstance();
  // await Future.delayed(Duration(seconds: 3));
  // FlutterNativeSplash.remove();
  runApp(MarketersApp());
}

class MarketersApp extends StatelessWidget {
  const MarketersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      title: 'Affiliate',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            bool newuser = (globalPrefs!.getBool('login') ?? true);
            print(globalPrefs!.getBool('login'));
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
