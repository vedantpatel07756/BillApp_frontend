import 'dart:io';

import 'package:billapp/module/itemdata.dart';
import 'package:billapp/module/partydata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class Getpdf extends StatefulWidget {
   final PartyData party;
  final Map<ItemData, int> selectedItems;

  const Getpdf({
    super.key,
    required this.party,
    required this.selectedItems,
  });

  @override
  State<Getpdf> createState() => _GetpdfState();
}

class _GetpdfState extends State<Getpdf> {



// Try 3 

Future<void> _downloadPDF2(Map<ItemData, int> selectedItems,  String partyName) async {
  final pdf = pw.Document();
  int totalAmount = 0;
  DateTime now = DateTime.now();
  DateTime dueDate = now.add(Duration(days: 7));

  String currentDate = DateFormat('dd-MM-yyyy').format(now);
  String formattedDueDate = DateFormat('dd-MM-yyyy').format(dueDate);

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
                        partyName.toUpperCase(),
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
                    children: selectedItems.keys.map((item) {
                      final quantity = selectedItems[item]!;
                      final salesPrice = item.salesPrice;
                      final totalPrice = (int.parse(salesPrice) * quantity);
                      totalAmount += totalPrice;
                      return items2(item.name, quantity.toString(), salesPrice, totalPrice.toString());
                    }).toList(),
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
                            "Rs $totalAmount",
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
                                  " Rs $totalAmount",
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
                                  " Rs $totalAmount",
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

    final file = File("${billAppDir.path}/${partyName}|${currentDate}.pdf");
    await file.writeAsBytes(await pdf.save());

    // Show a snackbar indicating successful download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF Downloaded to ${file.path}')),
    );

    // Open the PDF file using the default file viewer
    OpenFile.open(file.path);

  } catch (e) {
    // Show a snackbar with the error message if any error occurs
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error downloading PDF: $e')),
    );
  }
}

// Try 3 


  @override
  Widget build(BuildContext context) {

    
   int totalAmount = 0;
    DateTime now = DateTime.now();
    DateTime dueDate = now.add(Duration(days: 7));

    String currentDate = DateFormat('dd-MM-yyyy').format(now);
    String formattedDueDate = DateFormat('dd-MM-yyyy').format(dueDate);


  return Scaffold(
      appBar: AppBar(
        title: Text("Download Invoice"),
      ),

      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ElevatedButton(
                              onPressed: () async {
                                // Check if the permission is already granted
                                if (await Permission.storage.isGranted) {
                                  // _downloadPDF();
                                   _downloadPDF2(widget.selectedItems,widget.party.name.toUpperCase());
                                } else {
                                  // Request storage permission
                                  Map<Permission, PermissionStatus> statuses = await [
                                    Permission.storage,
                                  ].request();

                                  if (statuses[Permission.storage]!.isGranted) {
                                    _downloadPDF2(widget.selectedItems,widget.party.name.toUpperCase());
                                  } else {
                                    print("No Permission Granted");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Permission Denied")),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                "Download >",
                                style: TextStyle(color: Colors.black),
                              ),
                            )
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
                          Text("BILL TO ${widget.party.type.toUpperCase()}", style: TextStyle( fontSize: 12,),),
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
                        SizedBox(width: 20,),
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
                width: 170,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TERMS AND CONDITIONS",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 12,),),
                        Text("1. Goods once sold will not be \n \t \t taken back or exchanged",style:TextStyle( fontSize: 8, fontWeight: FontWeight.w400),),
                        SizedBox(height: 5,),
                        Text("2. All disputes are subject to CITY \n \t \t jurisdiction only",style:TextStyle(fontWeight: FontWeight.w400, fontSize: 8, ),),
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
                        Text("TAXABLE AMOUNT ",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 10,),),
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
                        Text("TOTAL AMOUNT ",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 10,),),
                        // SizedBox(width: 10,),
                        Text(" ₹ ${totalAmount}" ,style:TextStyle(fontWeight: FontWeight.w600,fontSize: 15,),),
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

