import 'package:billapp/config.dart';
import 'package:billapp/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  

  bool _validateEmail(String value) {
    // Check if email contains @gmail.com
    if (!value.contains('@gmail.com')) {
      return false;
    }
    return true;
  }

  // bool _validatePassword(String value) {
  //   // Password must contain at least one uppercase letter, one special symbol, and one digit
  //   String pattern = r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#$&*]).{8,}$';
  //   RegExp regex = RegExp(pattern);
  //   return regex.hasMatch(value);
  // }

Future<bool> loginUser(String email, String password) async {
  String baseURL="https://sstbillapp.vercel.app";
  final url = Uri.parse('$baseURL/login'); // Replace with your actual API URL
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    // Parse the user data from the response if needed
    final userData = jsonDecode(response.body);
    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(Duration(days: 1));

    String formattedCurrentDate = "${now.year}-${now.month}-${now.day}";
    String formattedTomorrowDate = "${tomorrow.year}-${tomorrow.month}-${tomorrow.day}";
    
    // Perform any additional actions with userData if needed
     final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userData['id']);
    await prefs.setString('user_name', userData['name']);
    await prefs.setString('user_gender', userData['gender']);
    await prefs.setString('user_phone_number', userData['phone_number']);
    await prefs.setString('user_email', userData['email']);
    await prefs.setString('currentDate', formattedCurrentDate);
    await prefs.setString('tomorrowDate', formattedTomorrowDate);

    if(userData['email']=="vedantpatel07756@gmail.com" || userData['email']=="adminSST@gmail.com"){
      await prefs.setBool('admin', true);
    }else{
      await prefs.setBool('admin', false);
    }

    await prefs.setBool('isLoggedIn', true);
    return true; // Login successful
    
    // return true; // Login successful
  } else {
    return false; // Login failed
  }
}


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assest/login.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Welcome\nBack !!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 33,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                  right: 35,
                  left: 35,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign in',
                          style: TextStyle(
                            color: Color(0xff4c505b),
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xff4c505b),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () async{
                              String email = _emailController.text.trim();
                              String password = _passwordController.text.trim();

                              if (!_validateEmail(email)) {
                                // Show alert for invalid email format
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Oops!'),
                                      content: Text(
                                          'Email should be of format example@gmail.com.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }else{ 

                                  bool check = await loginUser(email,password);
                                  if(check){
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Home()));
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Login Detail")));
                                  }
                                  
                              
                                
                              }

                              // if (!_validatePassword(password)) {
                              //   // Show alert for invalid password format
                              //   showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return AlertDialog(
                              //         title: Text('Oops!'),
                              //         content: Text(
                              //             'Password should contain at least 8 characters with at least one uppercase letter, one digit, and one special symbol.'),
                              //         actions: [
                              //           TextButton(
                              //             onPressed: () {
                              //               Navigator.of(context).pop();
                              //             },
                              //             child: Text('OK'),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   );
                              //   return;
                              // }else{
                                
                              //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Home()));
                              // }

                              // If validations pass, proceed with login logic
                              // Implement your login logic here
                            },
                            icon: Icon(Icons.arrow_forward),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     TextButton(
                    //       onPressed: () {
                    //         Navigator.pushNamed(context, 'register');
                    //       },
                    //       child: Text(
                    //         'Sign Up',
                    //         style: TextStyle(
                    //           decoration: TextDecoration.underline,
                    //           fontSize: 18,
                    //           color: Color(0xff4c505b),
                    //         ),
                    //       ),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {
                    //         Navigator.pushNamed(context, 'setting');
                    //       },
                    //       child: Text(
                    //         'Forgot Password',
                    //         style: TextStyle(
                    //           decoration: TextDecoration.underline,
                    //           fontSize: 18,
                    //           color: Color(0xff4c505b),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
