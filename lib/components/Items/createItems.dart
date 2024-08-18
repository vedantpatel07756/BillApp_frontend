// import 'package:billapp/config.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class CreateItems extends StatefulWidget {
//   const CreateItems({super.key});

//   @override
//   State<CreateItems> createState() => _CreateItemsState();
// }




// class _CreateItemsState extends State<CreateItems> {

//   // Text editing controllers for storing input values
//   TextEditingController itemNameController = TextEditingController();
//   TextEditingController quantityController = TextEditingController();
//   TextEditingController salesController = TextEditingController();
//   TextEditingController purchaseController = TextEditingController();

// Future<bool> sendJsonData() async {
//   Map<String, dynamic> data = {
//     'name': itemNameController.text,
//     'quantity': quantityController.text,
//     'sales_price': salesController.text,
//     'purchase_price': purchaseController.text,
    
//   };

//   String jsonData = jsonEncode(data);
// // String baseurl='http://192.168.43.21:5000';
//    String baseurl = Config.baseURL;
//   final response = await http.post(
//     Uri.parse('$baseurl/items/add_item'),
//     headers: {"Content-Type": "application/json"},
//     body: jsonData,
//   );

//   if (response.statusCode == 200) {
//      print('Item Data sent successfully');
//     return true;
   
//   } else {
//     print('Failed to send data add_item');
//     return false;
    
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Items"),
//         backgroundColor: Colors.white,

//       ),

//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Container(
//           padding: EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(" Item Name", style: TextStyle(fontSize: 20),),
//               TextField(
//                 controller: itemNameController,
//                 decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               hintText: 'Ex: Kisan Fruit Jam  500gm',
                                
//                         ),
//                  ),
        
//               SizedBox(height: 20,),
        
//               Text(" Quantity", style: TextStyle(fontSize: 20),),
//               TextField(
//                 controller: quantityController,
//                 keyboardType: TextInputType.numberWithOptions(),
//                 decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               hintText: 'Ex: 20000',
                                
//                         ),
//                  ),
        
//                    SizedBox(height: 20,),
        
//               Text(" Sales Price", style: TextStyle(fontSize: 20),),
//               TextField(
//                 controller: salesController,
//                 keyboardType: TextInputType.numberWithOptions(),
//                 decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               hintText: 'Ex: 20 (IN ₹)',
                                
//                         ),
//                  ),
        
//                    SizedBox(height: 20,),
        
//               Text(" Purchase Price", style: TextStyle(fontSize: 20),),
//               TextField(
//                 controller: purchaseController,
//                 keyboardType: TextInputType.numberWithOptions(),
//                 decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               hintText: 'Ex: 100 (IN ₹)',
                                
//                         ),
//                  ),
        
//                   SizedBox(height: 20,),
        
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                     ),
//                     onPressed: ()async{
//                         // Item Data Send on Tap 
//                        bool check = await  sendJsonData();

//                           if(check){
//                             Navigator.of(context).pop(true);
//                           }


//                   }, child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("Add" ,style: TextStyle(color: Colors.white,fontSize: 20),),
//                   ))
        
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:billapp/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateItems extends StatefulWidget {
  const CreateItems({Key? key}) : super(key: key);

  @override
  State<CreateItems> createState() => _CreateItemsState();
}

class _CreateItemsState extends State<CreateItems> {
  // Text editing controllers for storing input values
  TextEditingController itemNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController salesController = TextEditingController();
  TextEditingController purchaseController = TextEditingController();

  // Unit options
  List<String> unitOptions = [
    'KG',
    'BAG',
    'LADI',
    'PETI',
    'JARS',
    'HANGER',
    'POUCH',
    'BORA',
    'COIL',
    'FEET',
    'INCHES',
    // Add more options as needed
  ];

  // Selected unit
  String selectedUnit = 'LADI'; // Default to LADI

  Future<bool> sendJsonData() async {
    Map<String, dynamic> data = {
      'name': itemNameController.text,
      'quantity': quantityController.text,
      'sales_price': salesController.text,
      'purchase_price': purchaseController.text,
      'unit': selectedUnit,
    };

    String jsonData = jsonEncode(data);
    String baseURL = Config.baseURL;
    final response = await http.post(
      Uri.parse('$baseURL/items/add_item'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('Item Data sent successfully');
      return true;
    } else {
      print('Failed to send data add_item');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Items"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Item Name",
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: Kisan Fruit Jam 500gm',
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Quantity",
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: 20000',
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Sales Price",
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                controller: salesController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: 20 (IN ₹)',
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Purchase Price",
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                controller: purchaseController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: 100 (IN ₹)',
                ),
              ),
              SizedBox(height: 20),
              // Unit selection dropdown
              Text(
                "Unit",
                style: TextStyle(fontSize: 20),
              ),
                  Container(
                    padding: EdgeInsets.all(2),
                        width: double.infinity, // Adjust width as needed
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                        child: DropdownButton<String>(
                          value: selectedUnit,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedUnit = newValue!;
                            });
                          },
                          items: unitOptions.map((String unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                        ),
                      ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  bool check = await sendJsonData();
                  if (check) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Add",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
