import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:billapp/components/Dashboard/getPDF.dart';

import 'package:billapp/config.dart';
import 'package:intl/intl.dart'; 
import 'package:billapp/module/itemdata.dart';
import 'package:billapp/module/partydata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceScreen extends StatefulWidget {
  final PartyData party;
  final Map<ItemData, int> selectedItems;
  const InvoiceScreen({super.key,
                        required this.party,
                        required this.selectedItems,
  });

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {




 
  @override
  Widget build(BuildContext context) {
      int totalAmount=0;
       // Get the current date and due date
    DateTime now = DateTime.now();
    DateTime dueDate = now.add(Duration(days: 7));

    // Format the dates
    String currentDate = DateFormat('dd-MM-yyyy').format(now);
    String formattedDueDate = DateFormat('dd-MM-yyyy').format(dueDate);


    // final String baseUrl = 'http://192.168.43.21:5000';

   String baseurl = Config.baseURL;

  Future<bool> sendJsonData() async {
  List<Map<String, dynamic>> itemDetails = widget.selectedItems.entries.map((entry) {
    return {
      'item_id': entry.key.id,
      'quantity': entry.value,
      'unit_price': entry.key.salesPrice,
    };
  }).toList();

  Map<String, dynamic> data = {
    'party_id': widget.party.id,
    'invoice_date': currentDate.toString(),
    'total_amount': totalAmount.toString(),
    'status': 'Unpaid',
    'items': itemDetails,
  };

  String jsonData = jsonEncode(data);

  print(jsonData);

  final response = await http.post(
    Uri.parse('$baseurl/postinvoices'),
    headers: {"Content-Type": "application/json"},
    body: jsonData,
  );

  if (response.statusCode == 201) {
    print('Invoice data sent successfully');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Saved To Databased")));
    return true;
  } else {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Unable Saved To Databased")));
    print('Failed to send invoice data');
    return false;
  }
}

@override
  void initState() {
    super.initState();
    currentDate = DateTime.now().toIso8601String();
    totalAmount = widget.selectedItems.entries
        .map((entry) => int.parse(entry.key.salesPrice) * entry.value)
        .fold(0, (sum, element) => sum + element);

    
  }

  



    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice"),
      ),

      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.purple)),
                
                onPressed: (){

                  sendJsonData();

                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Getpdf(party: widget.party,
                            selectedItems: widget.selectedItems,) ));
              }, child: Text("Save Data and Generate PDF >",style: TextStyle(color:Colors.white),))],),
          ),
          Expanded(
            child: Container(
              width: 500,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(top: 20,left: 15,right: 15),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            
                    // Heading Name and Phone number ---------------------------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shree Samarth Trading",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,fontFamily:'Times'),),
                        Text("Mobile: 9284590263",style: TextStyle(fontSize: 12,fontFamily:'Times')),
                      ],
                    ),
            
                    SizedBox(
                      height: 15,
                    ),
            
            // invoice Heading Name ------------------ -------------------------------------------------
                    Container(
                      width: 500,
                      height: 5,
                      color: Colors.black,
                    ),
            
                    Container(
                      width: 500,
                      height: 25,
                      color: Color.fromARGB(255, 236, 235, 235),
                      // padding: EdgeInsets.all(20),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Invoice No: ",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600),),
                          Text("Invoice Date: ${currentDate}" ,style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600),),
                          Text("Due Date: ${formattedDueDate}", style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600),),
            
                        ],
                      ) ,
                    ),
            
                    // Party Name ------------- -------------------------------------------------
            
                    Container(
                      width: 500,
                     padding: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("BILL TO", style: TextStyle( fontSize: 12,),),
                          Text("${widget.party.name.toUpperCase()}" ,style: TextStyle( fontSize: 15, fontWeight: FontWeight.w600),),
                        ],
                      ),
                    ),
            
            SizedBox(height: 10,),
                    // Items Heading ------------- -------------------------------------------------
                   Container(
                      width: 500,
                      height: 2,
                      color: Colors.black,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 7,horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text("ITEMS",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Text("QTY" ,style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                        SizedBox(width: 40,),
                        Text("RATE",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                        SizedBox(width: 40,),
                        Text("AMOUNT",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                          ],
                        ),
                        
            
                      ],),
                    ),
            
            
            
            
                    Container(
                      width: 500,
                      height: 2,
                      color: Colors.black,
                    ),
            
            
                    // Items ------------- -------------------------------------------------
            
                    Container(
                      height: 200,
                      padding: EdgeInsets.symmetric(vertical: 7,horizontal: 5),
                      child:  Column(
                        children: widget.selectedItems.keys.map((item) {
                      final quantity = widget.selectedItems[item]!;
                      final salesPrice = item.salesPrice;
                       final totalPrice = (int.parse(salesPrice) * quantity);
                       totalAmount +=totalPrice;
                      return items(item.name, quantity.toString(), salesPrice, totalPrice.toString());
                      
                    }).toList(),
                        // children: [
                        //       items("Cement","20","200","1500"),
                        //       items("Vedant","50","400","15000"),
                        //       items("Patel","80","600","1550"),
                        // ],
                      ) ,
            
            
                    ),
            
             // Subtotal Section ------------- -------------------------------------------------
                     Container(
                      width: 500,
                      height: 2,
                      color: Colors.black,
                    ),
            
                     Container(
                      padding: EdgeInsets.symmetric(vertical: 7,horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text("SUBTOTAL",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                       
                        Text("₹${totalAmount}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
                          ],
                        ),
                        
            
                      ],),
                    ),
            
                    Container(
                      width: 500,
                      height: 2,
                      color: Colors.black,
                    ),
             // Other Information ------------- -------------------------------------------------
            
             SingleChildScrollView(
              scrollDirection: Axis.horizontal,
               child: Container(
                child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TERMS AND CONDITIONS",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 12,),),
                        Text("1. Goods once sold will not be \n \t \t taken back or exchanged",style:TextStyle( fontSize: 8, fontWeight: FontWeight.w400),),
                        SizedBox(height: 5,),
                        Text("2. All disputes are subject to CITY \n \t \t jurisdiction only",style:TextStyle(fontWeight: FontWeight.w600, fontSize: 8, ),),
                      ],
                    )
                  ],
                ),
              ),
               
               
                Container(
                
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("TAXABLE AMOUNT ",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 12,),),
                        // SizedBox(width: 10,),
                        Text(" ₹${totalAmount}" ,style:TextStyle(fontWeight: FontWeight.w600,fontSize: 15,),),
                      ],
                    ),
                    
                    Container(
                        width: 150,
                        height: 1,
                        color: Colors.grey,
                      ),
            
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("TOTAL AMOUNT ",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 12,),),
                        // SizedBox(width: 10,),
                        Text(" ₹${totalAmount}" ,style:TextStyle(fontWeight: FontWeight.w600,fontSize: 15,),),
                      ],
                    ),
                    
                    Container(
                        width: 150,
                        height: 1,
                        color: Colors.grey,
                      ),
                    
                      
                  ],
                ),
              )
             
            ],
                ),
               ),
             ),
            
                  ],
            
                  
                ),
            
            
              ),
          ),

           
        ],
      ),

        
    
    );

    
  }





  Column items(String name, String qty, String rate, String amount) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                child: Text(
                  "$name",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: 50,
                child: Text(
                  "$qty",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.right,
                ),
              ),
              Container(
                width: 50,
                child: Text(
                  "₹ $rate",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.right,
                ),
              ),
              Container(
                width: 50,
                child: Text(
                  "₹ $amount",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 0.5,
          color: Colors.grey,
        ),
      ],
    );
  }

}



pw.Column items2(String name, String qty, String rate, String amount) {
    return pw.Column(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(3.0),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(
                width: 100,
                child: pw.Text(
                  "$name",
                  style:pw. TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                ),
              ),
              pw.Container(
                width: 50,
                child: pw.Text(
                  "$qty",
                  style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Container(
                width: 50,
                child: pw.Text(
                  "Rs $rate",
                  style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Container(
                width: 50,
                child: pw.Text(
                  "Rs $amount",
                  style:pw. TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        pw.Container(
          width: double.infinity,
          height: 0.5,
          color: PdfColors.grey,
        ),
      ],
    );
  }

