


// Try 

import 'package:billapp/components/Auth/login.dart';
import 'package:billapp/components/Dashboard/dashboard.dart';
import 'package:billapp/components/Items/items.dart';
import 'package:billapp/components/Party/parties.dart';
import 'package:billapp/components/Profile.dart/Setting.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'config.dart';
// import 'package:pusher_client/pusher_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.white),
        scaffoldBackgroundColor: Color(0xfff7f7fe),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}



// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool login = false;

  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // Set Bussiness Detail 
      await prefs.setString('BussinessName', 'Shree Samarth Trading');
      await prefs.setString('PhoneNo', '9284590263');

    // Set Bussiness Detail 
    bool admin=prefs.getBool('admin')?? false;
    print("ADMIN => $admin");
    DateTime now = DateTime.now();


    String currentdate = "${now.year}-${now.month}-${now.day}";
    String tomorrowdate= prefs.getString('tomorrowDate') ?? " ";

print("currentdate = > $currentdate");
print("tommorow = > $tomorrowdate");
    setState(() {
      
    // login=true;
      if(admin==false){
            if(currentdate==tomorrowdate){
              login = false;
            }else{
            login = prefs.getBool('isLoggedIn') ?? false;
            print("login $login");
            }
      }else{
           login = prefs.getBool('isLoggedIn') ?? false;
            print("login $login");
      }     
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => (login == true) ? Home() : MyLogin()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assest/app_icon.png',
                width: 200,
                height: 200,
              ),
            ),
            Center(
              child: Text(
                "Shree Samarth Trading",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 25),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Home Screen
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int myIndex = 0;
  String name = "Shree Samarth Trading";
  late IO.Socket socket;

  List<Widget> myWidget = [
    Dashboard(),
    Parties(),
    Items(),
    Setting(),
  ];

  void change(String a) {
    name = a;
  }

  @override
  void initState() {
    super.initState();
   
  }

// void initializeWebSocket() {
//   String baseURL = Config.baseURL;
//   socket = IO.io('$baseURL', <String, dynamic>{
//     'transports': ['websocket'],
//     'autoConnect': true,
//   });

//   socket.on('connect', (_) {
//     print(' Web socketed connected');
//   });

//    socket.on('check', (_) {
//     print(' checking connected');
//   });



//   socket.on('account_deleted', (data) async {
//     // Handle the event data directly; no need for JSON parsing here
//     print('Received account_deleted event: $data'); // Add logging for debugging
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int currentUserId = prefs.getInt('user_id') ?? 0;
//   print("Socket => $currentUserId");
//     if (data['user_id'] == currentUserId) {
//       print("Socket => clear");
//       await prefs.clear();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MyLogin()),
//       );
//     }
//   });

//   socket.on('disconnect', (_) => print('disconnected'));

//   // Handle socket errors
//   socket.on('error', (err) => print('Error: $err'));
//   socket.on('connect_error', (err) => print('Connection error: $err'));
// }

  // @override
  // void dispose() {
  //   socket.dispose();
  //   super.dispose();
  // }

  
//   late PusherClient pusher;
//   late Channel channel;


//  Future<void> initializePusher() async {
//     PusherOptions options = PusherOptions(
//       cluster: Config.pusherCluster,
//       encrypted: true,
//     );

//     pusher = PusherClient(
//       Config.pusherAppKey,
//       options,
//       autoConnect: true,
//       enableLogging: true,
//     );

//     channel = pusher.subscribe('my-channel');

//     pusher.onConnectionStateChange((state) {
//       print("Previous State: ${state?.previousState}, Current State: ${state?.currentState}");
//     });

//     pusher.onConnectionError((error) {
//       print("Error: ${error?.message}");
//     });

//     // Adjusted the type of the function to match the expected signature
//     channel.bind('account_deleted', (PusherEvent? event) async {
//       if (event?.data != null) {
//         final data = event!.data;  // event.data is a JSON string
//         final Map<String, dynamic> parsedData;

//         try {
//           parsedData = jsonDecode(data??"0");
//         } catch (e) {
//           print("Failed to decode event data: $e");
//           return;
//         }

//         print('Received account_deleted event: $parsedData'); // Add logging for debugging

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         int currentUserId = prefs.getInt('user_id') ?? 0;
//         print("Pusher => $currentUserId");

//         if (parsedData['user_id'] == currentUserId) {
//           print("Pusher => clear");
//           await prefs.clear();
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => MyLogin()),
//           );
//         }
//       } else {
//         print('Event data is null');
//       }
//     });

//     pusher.connect();
//   }

  @override
  void dispose() {
    // pusher.disconnect();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //  initializeWebSocket();
    // initializePusher();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: myWidget[myIndex],
      ),
      bottomNavigationBar: navigationBar(),
    );
  }

  BottomNavigationBar navigationBar() {
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          myIndex = index;

          if (myIndex == 0) {
            change("Shree Samarth Trading");
          } else if (myIndex == 1) {
            change("Parties");
          } else if (myIndex == 2) {
            change("Items");
          } else if (myIndex == 3) {
            change("Profile");
          }
        });
      },
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: myIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: "Parties",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gif_box),
          label: "Items",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}












// // git init
// // git add README.md
// // git commit -m "first commit"
// // git branch -M main
// // git remote add origin https://github.com/vedantpatel07756/BillApp_frontend.git
// // git push -u origin main