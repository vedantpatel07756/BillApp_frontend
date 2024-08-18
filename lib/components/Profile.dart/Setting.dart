
// // import 'package:billapp/components/Auth/login.dart';
// // import 'package:billapp/components/Profile.dart/Employ.dart';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class Setting extends StatefulWidget {
// //   const Setting({super.key});

// //   @override
// //   State<Setting> createState() => _SettingState();
// // }

// // class _SettingState extends State<Setting> {
// //    String name= "User";
// //    String email="";
// //    String BussinessName="Shree Samarth Trading";
// //    String PhoneNo="9284590263";

// //   Future<void> _getUserData() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       name = prefs.getString('user_name') ?? "User";
// //       email = prefs.getString('user_email') ?? " ";
// //       BussinessName=prefs.getString('BussinessName') ?? "Shree Samarth Trading";
// //       PhoneNo=prefs.getString('PhoneNo') ?? "9284590263";
// //     });
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _getUserData();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //    final TextEditingController nameController = TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();
    
// //     print("$email");
// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         scrollDirection: Axis.vertical,
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Container(
// //               width: double.infinity,
// //               decoration: BoxDecoration(color: Colors.white),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.end,
// //                       children: [
// //                        editButton(context, nameController, phoneController),
        
// //                       ],
// //                     ),
// //                   ),
        
// //                   Container(
// //                     width: 100,
// //                     height: 100,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       image: DecorationImage(
// //                         image: AssetImage("assest/app_icon.png"),
// //                         fit: BoxFit.cover,
// //                       ),
// //                     ),
// //                   ),
// //                   SizedBox(height: 20),
// //                   Text(
// //                     "$BussinessName",
// //                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
// //                   ),
// //                   Text(
// //                     "Mobile No: $PhoneNo",
// //                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             (email != "adminSST@gmail.com" && email != "vedantpatel07756@gmail.com")
// //                 ? Container(
// //                     margin: EdgeInsets.only(top: 10),
// //                     width: double.infinity,
// //                     padding: EdgeInsets.all(20),
// //                     color: Colors.white,
// //                     child: Text(
// //                       "Welcome $name, \n \nImportant Notice: Admin Access Required \n\nDear $name, \nPlease be aware that only administrators have the necessary permissions to make changes in this section. If you need any updates or modifications, kindly reach out to our authorized administrators. \nThank you for your understanding. \n\nBest regards, \nShree Samarth Trading",
// //                     ),
// //                   )
// //                 : Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
        
// //                         Container(
// //                           margin: EdgeInsets.only(top:10),
// //                           color: Colors.white,
// //                           width: 500,
// //                           child: Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child: Text("Hello Mr.Admin",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,),),
// //                           ),
// //                         ),
        
        
// //                       Padding(
// //                         padding: const EdgeInsets.all(10.0),
// //                         child: Text(
// //                           "Setting",
// //                           style: TextStyle(
// //                               fontSize: 20,
// //                               fontWeight: FontWeight.w500,
// //                               color: Colors.blue),
// //                         ),
// //                       ),
// //                       Container(
// //                         width: double.infinity,
// //                         decoration: BoxDecoration(color: Colors.white),
// //                         child: Column(
// //                           children: [
                         
// //                             GestureDetector(
// //                               onTap: () {
// //                                 Navigator.of(context).push(MaterialPageRoute(
// //                                     builder: (context) => Employer()));
// //                               },
// //                               child: Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Row(
// //                                   mainAxisAlignment:
// //                                       MainAxisAlignment.spaceBetween,
// //                                   children: [
// //                                     Text(
// //                                       "Manage Employer",
// //                                       style: TextStyle(
// //                                         fontSize: 17,
// //                                         fontWeight: FontWeight.w400,
// //                                       ),
// //                                     ),
// //                                     Icon(Icons.arrow_right_outlined),
// //                                   ],
// //                                 ),
// //                               ),
// //                             )
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
        
        
// //         SizedBox(height: 20,),
// //                   ElevatedButton(onPressed: ()async{
// //                    final prefs = await SharedPreferences.getInstance();
// //                    await prefs.setBool('isLoggedIn',false);
        
// //                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MyLogin()));
        
// //                   }, 
                  
// //                   style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue))
// //                   ,child: Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Text("Logout",style: TextStyle(color: Colors.white),),
// //                   ))
// //           ],
        
        
        
// //         ),
// //       ),


// //     );
// //   }

// //   GestureDetector editButton(BuildContext context, TextEditingController nameController, TextEditingController phoneController) {
// //     return GestureDetector(
// //           onTap: () {
// //             showDialog(
// //               context: context,
// //               builder: (BuildContext context) {
// //                 return AlertDialog(
// //                   backgroundColor: Colors.black45,
// //                   title: Text('Edit Business Info', style: TextStyle(color: Colors.white)),
// //                   content: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       TextField(
// //                         controller: nameController,
// //                         style: TextStyle(color: Colors.white),
// //                         decoration: InputDecoration(
// //                           labelText: 'Business Name',
// //                           labelStyle: TextStyle(color: Colors.white),
// //                           enabledBorder: UnderlineInputBorder(
// //                             borderSide: BorderSide(color: Colors.white),
// //                           ),
// //                         ),
// //                       ),
// //                       TextField(
// //                         controller: phoneController,
// //                         style: TextStyle(color: Colors.white),
// //                         decoration: InputDecoration(
// //                           labelText: 'Phone Number',
// //                           labelStyle: TextStyle(color: Colors.white),
// //                           enabledBorder: UnderlineInputBorder(
// //                             borderSide: BorderSide(color: Colors.white),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   actions: <Widget>[
// //                     TextButton(
// //                       onPressed: () async{
// //                         // Handle the save logic here
// //                         String newName = nameController.text;
// //                         String newPhone = phoneController.text;
      
// //                                          final prefs = await SharedPreferences.getInstance();
// //                                               await prefs.setString('BussinessName', newName)  ;
// //                                               await prefs.setString('PhoneNo', newPhone)  ;
      
                                 
// //                           _getUserData();
      
// //                         // You can update the state or call a function to save these values
      
// //                         Navigator.of(context).pop();
// //                       },
// //                       child: Text('Save', style: TextStyle(color: Colors.white)),
// //                     ),
// //                     TextButton(
// //                       onPressed: () {
// //                         Navigator.of(context).pop();
// //                       },
// //                       child: Text('Cancel', style: TextStyle(color: Colors.white)),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             );
// //           },
// //           child: Icon(Icons.edit_square, color: Colors.blue, size: 30),
// //         );
// //   }
// // }



// import 'package:billapp/components/Auth/login.dart';
// import 'package:billapp/components/Profile.dart/Employ.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Setting extends StatefulWidget {
//   const Setting({super.key});

//   @override
//   State<Setting> createState() => _SettingState();
// }

// class _SettingState extends State<Setting> {
//   String name = "User";
//   String email = "";
//   String BussinessName = "Shree Samarth Trading";
//   String PhoneNo = "9284590263";

//   Future<void> _getUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       name = prefs.getString('user_name') ?? "User";
//       email = prefs.getString('user_email') ?? " ";
//       BussinessName = prefs.getString('BussinessName') ?? "Shree Samarth Trading";
//       PhoneNo = prefs.getString('PhoneNo') ?? "9284590263";
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getUserData();
//   }

//   // void _launchURL(String url) async {
//   //   if (!await launchUrl(url)) {
//   //     throw 'Could not launch $url';
//   //   }
//   // }


// void _launchURL(String url) async {
//   print('Trying to launch URL: $url');
//   final Uri uri = Uri.parse(url);
//   print('Parsed URI: $uri');
//   try {
//     if (!await launchUrl(uri)) {
//       throw 'Could not launch $uri';
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController nameController = TextEditingController();
//     final TextEditingController phoneController = TextEditingController();

//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text("Settings"),
//       // ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(color: Colors.white),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         editButton(context, nameController, phoneController),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: AssetImage("assest/app_icon.png"),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     "$BussinessName",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                   ),
//                   Text(
//                     "Mobile No: $PhoneNo",
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
//                   ),
//                 ],
//               ),
//             ),
//             email != "adminSST@gmail.com" && email != "vedantpatel07756@gmail.com"
//                 ? Container(
//                     margin: EdgeInsets.only(top: 10),
//                     width: double.infinity,
//                     padding: EdgeInsets.all(20),
//                     color: Colors.white,
//                     child: Text(
//                       "Welcome $name, \n \nImportant Notice: Admin Access Required \n\nDear $name, \nPlease be aware that only administrators have the necessary permissions to make changes in this section. If you need any updates or modifications, kindly reach out to our authorized administrators. \nThank you for your understanding. \n\nBest regards, \nShree Samarth Trading",
//                     ),
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
                     
                      
//                       Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(color: Colors.white),
//                         child: Column(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => Employer()));
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
                                    
//                                     Text(
//                                       "Manage Employer",
//                                       style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
//                                     ),
//                                     Icon(Icons.arrow_right_outlined),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Divider(),
//                             ListTile(
//                               title: Text("Privacy Policy"),
//                               trailing: Icon(Icons.arrow_right_outlined),
//                               onTap: () {
//                                 _launchURL("https://www.freeprivacypolicy.com/live/897b22b5-d743-45f3-ae94-590822e004e4");
//                               },
//                             ),
//                             Divider(),
//                             ListTile(
//                               title: Text("Terms and Conditions"),
//                               trailing: Icon(Icons.arrow_right_outlined),
//                               onTap: () {
//                                 _launchURL("https://www.freeprivacypolicy.com/live/a76a306e-76a3-41db-8475-bc4d2fa2df97");
//                               },
//                             ),
//                             Divider(),
//                             ListTile(
//                               title: Text("About Us"),
//                               trailing: Icon(Icons.arrow_right_outlined),
//                               onTap: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       title: Text("About Us"),
//                                       content: Text(
//                                           "Welcome to Shree Samarth Trading's Billing and Invoice Application. Our app provides seamless and efficient billing and invoice management for your business. With user-friendly features and a professional interface, managing your business transactions has never been easier."),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Text("Close"),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final prefs = await SharedPreferences.getInstance();
//                 await prefs.setBool('isLoggedIn', false);

//                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyLogin()));
//               },
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.blue),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Logout",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   GestureDetector editButton(BuildContext context, TextEditingController nameController, TextEditingController phoneController) {
//     return GestureDetector(
//       onTap: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               backgroundColor: Colors.black45,
//               title: Text('Edit Business Info', style: TextStyle(color: Colors.white)),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: nameController,
//                     style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       labelText: 'Business Name',
//                       labelStyle: TextStyle(color: Colors.white),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   TextField(
//                     controller: phoneController,
//                     style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       labelText: 'Phone Number',
//                       labelStyle: TextStyle(color: Colors.white),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () async {
//                     String newName = nameController.text;
//                     String newPhone = phoneController.text;

//                     final prefs = await SharedPreferences.getInstance();
//                     await prefs.setString('BussinessName', newName);
//                     await prefs.setString('PhoneNo', newPhone);

//                     _getUserData();

//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Save', style: TextStyle(color: Colors.white)),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Cancel', style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//       child: Icon(Icons.edit, color: Colors.blue, size: 30),
//     );
//   }
// }


import 'package:billapp/components/Auth/login.dart';
import 'package:billapp/components/Profile.dart/Employ.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String name = "User";
  String email = "";
  String BussinessName = "Shree Samarth Trading";
  String PhoneNo = "9284590263";

  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user_name') ?? "User";
      email = prefs.getString('user_email') ?? " ";
      BussinessName = prefs.getString('BussinessName') ?? "Shree Samarth Trading";
      PhoneNo = prefs.getString('PhoneNo') ?? "9284590263";
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri)) {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        editButton(context, nameController, phoneController),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assest/app_icon.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "$BussinessName",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Mobile No: $PhoneNo",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            email != "adminSST@gmail.com" && email != "vedantpatel07756@gmail.com"
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      "Welcome $name, \n \nImportant Notice: Admin Access Required \n\nDear $name, \nPlease be aware that only administrators have the necessary permissions to make changes in this section. If you need any updates or modifications, kindly reach out to our authorized administrators. \nThank you for your understanding. \n\nBest regards, \nShree Samarth Trading",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello Mr.Admin",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Setting",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Employer()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Manage Employer",
                                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                                    ),
                                    Icon(Icons.arrow_right_outlined),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Privacy Policy"),
                              trailing: Icon(Icons.arrow_right_outlined),
                              onTap: () {
                                _launchURL("https://www.freeprivacypolicy.com/live/897b22b5-d743-45f3-ae94-590822e004e4");
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Terms and Conditions"),
                              trailing: Icon(Icons.arrow_right_outlined),
                              onTap: () {
                                _launchURL("https://www.freeprivacypolicy.com/live/a76a306e-76a3-41db-8475-bc4d2fa2df97");
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text("About Us"),
                              trailing: Icon(Icons.arrow_right_outlined),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("About Us"),
                                      content: Text(
                                          "Welcome to Shree Samarth Trading's Billing and Invoice Application. Our app provides seamless and efficient billing and invoice management for your business. With user-friendly features and a professional interface, managing your business transactions has never been easier."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Close"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);

                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyLogin()));
                },
                
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector editButton(BuildContext context, TextEditingController nameController, TextEditingController phoneController) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black45,
              title: Text('Edit Business Info', style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Business Name',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  TextField(
                    controller: phoneController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    String newName = nameController.text;
                    String newPhone = phoneController.text;

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('BussinessName', newName);
                    await prefs.setString('PhoneNo', newPhone);

                    _getUserData();

                    Navigator.of(context).pop();
                  },
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all()
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.edit,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
