// import 'package:billapp/config.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; 
// import 'dart:convert';

// class UpdateItemData extends StatefulWidget {
//   final int id;
//   final String name,sales_price,purchase_price,unit;
//   const UpdateItemData({super.key,
//                           required this.id,
//                           required this.name,
//                           required this.sales_price,
//                           required this.purchase_price,
//                           required this.unit,
  
//   });

//   @override
//   State<UpdateItemData> createState() => _UpdateItemDataState();
// }

// class _UpdateItemDataState extends State<UpdateItemData> {



// late TextEditingController _nameController ;
// late TextEditingController _SalesPriceController ;
// late TextEditingController _PurchasePriceController ;

//  // Unit options
//   List<String> unitOptions = [
//     'KG',
//     'BAG',
//     'LADI',
//     'PETI',
//     'JARS',
//     'HANGER',
//     'POUCH',
//     'BORA',
//     'COIL',
//     'FEET',
//     'INCHES',
//     // Add more options as needed
//   ];

//      // Selected unit
// // Default to LADI

//  @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     _nameController=TextEditingController(text: "${widget.name}");
//     _SalesPriceController=TextEditingController(text: "${widget.sales_price}");
//     _PurchasePriceController=TextEditingController(text: "${widget.purchase_price}");
    
//   }


 
//   @override
//   Widget build(BuildContext context) {

//     String selectedUnit = widget.unit; 



//   Future<bool> updateData() async {
//   // String baseurl='http://192.168.43.21:5000';
//   String baseurl = Config.baseURL;
//     final url = Uri.parse('$baseurl/items/updateitem/${widget.id}'); // Replace with your actual API endpoint

//     final data = {
//       'name': _nameController.text,
//       'sales_price': _SalesPriceController.text,
//       'purchase_price': _PurchasePriceController.text,
//       'unit':selectedUnit,
//     };

//     final response = await http.put(url, body: jsonEncode(data), headers: {
//       'Content-Type': 'application/json',
//     });

//     if (response.statusCode == 200) {
//       // Handle successful update (e.g., show a snackbar)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Item updated successfully!')),
//       );
//       return true;
//       // Consider navigating back or closing the screen
//     } else {
//       // Handle errors (e.g., show a snackbar)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating item')),
//       );

//       return false;
//     }
//   }



//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Update Item Data"),
//         backgroundColor: Colors.white,
//       ),

//       body: Container(
//         margin: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Name",style: TextStyle(fontSize: 20),),
//             SizedBox(height: 5,),
//             TextField(
//                 controller: _nameController,
//                 decoration:InputDecoration(
//                   border: OutlineInputBorder(),
                  
//                 ),
//             ),

//             Text("Sales Price",style: TextStyle(fontSize: 20),),
//             SizedBox(height: 5,),
//             TextField(
//                 controller: _SalesPriceController,
//                 decoration:InputDecoration(
//                   border: OutlineInputBorder(),
                  
//                 ),
//             ),

//             Text("Purchase Price",style: TextStyle(fontSize: 20),),
//             SizedBox(height: 5,),
//             TextField(
//                 controller: _PurchasePriceController,
//                 decoration:InputDecoration(
//                   border: OutlineInputBorder(),
                  
//                 ),
//             ),
//             // Dropdown 
//              // Unit selection dropdown
//               Text(
//                 "Unit",
//                 style: TextStyle(fontSize: 20),
//               ),
//                   Container(
//                     padding: EdgeInsets.all(2),
//                         width: double.infinity, // Adjust width as needed
//                         decoration: BoxDecoration(
//                           border: Border.all()
//                         ),
//                         child: DropdownButton<String>(
//                           value: selectedUnit,
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               selectedUnit = newValue!;
//                             });
//                           },
//                           items: unitOptions.map((String unit) {
//                             return DropdownMenuItem<String>(
//                               value: unit,
//                               child: Text(unit),
//                             );
//                           }).toList(),
//                         ),
//                       ),


//              SizedBox(height: 10,),

//              ElevatedButton(
//               onPressed: ()async{
//               // fetch api 
//               bool check = await updateData();
//               if(check){
//                 Navigator.of(context).pop(true);
//               }

//              }, child: Text("Edit Data",style: TextStyle(fontSize: 20,color: Colors.white),),
//              style: ButtonStyle(backgroundColor:WidgetStatePropertyAll(Colors.purple)),
//              )

//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:billapp/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateItemData extends StatefulWidget {
  final int id;
  final String name, sales_price, purchase_price, unit;

  const UpdateItemData({
    super.key,
    required this.id,
    required this.name,
    required this.sales_price,
    required this.purchase_price,
    required this.unit,
  });

  @override
  State<UpdateItemData> createState() => _UpdateItemDataState();
}

class _UpdateItemDataState extends State<UpdateItemData> {
  late TextEditingController _nameController;
  late TextEditingController _SalesPriceController;
  late TextEditingController _PurchasePriceController;

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
  late String selectedUnit;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.name);
    _SalesPriceController = TextEditingController(text: widget.sales_price);
    _PurchasePriceController = TextEditingController(text: widget.purchase_price);
    selectedUnit = widget.unit;
  }

  Future<bool> updateData() async {
    String baseurl = Config.baseURL;
    final url = Uri.parse('$baseurl/items/updateitem/${widget.id}'); // Replace with your actual API endpoint

    final data = {
      'name': _nameController.text,
      'sales_price': _SalesPriceController.text,
      'purchase_price': _PurchasePriceController.text,
      'unit': selectedUnit,
    };

    final response = await http.put(url, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      // Handle successful update (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item updated successfully!')),
      );
      return true;
      // Consider navigating back or closing the screen
    } else {
      // Handle errors (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating item')),
      );

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Item Data"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name", style: TextStyle(fontSize: 20)),
              SizedBox(height: 5),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text("Sales Price", style: TextStyle(fontSize: 20)),
              SizedBox(height: 5),
              TextField(
                controller: _SalesPriceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text("Purchase Price", style: TextStyle(fontSize: 20)),
              SizedBox(height: 5),
              TextField(
                controller: _PurchasePriceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              // Unit selection dropdown
              Text("Unit", style: TextStyle(fontSize: 20)),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.all(2),
                width: double.infinity, // Adjust width as needed
                decoration: BoxDecoration(
                  border: Border.all(),
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
                onPressed: () async {
                  // fetch api
                  bool check = await updateData();
                  if (check) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: Text(
                  "Edit Data",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
