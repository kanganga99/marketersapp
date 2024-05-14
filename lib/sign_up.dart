import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool passToggle = true;
  bool confirmPassToggle = true;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  // Future<bool> checkEmailExists(String email) async {
  //   final response = await http.get(
  //     Uri.parse(
  //         'https://api.pesafy.africa/marketers/check_email.php?email=$email'),
  //   );
  //   if (response.statusCode == 200) {
  //     final String result = response.body;
  //     return result.toLowerCase() == 'true'; // Return true if email exists
  //   } else {
  //     throw Exception('Failed to check email');
  //   }
  // }

  Future<http.Response> registerUser(
    String username,
    String phone,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('https://api.pesafy.africa/marketers/sign_up1.php'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: 'username=$username&phone=$phone&email=$email&password=$password',
    );
    return response;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesafy Affiliate'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/login.jpeg',
                  height: 100,
                  width: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter username";
                      } else if (value.length < 3) {
                        return "Username must have 8 or more characters";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      } else if (value.length < 10) {
                        return "Phonenumber must have 10 characters";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      } else if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: passController,
                    obscureText: passToggle,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passToggle = !passToggle;
                          });
                        },
                        child: Icon(
                          passToggle ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else if (value.length < 8) {
                        return 'Password must have 8 or more characters';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: confirmPassToggle,
                    controller: confirmPassController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            confirmPassToggle = !confirmPassToggle;
                          });
                        },
                        child: Icon(
                          confirmPassToggle
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != passController.text) {
                        return 'Password mismatch';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final username = nameController.text;
                        final phone = phoneController.text;
                        final email = emailController.text;
                        final password = passController.text;

                        // Check if email already exists
                        // final emailExists = await checkEmailExists(email);
                        // print('Email Exists: $emailExists');

                        // if (emailExists) {
                        //   showDialog(
                        //     context: context,
                        //     builder: (context) => AlertDialog(
                        //       title: const Text('Email Already Exists'),
                        //       content: Text(
                        //           'The email $email is already registered.'),
                        //       actions: [
                        //         TextButton(
                        //           onPressed: () {
                        //             Navigator.of(context).pop();
                        //           },
                        //           child: const Text('OK'),
                        //         ),
                        //       ],
                        //     ),
                        //   );
                        // } else {
                        // Register the user only if email doesn't exist
                        final response = await registerUser(
                          username,
                          phone,
                          email,
                          password,
                        );

                        if (response.statusCode == 200) {
                          showToast('Registered successfully');
                          print('Form submitted successfully');
                          Navigator.pushNamed(context, "/");
                        } else {
                          throw Exception('Failed to submit form');
                        }
                        // Clear the form fields
                        nameController.clear();
                        phoneController.clear();
                        emailController.clear();
                        passController.clear();
                        confirmPassController.clear();
                        // }
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already a Member?',
                      style: TextStyle(fontSize: 17),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/");
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
