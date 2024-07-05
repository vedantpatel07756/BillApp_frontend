import 'package:billapp/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Updatestock extends StatefulWidget {
  final String quantity;
  final int id;

  const Updatestock({super.key,required this.id, required this.quantity});

  @override
  State<Updatestock> createState() => _UpdatestockState();
}

class _UpdatestockState extends State<Updatestock> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  String groupValue = 'Add Stock';

  late int currentStock;
  int updatedStock=0;

  @override
  void initState() {
    super.initState();
    // Convert the quantity string to an integer
    currentStock = int.tryParse(widget.quantity) ?? 0;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void changevalue(String value) {
    setState(() {
      int? parsedValue = int.tryParse(value);
      if (parsedValue != null) {
        if (groupValue == 'Add Stock') {
          updatedStock = currentStock + parsedValue;
        } else if (groupValue == 'Reduce Stock') {
          updatedStock = currentStock - parsedValue;
        }
      } else {
        updatedStock = currentStock; // If parsing fails, set it to currentStock
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Stock"),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectTask(),
              Text(
                "Date",
                style: TextStyle(fontSize: 23),
              ),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Today's Date",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Please Add Quantity",
                style: TextStyle(fontSize: 23),
              ),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Quantity",
                ),
                onChanged: changevalue,
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(width:2, color:(updatedStock==currentStock)? Colors.grey:((updatedStock! < currentStock)?Colors.red:Colors.green)),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Current Stock",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${widget.quantity}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Updated Stock",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${updatedStock ?? currentStock}",
                          style: TextStyle(fontSize: 20,color: (updatedStock==currentStock)? Colors.grey:((updatedStock! < currentStock)?Colors.red:Colors.green)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          
          SizedBox(height: 40),

              submitButton(),
          
          
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton submitButton() {

        Future<bool> pushdata()async{
            //   int stock;
            // if(groupValue=="Add Stock"){
            //           stock=updatedStock+currentStock;
            // }else{
            //   stock=currentStock-updatedStock;
            // }
               // "quantity": updatedStock.toString(), 
           var data = {
        "item_id": widget.id, // Replace with your item_id logic or variable
        "quantity":((groupValue=="Add Stock")?updatedStock-currentStock:currentStock-updatedStock).toString(),
        "transaction_type": groupValue, 
        "date":_dateController.text.split(' ')[0], // Convert updatedStock to string if necessary
      };
      // String baseurl='http://192.168.43.21:5000';
      String baseurl = Config.baseURL;
      // Send data to backend API
      var response = await http.post(
        Uri.parse('$baseurl/api/add_stock_transaction'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
  print("response code =${response.statusCode}");
      // Check response status and handle accordingly
      if (response.statusCode == 200) {
        // Successful update
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item updated successfully!')),
      );
        
        // You can navigate to another screen or show a success message
      } else {
        // Error occurred
        print('Failed to update stock: ${response.statusCode}');
        
        // Handle error, show error message, etc.
      }
         return true;
        }

    return ElevatedButton(
              
            onPressed: ()async{
                // try 
                  bool check=await pushdata();
                  if(check){
                    Navigator.of(context).pop(true);
                  }

                 // Prepare data to send to backend
    
                // UPdate Querry passed 

            }, 
        
            style: ButtonStyle(
              backgroundColor:WidgetStatePropertyAll(Colors.purple),
            ),
            child: Text("Save",style:TextStyle(fontSize:20, color:Colors.white),));
  }



  // Add and Reduce Radio Button
  Container selectTask() {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Radio<String>(
              value: 'Add Stock',
              groupValue: groupValue,
              onChanged: (value) {
                setState(() {
                  groupValue = value!;
                  changevalue(_quantityController.text); // Recalculate updatedStock
                });
              },
            ),
            Text(
              'Add Stock',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Radio<String>(
              value: 'Reduce Stock',
              groupValue: groupValue,
              onChanged: (value) {
                setState(() {
                  groupValue = value!;
                  changevalue(_quantityController.text); // Recalculate updatedStock
                });
              },
            ),
            Text(
              'Reduce Stock',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
