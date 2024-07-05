import 'dart:convert';
import 'dart:io';

import 'package:billapp/config.dart';
// import 'package:billapp/module/Invoicedata.dart';
// import 'package:billapp/module/itemdata.dart';
import 'package:billapp/module/partydata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart'; 
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';




// Try New Model 
class Invoice2 {
  final int id;
  final String invoiceDate;
  final List<Item> items;
  final int partyId;
  final String status;
  final String totalAmount;

  Invoice2({
    required this.id,
    required this.invoiceDate,
    required this.items,
    required this.partyId,
    required this.status,
    required this.totalAmount,
  });

  factory Invoice2.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<Item> itemsList = list.map((i) => Item.fromJson(i)).toList();

    return Invoice2(
      id: json['id'],
      invoiceDate: json['invoice_date'],
      items: itemsList,
      partyId: json['party_id'],
      status: json['status'],
      totalAmount: json['total_amount'],
    );
  }
}

class Item {
  final int id;
  final String name;
  final String quantity;
  final String totalItemValue;
  final String unitPrice;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.totalItemValue,
    required this.unitPrice,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      totalItemValue: json['total_item_value'],
      unitPrice: json['unit_price'],
    );
  }
}


// Try New Model 






class Converttopdf extends StatefulWidget {
  final PartyData party;
  final int invoice_id;
  const Converttopdf({
                      super.key,
                      required this.party,
                      required this.invoice_id,
  });

  @override
  State<Converttopdf> createState() => _ConverttopdfState();
}



class _ConverttopdfState extends State<Converttopdf> {

  late Future<dynamic> futureInvoice;


  // Try 3 

  Future<void> _requestPermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

Future<void> _downloadPDF2( Invoice2? invoice) async {



  final pdf = pw.Document();
  int totalAmount = 0;
  DateTime now = DateTime.now();
  DateTime dueDate = now.add(Duration(days: 7));

  String currentDate = DateFormat('dd-MM-yyyy').format(now);
  String formattedDueDate = DateFormat('dd-MM-yyyy').format(dueDate);


  await _requestPermission();

  try {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            width: 500,
            margin: pw.EdgeInsets.all(0),
            padding: pw.EdgeInsets.all(0),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Heading Name and Phone number
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Shree Samarth Trading",
                      style: pw.TextStyle(fontSize: 25, font: pw.Font.timesBold()),
                    ),
                    pw.Text(
                      "Mobile: 9284590263",
                      style: pw.TextStyle(fontSize: 15, font: pw.Font.timesBold()),
                    ),
                  ],
                ),
                pw.SizedBox(height: 15),
                // Invoice Heading Name
                pw.Container(width: 500, height: 5, color: PdfColors.black),
                pw.Container(
                  width: 500,
                  height: 25,
                  color: PdfColors.grey100,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.Text(
                        "Invoice No: ",
                        style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                      ),
                      pw.Text(
                        "Invoice Date: $currentDate",
                        style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                      ),
                      pw.Text(
                        "Due Date: $formattedDueDate",
                        style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                      ),
                    ],
                  ),
                ),

                 pw.Container(width: 500, height: 5, color: PdfColors.black),

                // Party Name
                pw.Container(
                  width: 500,
                  padding: pw.EdgeInsets.symmetric(vertical: 5),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "BILL TO ${widget.party.type}",
                        style: pw.TextStyle(fontSize: 10),
                      ),
                       pw.SizedBox(height: 5),
                       pw.Row(
                        children: [
                              pw.Text(
                        widget.party.name.toUpperCase(),
                        style: pw.TextStyle(fontSize: 20, fontBold: pw.Font.timesBold()),
                      ),
                        pw.SizedBox(width: 10),
                        pw.Text("Mobile No.${widget.party.contactNumber.toUpperCase()}"
                        ,
                        style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.times()),
                      ),

                        ]
                       ),
                      
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                // Items Heading
                pw.Container(width: 500, height: 2, color: PdfColors.black),
                pw.Container(
                  color: PdfColors.grey100,
                  padding: pw.EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "ITEMS",
                        style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "QTY",
                            style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                          ),
                          pw.SizedBox(width: 100),
                          pw.Text(
                            "RATE",
                            style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                          ),
                          pw.SizedBox(width: 40),
                          pw.Text(
                            "AMOUNT",
                            style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.Container(width: 500, height: 2, color: PdfColors.black),
                // Items
              pw.Container(width: 500, height: 2, color: PdfColors.black),
                // Items
                pw.Container(
                  height: 200,
                  padding: pw.EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                  child: pw.Column(
                    children:[...invoice!.items.map((item) {
                      final quantity = item.quantity;
                      final salesPrice = item.unitPrice;
                       final totalPrice = int.tryParse(item.totalItemValue);
                      //  totalAmount =invoice.totalAmount;
                      return items2(item.name, quantity.toString(), salesPrice, totalPrice.toString());
                    }).toList(),]
                  ),
                ),
                // Subtotal Section
                pw.Container(width: 500, height: 2, color: PdfColors.black),
                pw.Container(
                  padding: pw.EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "SUBTOTAL",
                        style: pw.TextStyle(fontSize: 15, fontBold: pw.Font.timesBold()),
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "Rs ${invoice.totalAmount}",
                            style: pw.TextStyle(fontSize: 15, fontBold: pw.Font.timesBold()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.Container(width: 500, height: 2, color: PdfColors.black),
                // Other Information
                pw.Container(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 180,
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "TERMS AND CONDITIONS",
                                  style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 15),
                                ),
                                  pw.SizedBox(height: 5),
                                pw.Text(
                                  "1. Goods once sold will not be  taken back or exchanged",
                                  style: pw.TextStyle(fontSize: 10, font: pw.Font.times()),
                                ),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                  "2. All disputes are subject to CITY  jurisdiction only",
                                  style: pw.TextStyle(font: pw.Font.times(), fontSize: 10),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      pw.SizedBox(width: 120),
                      pw.Container(
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "TAXABLE AMOUNT ",
                                  style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 12),
                                ),
                                pw.Text(
                                  " Rs ${invoice.totalAmount}",
                                  style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 15),
                                ),
                              ],
                            ),
                            pw.Container(width: 170, height: 1, color: PdfColors.grey),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "TOTAL AMOUNT ",
                                  style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 12),
                                ),
                                pw.Text(
                                  " Rs ${invoice.totalAmount}",
                                  style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 15),
                                ),
                              ],
                            ),
                            pw.Container(width: 170, height: 1, color: PdfColors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final Directory? externalDir = await getExternalStorageDirectory();
    final Directory billAppDir = Directory('${externalDir!.path}/BillApp');
    
    // Create the directory if it doesn't exist
    if (!(await billAppDir.exists())) {
      await billAppDir.create(recursive: true);
    }

    final file = File("${billAppDir.path}/${widget.party.name}|${currentDate}.pdf");
    await file.writeAsBytes(await pdf.save());

    // Show a snackbar indicating successful download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF Downloaded to ${file.path}')),
    );

    // Open the PDF file using the default file viewer
    OpenFile.open(file.path);

  } on PlatformException catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('PlatformException: ${e.message}')),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
}

// Try 3 


// Try Fetch

 Future<dynamic> fetchInvoice(int invoiceId) async {
      String baseurl = Config.baseURL;
  
    final response = await http.get(Uri.parse('$baseurl/invoiceid/$invoiceId'));

    if (response.statusCode == 200) {
    return Invoice2.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load invoice');
  }
  } 


// Try Fetch 


// delete bill 

  Future<bool> deleteInvoice(int invoiceId) async {
    String baseurl = Config.baseURL;
    final url = '$baseurl/delete_invoice/$invoiceId';
    
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      
      print('Invoice deleted successfully');
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.party.name}Invoice #${invoiceId} deleted successfully')),
    );
      return true;
    
    } else {
      throw Exception('Failed to delete invoice');

      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureInvoice = fetchInvoice(widget.invoice_id);
  print(futureInvoice);
  }
 Invoice2? _currentInvoice;

String status="Unpaid";


  @override
  Widget build(BuildContext context) {
     late String totalAmount;
             // Get the current date and due date
    DateTime now = DateTime.now();
    DateTime dueDate = now.add(Duration(days: 7));

    // Format the dates
    String currentDate = DateFormat('dd-MM-yyyy').format(now);
    String formattedDueDate = DateFormat('dd-MM-yyyy').format(dueDate);

    //  Mark as paid 

Future<bool> markInvoiceAsPaid(int invoiceId) async {
    String baseurl = Config.baseURL;
    final url = '$baseurl/mark/$invoiceId/mark_as_paid';
    
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        status="Paid";
      });
      print('Invoice marked as paid');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${widget.party.name} Invoice #${invoiceId} marked as ${status}")));

      return true;
    } else {
      throw Exception('Failed to mark invoice as paid');
      return false;
    }
  }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('BILL of ${widget.party.name}'),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                 _downloadPDF2( _currentInvoice);
              },
              child: Icon(Icons.save_alt_rounded,color: Colors.blue,size: 30,)),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: ()async{
                bool check=await deleteInvoice(widget.invoice_id);

                if(check){
                    Navigator.of(context).pop(true);
                }
              },
              child: Icon(Icons.delete ,color: Colors.red,size: 30,)),
          )
        ],
        
      ),

      body:Center(
        child: FutureBuilder<dynamic>(
          future: futureInvoice,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {

                Invoice2 invoice = snapshot.data!;
                _currentInvoice = invoice;

                if(invoice.status=="Unpaid"){
                  status="Unpaid";
                }else{
                  status="Paid";
                }
                return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:  (status=="Unpaid")?const Color.fromARGB(70, 244, 67, 54):const Color.fromARGB(77, 76, 175, 54)),
                                
                                child: Text("$status",style: TextStyle(color: (status=="Unpaid")?Colors.red:Colors.green),),
                              ),
                          
                              ElevatedButton(
                                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                                onPressed: ()async{
                                 
                              bool check=await markInvoiceAsPaid(invoice.id);
                          
                              if(check){
                                Navigator.of(context).pop(true);
                              }
                                                   
                              }, child: Text((status=="Unpaid")?"Mark as Paid":"Mark as Unpaid",style: TextStyle(color:Colors.white),)),
                            ],
                          ),
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
                          Text("BILL TO ${widget.party.type}", style: TextStyle( fontSize: 12,),),
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
                        children:[
                          ...invoice.items.map((item) {
                      final quantity = item.quantity;
                      final salesPrice = item.unitPrice;
                       final totalPrice = int.tryParse(item.totalItemValue);
                      //  totalAmount =invoice.totalAmount;
                      return items(item.name, quantity.toString(), salesPrice, totalPrice.toString());
                      
                    }).toList(),
                        ]
                      
                      
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
                       
                        Text("₹${invoice.totalAmount}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
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
                        Text(" ₹${invoice.totalAmount}" ,style:TextStyle(fontWeight: FontWeight.w600,fontSize: 15,),),
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
                        Text(" ₹${invoice.totalAmount}" ,style:TextStyle(fontWeight: FontWeight.w600,fontSize: 15,),),
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
                );
// Try 


  // Invoice invoice = snapshot.data!;
              // return Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('Invoice ID: ${invoice.id}'),
              //     Text('Invoice Date: ${invoice.invoiceDate}'),
              //     Text('Party ID: ${invoice.partyId}'),
              //     Text('Status: ${invoice.status}'),
              //     Text('Total Amount: ${invoice.totalAmount}'),
              //     Text('Items:'),
              //     ...invoice.items.map((item) => ListTile(
              //           title: Text(item.name),
              //           subtitle: Text('Quantity: ${item.quantity}, Total Item Value: ${item.totalItemValue}, Unit Price: ${item.unitPrice}'),
              //         )),
              //   ],
              // );
            } 

// Try 
             else {
              return Text('No data');
            }
          },
        ),
      ),
    
    );
  }
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
