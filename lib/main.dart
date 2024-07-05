import 'package:billapp/components/Dashboard/dashboard.dart';
import 'package:billapp/components/Items/items.dart';
import 'package:billapp/components/Party/parties.dart';
import 'package:billapp/components/Profile.dart/Setting.dart';
import 'package:flutter/material.dart';
import 'config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        appBarTheme: AppBarTheme(color: Colors.white),
        scaffoldBackgroundColor: Color(0xfff7f7fe),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int myIndex=0;

  String name="Shree Samarth Trading";
  List<Widget> myWidget= [
    Dashboard(),
    Parties(),
    Items(),
    Setting(),
  ];
  

  void change(String a){
    name=a;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

  appBar: AppBar(
    backgroundColor: Colors.white,
    title: Text(name,style: TextStyle(fontWeight: FontWeight.w600),),
  ),


  body: Center(child: myWidget[myIndex],),


  bottomNavigationBar: navigationBar(),
);
  }





// Bottom Navigation Bar 
  BottomNavigationBar navigationBar() {
    return BottomNavigationBar(
  
  // iconSize: 0.1,
  onTap: (index) {
    setState(() {
        myIndex=index;

        if(myIndex==0){
            change("Shree Samarth Trading");
        }else if(myIndex==1){
             change("Parties");
        }else if(myIndex==2){
          change("Items");
        }else if(myIndex==3){
          change("Profile");
        }
       
    });
  
  },
  backgroundColor: Colors.white,
  type: BottomNavigationBarType.fixed,
  currentIndex:myIndex,
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

// git init
// git add README.md
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/vedantpatel07756/BillApp_frontend.git
// git push -u origin main