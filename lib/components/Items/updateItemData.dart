import 'package:billapp/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';

class UpdateItemData extends StatefulWidget {
  final int id;
  final String name,sales_price,purchase_price;
  const UpdateItemData({super.key,
                          required this.id,
                          required this.name,
                          required this.sales_price,
                          required this.purchase_price
  
  });

  @override
  State<UpdateItemData> createState() => _UpdateItemDataState();
}

class _UpdateItemDataState extends State<UpdateItemData> {



late TextEditingController _nameController ;
late TextEditingController _SalesPriceController ;
late TextEditingController _PurchasePriceController ;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nameController=TextEditingController(text: "${widget.name}");
    _SalesPriceController=TextEditingController(text: "${widget.sales_price}");
    _PurchasePriceController=TextEditingController(text: "${widget.purchase_price}");
    
  }


 Future<bool> updateData() async {
  // String baseurl='http://192.168.43.21:5000';
  String baseurl = Config.baseURL;
    final url = Uri.parse('$baseurl/items/updateitem/${widget.id}'); // Replace with your actual API endpoint

    final data = {
      'name': _nameController.text,
      'sales_price': _SalesPriceController.text,
      'purchase_price': _PurchasePriceController.text,
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

      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name",style: TextStyle(fontSize: 20),),
            SizedBox(height: 5,),
            TextField(
                controller: _nameController,
                decoration:InputDecoration(
                  border: OutlineInputBorder(),
                  
                ),
            ),

            Text("Sales Price",style: TextStyle(fontSize: 20),),
            SizedBox(height: 5,),
            TextField(
                controller: _SalesPriceController,
                decoration:InputDecoration(
                  border: OutlineInputBorder(),
                  
                ),
            ),

            Text("Purchase Price",style: TextStyle(fontSize: 20),),
            SizedBox(height: 5,),
            TextField(
                controller: _PurchasePriceController,
                decoration:InputDecoration(
                  border: OutlineInputBorder(),
                  
                ),
            ),

             SizedBox(height: 10,),

             ElevatedButton(
              onPressed: ()async{
              // fetch api 
              bool check = await updateData();
              if(check){
                Navigator.of(context).pop(true);
              }

             }, child: Text("Edit Data",style: TextStyle(fontSize: 20,color: Colors.white),),
             style: ButtonStyle(backgroundColor:WidgetStatePropertyAll(Colors.purple)),
             )

          ],
        ),
      ),
    );
  }
}