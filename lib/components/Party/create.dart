import 'package:billapp/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
List<String> types = ["Customer", "Supplier"];


// String selected_type="Customer";
bool iscreated=false;

List<String> tasks = ["To Pay", " To Collect"];



 

// Text editing controllers for storing input values
  TextEditingController partyNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController gstNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController balanceController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  String selected_task="To Pay";
  String selected_type="Customer";


// Function to convert the data to JSON
// String convertDataToJson() {
//   Map<String, dynamic> data = {
//     'name': partyNameController.text,
//     'contact_number': contactNumberController.text,
//     'gst_number': gstNumberController.text,
//     'pan_number': panNumberController.text,
//     'type': selected_type,
//     'balance': balanceController.text,
//     'task': selected_task,
//   };

//   return jsonEncode(data);
// }

Future<bool> sendJsonData() async {
  // String baseurl='http://192.168.43.21:5000';
  String baseurl = Config.baseURL;
  Map<String, dynamic> data = {
    'name': partyNameController.text,
    'contact_number': contactNumberController.text,
    'gst_number': gstNumberController.text,
    'pan_number': panNumberController.text,
    'type': selected_type,
    'balance': balanceController.text,
    'task': selected_task,
  };

  String jsonData = jsonEncode(data);

  final response = await http.post(
    
    Uri.parse('$baseurl/create_party'),
    headers: {"Content-Type": "application/json"},
    body: jsonData,
  );

  if (response.statusCode == 200) {
     print('Data sent successfully');
    return true;
   
  } else {
    print('Failed to send data');
    return false;
    
  }
}







  @override
  Widget build(BuildContext context) {
    //  print("New Party is Created");

// Task 
  List<Widget> textWidgets = tasks.map((task) {

  return selectTask(task);
}).toList();

// Task 

    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Create Party"),
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          
          margin: EdgeInsets.all(10),
          child:  Column(
            
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
             Text("Party Name ",style: TextStyle(fontSize: 20)),
        
             TextField(
                  controller: partyNameController,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: Vedant Patel',
            ),
          ),
        
          SizedBox(height: 20),
        
          Text("Contact Number",style: TextStyle(fontSize: 20)),
             TextField(
              controller: contactNumberController,
              keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: 987654310',
        
            ),
          ),
        
           SizedBox(height: 20),
         
          Text("Party Type",style: TextStyle(fontSize: 20)),
        
            select_type(),
        
           SizedBox(height: 20),
        
        
           Text("GST Number",style: TextStyle(fontSize: 20)),
             TextField(
              controller: gstNumberController,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '',
        
            ),
          ),
        
           SizedBox(height: 20),
        
        
           Text("Pan Card Number",style: TextStyle(fontSize: 20)),
             TextField(
              controller: panNumberController,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '',
        
            ),
          ),
        
            SizedBox(height: 20),

            Text("Balance",style: TextStyle(fontSize: 20)),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                    maxWidth: 150.0, // Set the maximum width
                   ),
                    child: TextField(
                      controller: balanceController,
                          decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Ex: 20000',
                            
                    ),
                              ),
                  ),
              
                ...textWidgets,
                  
                 
                ],
              ),
            ),


        SizedBox(height: 20),
        
        submitButton(context),


         SizedBox(height: 20),

        // // (iscreated)? Navigator.of(context).pop() : Text(" InComplete");
        // (iscreated) ? Navigator.of(context).pop() : Text("Incomplete");
        
        
        
        
        
        
        
        
            ],
          ),
        ),
      ),
      );
    
  }

  // Select Task 

  GestureDetector selectTask(String task) {
    return GestureDetector(
  onTap: () {
    setState((){
      selected_task=task;
    });
  },
  child: Container(
    margin: EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(20),
      color: (selected_task==task)?Color.fromARGB(133, 220, 140, 234):Color.fromARGB(201, 223, 222, 222)
    ),
    child: Padding(
      padding: const EdgeInsets.only(top:10,bottom: 10,left: 20,right: 20),
      child: Text(task,style: TextStyle(fontSize: 20,color: (selected_task==task)?Colors.purple:Colors.black),),
    ),
  ),
);
  }


// Submit Button 
  Container submitButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10),
        child: ElevatedButton(
         onPressed: () async {
            bool check = await sendJsonData();  //convert json data
            if (check) {
              setState(() {
                iscreated = true;
              });
              Navigator.of(context).pop(true);
            }
          }, 
          style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 103, 56, 255)),
      
          ),
          child: Padding(
      
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Create",
        style: TextStyle(fontSize: 20,color: Colors.black),
      ),
          ),
        ),
      );
  }


// Select Type 
  Row select_type() {
    return Row(
        children: types.map((type) {
          return GestureDetector(
            onTap: () {
              setState(() {
                 selected_type=type;
              });
             
              print("Type = ${type}");
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color:(selected_type==type)?Colors.purple:Colors.grey),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300],
              ),
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(type,style: TextStyle(fontSize: 20,color: (selected_type==type)?Colors.purple:Colors.black),),
              )
              
              ),
          );
        }).toList(), // Convert Iterable<Text> to List<Text>      
      );
  }
}