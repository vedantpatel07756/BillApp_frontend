import 'package:billapp/components/Items/updateItemData.dart';
import 'package:billapp/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart'; // For date formatting

class ItemsDatas extends StatefulWidget {
  final int id;
  final String name, quantity, sales_price, purchase_price; // Renamed Purpase_price to purchase_price
  const ItemsDatas({
    Key? key, // Added key parameter
    required this.id,
    required this.name,
    required this.quantity,
    required this.sales_price,
    required this.purchase_price, // Corrected parameter name
  }) : super(key: key); // Fixed super constructor invocation

  @override
  State<ItemsDatas> createState() => _ItemDataState();
}

class _ItemDataState extends State<ItemsDatas> {
  late int? stockValue;
  late List<Map<String, String>> transactions = [];

  // Fetch Stock data transaction 

  Future<void> fetchStockData(int itemId) async {
    final response = await http.get(Uri.parse('${Config.baseURL}/stock/${widget.id}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> jsonTransactions = data['transactions'];

      setState(() {
        transactions = jsonTransactions.map((transaction) {
          // Convert dynamic values to String where needed
          return {
            'date': transaction['date'].toString().replaceAll(" 00:00:00 GMT", ""), // Example conversion to String
            'transaction_type': transaction['transaction_type'].toString(),
            'quantity': transaction['quantity'].toString(),
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  // Delete Item Data 

  Future<bool> _deleteItem() async {
    // String baseurl='http://192.168.43.21:5000';
       String baseurl = Config.baseURL;
    final url = Uri.parse('$baseurl/items/delete/${widget.id}'); // Replace with your actual API endpoint

    final response = await http.post(url);

    if (response.statusCode == 200) {
      // Handle successful deletion (e.g., show a snackbar, navigate back)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item deleted successfully!')),
      );
        return true; // Assuming you want to navigate back on success
    } else {
      // Handle errors (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting item')),
      );

      return false;
    }
  }




  @override
  void initState() {
    super.initState();
    // Perform the calculation in initState
    int? quantity = int.tryParse(widget.quantity);
    int? salesPrice = int.tryParse(widget.sales_price);

    if (quantity != null && salesPrice != null) {
      stockValue = quantity * salesPrice;
    } else {
      stockValue = 0; // or any other default value or error handling
    }

    // Fetch initial transaction data
    fetchStockData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateItemData(id:widget.id,
                                                                  name:widget.name,
                                                                  sales_price: widget.sales_price,
                                                                  purchase_price: widget.purchase_price,))).then((value) {
                                                                    if(value){
                                                                      Navigator.of(context).pop(true);
                                                                    }
                                                                  },);
            },
            child: Icon(Icons.edit, color: Colors.blue)),
          SizedBox(width: 20),

          GestureDetector(
            onTap: ()async{
                  bool check = await _deleteItem();

                  if(check){
                    Navigator.of(context).pop(true);
                  }
            },
            child: Icon(Icons.delete_rounded, color: Colors.red)),


          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          itemName(),
          itemDetail(),
          Container(
            width: 500,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, border: BorderDirectional(bottom: BorderSide())),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Transaction Time Line",
                    style: TextStyle(
                      
                      fontWeight: FontWeight.w600,
                      color: Colors.purple,
                      fontSize: 20,
                      // decoration: TextDecoration.underline,
                      decorationColor: Colors.purple,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return transactionContainer(
                  transaction['date']!,
                  transaction['transaction_type']!,
                  transaction['quantity']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container transactionContainer(String date, String task, String quantity) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all()
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("$date", style: TextStyle(fontSize: 15)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$task",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
              ),
              Text("${quantity} Bags", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22))
            ],
          )
        ],
      ),
    );
  }

  Container itemDetail() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white, border: BorderDirectional(bottom: BorderSide(width: 0.2))),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Sales Price",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "₹ ${widget.sales_price}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      "Purchase Price",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "₹ ${widget.purchase_price}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      "Stock Quantity",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${widget.quantity} Bags",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Text(
                  "Stock Value",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                Text(
                  "₹ ${stockValue}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Container itemName() {
    return Container(
      width: 500,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: BorderDirectional(bottom: BorderSide(width: 0.2)),
      ),
      child: Text("${widget.name.toUpperCase()}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
    );
  }
}
