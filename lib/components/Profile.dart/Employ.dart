// import 'package:billapp/components/Profile.dart/CreateUser.dart';
// import 'package:flutter/material.dart';

// class Employer extends StatefulWidget {
//   const Employer({super.key});

//   @override
//   State<Employer> createState() => _EmployerState();
// }

// class _EmployerState extends State<Employer> {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         title: Text("Manage User"),
//       ),
//       body: Column(
//         children: [
//             Center(
//               child: ElevatedButton(onPressed: (){
//                 // code 

//                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>User()));

//               },
//               style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
//               child: Text("Create User",style: TextStyle(color: Colors.white),)),
//             ),


//             SizedBox(height: 10,),


//             Users(1,"Vedant Patel","Male","9324195020","vedantpatel07756@gmail.com","1234"),
//              Users(2,"Vedant Patel","Female","9324195020","vedantpatel07756@gmail.com","1234")
//         ],
//       ),
//     );
//   }

//   Container Users(int id,String name,String gender,String Phone,String Email,String Password) {
//     return Container(
//             margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
//             padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10)

//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
                
//                 Row(
//                   children: [
//                     Icon((gender.toUpperCase()=="MALE")?Icons.boy:Icons.girl,color: Colors.blue,size: 25,),
//                     SizedBox(width: 10,),
//                     Text("$name",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)
//                   ],
//                 ),

//                  Row(
//                   children: [
//                     Icon(Icons.email,color: Colors.blue,),
//                      SizedBox(width: 10,),
//                     Text("$Email",),
//                   ],
//                                    ),
//                  Row(
//                   children: [
//                     Icon(Icons.phone,color: Colors.blue,),
//                      SizedBox(width: 10,),
//                     Text("$Phone",),
//                   ],
//                                    ),

//                                     Row(
//                   children: [
//                     Icon(Icons.lock,color: Colors.blue,),
//                      SizedBox(width: 10,),
//                     Text("$Password"),
//                   ],
//                                    ),

//                   GestureDetector(
//                     onTap: () {
                      
//                       // code 
//                     },
//                     child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Icon(Icons.delete,color: Colors.red,)
//                     ],
//                                     ),
//                   ),
//               ],
//             ),
//           );
//   }
// }

import 'dart:convert';
import 'package:billapp/components/Auth/profile.dart';
import 'package:billapp/components/Auth/register.dart';
import 'package:billapp/components/Profile.dart/CreateUser.dart';
import 'package:billapp/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String name;
  final String gender;
  final String phone;
  final String email;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      phone: json['phone_number'],
      email: json['email'],
      password: json['password'],
    );
  }
}

class Employer extends StatefulWidget {
  const Employer({super.key});

  @override
  State<Employer> createState() => _EmployerState();
}

class _EmployerState extends State<Employer> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
      String baseUrl=Config.baseURL;
    final response = await http.get(Uri.parse('$baseUrl/employe/users'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map<User>((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> deleteUser(int id) async {
      String baseUrl=Config.baseURL;
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      setState(() {
        futureUsers = fetchUsers();
      });
    } else {
      throw Exception('Failed to delete user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage User"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyRegister())).then((value){
                  if(value){
                    setState(() {
                        futureUsers = fetchUsers();
                    });
                   
                  }
                });
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
              child: Text("Create User", style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder<List<User>>(
            future: futureUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No users found'));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      User user = snapshot.data![index];
                      return Users(user.id, user.name, user.gender, user.phone, user.email, user.password);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget Users(int id, String name, String gender, String phone, String email, String password) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfilePage(
                            
                            id:id,
                            name:name,
                            gender:gender,
                            phone:phone,
                            email:email,
                            password:password
        )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Icon((gender.toUpperCase() == "MALE") ? Icons.boy : Icons.girl, color: Colors.blue, size: 25),
                SizedBox(width: 10),
                Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ],
            ),
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 10),
                Text(email),
              ],
            ),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue),
                SizedBox(width: 10),
                Text(phone),
              ],
            ),
            Row(
              children: [
                Icon(Icons.lock, color: Colors.blue),
                SizedBox(width: 10),
                Text(password),
              ],
            ),
            GestureDetector(
              onTap: () {
                // code to delete user
                deleteUser(id);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete, color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

