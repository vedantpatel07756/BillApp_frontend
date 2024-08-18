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
  // final Map<ItemData, int> selectedItems;
   final Map<ItemData, Map<String, dynamic>> selectedItems;
   final String bussinessName,bussinessPhone,PaymentCash,PaymentOnline;

  const Getpdf({
    super.key,
    required this.party,
    required this.selectedItems,
    required this.bussinessName,
    required this.bussinessPhone,

    required this.PaymentCash,
    required this.PaymentOnline,
  });

  @override
  State<Getpdf> createState() => _GetpdfState();
}
class Discount {
  final String type; // Percentage or Fixed
  final double value; // Percentage value or Fixed amount

  Discount({
    required this.type,
    required this.value,
  });
}


class _GetpdfState extends State<Getpdf> {

  // New BLock Of  Code Added 

  
int totalAmount = 0;
int discountAmount = 0;
int prediscountamount = 0;
String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

@override
void initState() {
  super.initState();
  calculateTotalAmount();
}

void calculateTotalAmount() {
  prediscountamount = widget.selectedItems.entries.fold(0, (sum, entry) {
    final ItemData item = entry.key;
    final int quantity = entry.value['count'];
    final int totalPrice = int.parse(item.salesPrice) * quantity;
    return sum + totalPrice;
  });

  totalAmount = widget.selectedItems.entries.fold(0, (sum, entry) {
    final ItemData item = entry.key;
    final int quantity = entry.value['count'];
    final int totalPrice = int.parse(item.salesPrice) * quantity;
    final discount = calculateDiscount(
        Discount(type: entry.value['discountType'], value: double.parse(entry.value['discountValue'])), totalPrice);
    discountAmount += discount;
    return sum + totalPrice - discount;
  });
}

int calculateDiscount(Discount discount, int totalPrice) {
  // Implement your discount logic here
  if (discount.type == 'Percentage') {
    return (totalPrice * discount.value / 100).round();
  } else {
    return discount.value.toInt(); // Assuming fixed discount is an integer
  }
}

// Example to load image bytes synchronously
Future<Uint8List> loadImageBytes(String imagePath) async {
  final ByteData data = await rootBundle.load(imagePath);
  return data.buffer.asUint8List();
}

  Future<void> _requestPermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}



  // New Block Of Code Added 
// Try 4
Future<void> _downloadPDF2(Map<ItemData, Map<String, dynamic>> selectedItems, String partyName) async {
  await _requestPermission();
     int balance = totalAmount-(int.tryParse(widget.PaymentOnline ?? '0')! + int.tryParse(widget.PaymentCash ?? '0')!);
  final pdf = pw.Document();
  DateTime now = DateTime.now();
  DateTime dueDate = now.add(Duration(days: 7));

  String currentDate = DateFormat('dd-MM-yyyy').format(now);
  String formattedDueDate = DateFormat('dd-MM-yyyy').format(dueDate);
// Load image bytes synchronously
    final Uint8List imageBytes = await loadImageBytes('assest/app_icon.png');
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
                 pw.Row(
                    mainAxisAlignment:pw. MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                         pw. Text(
                            "${widget.bussinessName}",
                            style: pw.TextStyle(fontSize: 17,  font: pw.Font.timesBold()),
                          ),
                          pw.Text(
                            "Mobile: ${widget.bussinessPhone}",
                            style: pw.TextStyle(fontSize: 12,  font: pw.Font.timesBold()),
                          ),
                        ],
                      ),
                     

                        pw.Container(
                width: 100,
                height: 100,
                child: pw.Image(
                  pw.MemoryImage(imageBytes),
                  width: 50,
                  height: 50
                ),
              ),

                    ],
                  ),
                // pw.Column(
                //   crossAxisAlignment: pw.CrossAxisAlignment.start,
                //   children: [
                //     pw.Text(
                //       "${widget.bussinessName}",
                //       style: pw.TextStyle(fontSize: 25, font: pw.Font.timesBold()),
                //     ),
                //     pw.Text(
                //       "Mobile: ${widget.bussinessPhone}",
                //       style: pw.TextStyle(fontSize: 15, font: pw.Font.timesBold()),
                //     ),
                //   ],
                // ),
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
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Container(
                              padding: pw.EdgeInsets.symmetric(vertical: 5),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("BILL TO", style: pw.TextStyle(fontSize: 12)),
                                  pw.Text("${widget.party.name.toUpperCase()}", style: pw.TextStyle(fontSize: 15, fontBold: pw.Font.timesBold())),
                                ],
                              ),
                            ),
                            pw.Container(
                              padding: pw.EdgeInsets.symmetric(vertical: 5),
                              child: pw.Column(
                                
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text("Mobile No.", style: pw.TextStyle(fontSize: 12)),
                                  pw.Text("${widget.party.contactNumber}", style: pw.TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                // Items Heading
                pw.Container(width: 500, height: 2, color: PdfColors.black),

                // Heading of Bill 
                itemsName2(),
                pw.Container(width: 500, height: 2, color: PdfColors.black),

                // Items
                pw.Container(
                  height: 200,
                  padding: pw.EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                  child: pw.Column(
                    children: widget.selectedItems.keys.map((item) {
                      final int quantity = widget.selectedItems[item]!['count'];
                      final salesPrice = item.salesPrice;
                      final discountType = widget.selectedItems[item]!['discountType'];
                      final discountValue = widget.selectedItems[item]!['discountValue'];
                      final int totalPrice = int.parse(salesPrice) * quantity;
                      final discount = calculateDiscount(Discount(type: discountType, value: double.parse(discountValue)), totalPrice);
                      final amountAfterDiscount = totalPrice - discount;

                      return items2(item.name, quantity.toString(), salesPrice, amountAfterDiscount.toString(), item.unit, discountType, discountValue);
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
                      pw.Text(
                        "Rs $totalAmount",
                        style: pw.TextStyle(fontSize: 15, fontBold: pw.Font.timesBold()),
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
                                  "1. Goods once sold will not be taken back or exchanged",
                                  style: pw.TextStyle(fontSize: 10, font: pw.Font.times()),
                                ),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                  "2. All disputes are subject to CITY jurisdiction only",
                                  style: pw.TextStyle(font: pw.Font.times(), fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 150),
                  pw.Container(
                
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                      mainAxisAlignment:pw. MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("TAXABLE AMOUNT ",style:pw.TextStyle(font: pw.Font.times(),fontSize: 10,),),
                        // SizedBox(width: 10,),
                        pw.Text(" Rs ${totalAmount}" ,style:pw.TextStyle(font: pw.Font.times(),fontSize: 15,),),
                      ],
                    ),

                    // New Block Added 
                          pw.Container(
                        width: 150,
                        height: 1,
                        color:PdfColors.grey,
                      ),

                       pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                         pw. Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Received Cash",style:pw.TextStyle(font: pw.Font.times(),fontSize: 10,),),
                            // SizedBox(width: 10,),
                            pw.Text(" Rs ${widget.PaymentCash}" ,style:pw.TextStyle(font: pw.Font.times(),fontSize: 15,),),
                          ],
                                              ),

                                               pw.  Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                           pw. Text("Received Online",style:pw.TextStyle(font: pw.Font.times(),fontSize: 10,),),
                            // SizedBox(width: 10,),
                            pw.Text(" Rs ${widget.PaymentOnline}" ,style:pw.TextStyle(font: pw.Font.times(),fontSize: 15,),),
                          ],
                                              ),
                                // TOtal amount recived 

                                pw.  Container(
                        width: 150,
                        height: 1,
                        color: PdfColors.grey,
                      ),
            
                     pw. Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("AMOUNT RECEIVED ",style:pw.TextStyle(font: pw.Font.times(),fontSize: 10,),),
                        // SizedBox(width: 10,),
                       pw. Text(" Rs ${(int.tryParse(widget.PaymentOnline ?? '0')! + int.tryParse(widget.PaymentCash ?? '0')!)}" ,style:pw.TextStyle(font: pw.Font.times(),fontSize: 15,),),
                      ],
                    ),
                    
                  pw.  Container(
                        width: 150,
                        height: 1,
                        color: PdfColors.grey,
                      ),
                                // TOtal Amount Received 


                          pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Balance Amount",style:pw.TextStyle(font: pw.Font.times(),fontSize: 10,),),
                            // SizedBox(width: 10,),
                          pw.Text(
                             " Rs ${balance}",
                             style: pw.TextStyle(font: pw.Font.times(), fontSize: 15),),
                          ],
                                              ),
                        ],
                      ),
            
                     
                    


                    // New Block Added 
                    
                    
                    
                      
                  ],
                ),
              ),

            
                      // pw.Container(
                      //   child: pw.Column(
                      //     mainAxisAlignment: pw.MainAxisAlignment.start,
                      //     crossAxisAlignment: pw.CrossAxisAlignment.end,
                      //     children: [
                      //       pw.Row(
                      //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           pw.Text(
                      //             "TAXABLE AMOUNT ",
                      //             style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 12),
                      //           ),
                      //           pw.Text(
                      //             " Rs $totalAmount",
                      //             style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 15),
                      //           ),
                      //         ],
                      //       ),
                      //       pw.Container(width: 170, height: 1, color: PdfColors.grey),
                      //       pw.Row(
                      //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           pw.Text(
                      //             "Previous Amount",
                      //             style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 12),
                      //           ),
                      //           pw.Text(
                      //             " Rs ${widget.party.balance}",
                      //             style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 15),
                      //           ),
                      //         ],
                      //       ),
                      //       pw.Row(
                      //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           pw.Text(
                      //             "Current Amount",
                      //             style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 12),
                      //           ),
                      //           pw.Text(
                      //             " Rs ${widget.party.balance + totalAmount}",
                      //             style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 15),
                      //           ),
                      //         ],
                      //       ),
                      //       pw.Container(width: 170, height: 1, color: PdfColors.grey),
                      //       pw.Row(
                      //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           pw.Text(
                      //             "TOTAL AMOUNT ",
                      //             style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 12),
                      //           ),
                      //           pw.Text(
                      //             " Rs ${widget.party.balance + totalAmount}",
                      //             style: pw.TextStyle(font: pw.Font.timesBold(), fontSize: 15),
                      //           ),
                      //         ],
                      //       ),
                      //       pw.Container(width: 170, height: 1, color: PdfColors.grey),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),

                 pw.SizedBox(height: 50),
                 pw. Container(
                      padding: pw.EdgeInsets.all(2),
                      // color: const Color.fromARGB(118, 158, 158, 158),
                       child:pw. Row(
                        mainAxisAlignment:pw. MainAxisAlignment.spaceBetween,
                          children: [
                           pw. Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                             pw. Text("Previous Balance",style:pw.TextStyle(font: pw.Font.times(),fontSize: 12,),),
                              // SizedBox(width: 12,),
                             pw. Text(" Rs ${widget.party.balance}" ,style:pw.TextStyle(font: pw.Font.times(),fontSize: 12,),),
                            ],
                                                ),
                       
                              pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("Current Balance",style:pw.TextStyle(font: pw.Font.times(),fontSize: 12,),),
                              // SizedBox(width: 12,),
                              pw.Text(" Rs ${widget.party.balance + balance}" ,style:pw.TextStyle(font: pw.Font.times(),fontSize: 12,),),
                            ],
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


  @override
  Widget build(BuildContext context) {

    
  
    DateTime now = DateTime.now();
    DateTime dueDate = now.add(Duration(days: 7));

    String currentDate = DateFormat('dd-MM-yyyy').format(now);
    String formattedDueDate = DateFormat('dd-MM-yyyy').format(dueDate);

  int balance = totalAmount-(int.tryParse(widget.PaymentOnline ?? '0')! + int.tryParse(widget.PaymentCash ?? '0')!);
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
                                _downloadPDF2(widget.selectedItems,widget.party.name.toUpperCase());
                                // Check if the permission is already granted
                                // if (await Permission.storage.isGranted) {
                                //   // _downloadPDF();
                                //    _downloadPDF2(widget.selectedItems,widget.party.name.toUpperCase());
                                // } else {
                                //   // Request storage permission
                                //   Map<Permission, PermissionStatus> statuses = await [
                                //     Permission.storage,
                                //   ].request();

                                //   if (statuses[Permission.storage]!.isGranted) {
                                //     _downloadPDF2(widget.selectedItems,widget.party.name.toUpperCase());
                                //   } else {
                                //     print("No Permission Granted");
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(content: Text("Permission Denied")),
                                //     );
                                //   }
                                // }
                              },
                              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue))
                              ,
                              child: Text(
                                "Download >",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
              ],
              ),
          ),
         Expanded(
            child: Container(
              width: 500,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Name and Phone Number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.bussinessName}",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'Times'),
                          ),
                          Text(
                            "Mobile: ${widget.bussinessPhone}",
                            style: TextStyle(fontSize: 12, fontFamily: 'Times'),
                          ),
                        ],
                      ),
                      Image.asset('assest/app_icon.png',width: 50,height: 50,)

                    ],
                  ),
                  SizedBox(height: 15),
                  // Invoice Heading
                  Container(
                    width: 500,
                    height: 5,
                    color: Colors.black,
                  ),
                  Container(
                    width: 500,
                    height: 25,
                    color: Color.fromARGB(255, 236, 235, 235),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Invoice No: ", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                        Text("Invoice Date: $currentDate", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                        Text("Due Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days: 7)))}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  // Bill To - Party Name
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // width: 500,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("BILL TO", style: TextStyle(fontSize: 12)),
                              Text("${widget.party.name.toUpperCase()}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                    
                         Container(
                          // width: 500,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(" Mobile No.", style: TextStyle(fontSize: 12)),
                              Text("${widget.party.contactNumber}", style: TextStyle(fontSize: 12,)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Items Heading
                  Container(
                    width: 500,
                    height: 2,
                    color: Colors.black,
                  ),
                  itemsName(),
                  Container(
                    width: 500,
                    height: 2,
                    color: Colors.black,
                  ),
                  // Items List
                 Container(
  height: 180,
  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
  child: Column(
    children: widget.selectedItems.keys.map((item) {
      final int  quantity = widget.selectedItems[item]!['count'];
      final salesPrice = item.salesPrice;
      final discountType = widget.selectedItems[item]!['discountType'];
      final discountValue = widget.selectedItems[item]!['discountValue'];
      final int totalPrice = int.parse(salesPrice) * quantity;
      final discount = calculateDiscount(Discount(type: discountType, value: double.parse(discountValue)), totalPrice);
      final amountAfterDiscount = totalPrice - discount;
      
      return items(item.name, quantity.toString(), salesPrice, amountAfterDiscount.toString(), item.unit, discountType, discountValue);
    }).toList(),
  ),
),
                  // Subtotal Section
                  Container(
                    width: 500,
                    height: 2,
                    color: Colors.black,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("SUBTOTAL", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        Text("₹${totalAmount}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Container(
                    width: 500,
                    height: 2,
                    color: Colors.black,
                  ),
                  // Other Information - Terms and Conditions
                  // Try 
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

                    // New Block Added 
                          Container(
                        width: 150,
                        height: 1,
                        color: Colors.grey,
                      ),

                       Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Received Cash",style:TextStyle(fontWeight: FontWeight.w400,fontSize: 10,),),
                            // SizedBox(width: 10,),
                            Text(" ₹ ${widget.PaymentCash}" ,style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,),),
                          ],
                                              ),

                                                 Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Received Online",style:TextStyle(fontWeight: FontWeight.w400,fontSize: 10,),),
                            // SizedBox(width: 10,),
                            Text(" ₹ ${widget.PaymentOnline}" ,style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,),),
                          ],
                                              ),
                                // TOtal amount recived 

                                  Container(
                        width: 150,
                        height: 1,
                        color: Colors.grey,
                      ),
            
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("AMOUNT RECEIVED ",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 10,),),
                        // SizedBox(width: 10,),
                        Text(" ₹ ${(int.tryParse(widget.PaymentOnline ?? '0')! + int.tryParse(widget.PaymentCash ?? '0')!)}" ,style:TextStyle(fontWeight: FontWeight.w600,fontSize: 15,),),
                      ],
                    ),
                    
                    Container(
                        width: 150,
                        height: 1,
                        color: Colors.grey,
                      ),
                                // TOtal Amount Received 


                                                     Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Balance Amount",style:TextStyle(fontWeight: FontWeight.w400,fontSize: 10,),),
                            // SizedBox(width: 10,),
                          Text(
                             " ₹ ${balance}",
                             style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),),
                          ],
                                              ),
                        ],
                      ),
            
                     
                    


                    // New Block Added 
                    
                    
                    
                      
                  ],
                ),
              )
             
            ],
                ),
               ),
             ),
                  SizedBox(height: 10),

                   Container(
                      padding: EdgeInsets.all(2),
                      // color: const Color.fromARGB(118, 158, 158, 158),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Previous Balance",style:TextStyle(fontWeight: FontWeight.w400,fontSize: 10,),),
                              // SizedBox(width: 10,),
                              Text(" ₹ ${widget.party.balance}" ,style:TextStyle(fontWeight: FontWeight.w400,fontSize: 10,),),
                            ],
                                                ),
                       
                                                   Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Current Balance",style:TextStyle(fontWeight: FontWeight.w400,fontSize: 10,),),
                              // SizedBox(width: 10,),
                              Text(" ₹ ${widget.party.balance + balance}" ,style:TextStyle(fontWeight: FontWeight.w400,fontSize: 10,),),
                            ],
                                                ),
                          ],
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



pw.Column items2(String name, String qty, String rate, String amount, String unit, String discountType, String discountValue) {
  String symbol = (discountType=="Percentage") ? "%" : "Rs"; 
  return pw.Column(
    children: [
      pw.Padding(
        padding: const pw. EdgeInsets.all(3.0),
        child:pw. Row(
          mainAxisAlignment:pw. MainAxisAlignment.spaceBetween,
          children: [
            pw.Container(
              width: 50,
              child: pw.Text(
                "$name",
                style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
              ),
            ),
            pw.Container(
              width: 50,
              child: pw.Text(
                "$qty $unit",
                style:pw. TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                textAlign:pw. TextAlign.right,
              ),
            ),
            pw. Container(
              width: 50,
              child: pw.Text(
                "$symbol ${discountValue.isEmpty ? '0' : discountValue}",
                style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                textAlign: pw.TextAlign.right,
              ),
            ),
           pw. Container(
              width: 50,
              child: pw.Text(
                "Rs $rate",
                style:pw. TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                textAlign: pw.TextAlign.right,
              ),
            ),
           pw. Container(
              width: 50,
              child: pw.Text(
                "Rs $amount",
                style:pw. TextStyle(fontSize: 12, fontBold: pw.Font.timesBold()),
                textAlign:pw. TextAlign.right,
              ),
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 5),

    ],
  );
}


pw.Column itemsName2() {
 
  return pw.Column(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.only(left: 5.0,top:3,bottom: 3),
        child:pw. Row(
          mainAxisAlignment:pw. MainAxisAlignment.spaceBetween,
          children: [
            pw.Container(
              width: 70,
              child: pw.Text("ITEMS", style:pw. TextStyle(fontSize: 12,fontBold: pw.Font.timesBold())),
            ),
           pw. Container(
              width: 50,
              child: pw.Text("QTY", style:pw. TextStyle(fontSize: 12, fontBold: pw.Font.timesBold())),
            ),
             pw.Container(
              width: 60,
              child: pw.Text("DISOUNT", style: pw.TextStyle(fontSize: 12, fontBold: pw.Font.timesBold())),
            ),
            pw.Container(
              width: 50,
              child:pw.Text("PRICE", style:pw. TextStyle(fontSize: 12, fontBold: pw.Font.timesBold())),
            ),
            pw.Container(
              width: 50,
              child: pw.Text("Amount", style:pw. TextStyle(fontSize: 12, fontBold: pw.Font.timesBold())),
            ),
          ],
        ),
      ),
     pw. SizedBox(height: 5),

    ],
  );
}  


}



 
Column itemsName() {
 
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 5.0,top:3,bottom: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 70,
              child: Text("ITEMS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            Container(
              width: 50,
              child: Text("QTY", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
             Container(
              width: 60,
              child: Text("DISOUNT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            Container(
              width: 50,
              child:Text("PRICE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            Container(
              width: 50,
              child: Text("Amount", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
      SizedBox(height: 5),

    ],
  );
}  

Column items(String name, String qty, String rate, String amount, String unit, String discountType, String discountValue) {
  String symbol = (discountType=="Percentage") ? "%" : "₹"; 
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              child: Text(
                "$name",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              width: 50,
              child: Text(
                "$qty $unit",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                textAlign: TextAlign.right,
              ),
            ),
             Container(
              width: 50,
              child: Text(
                "$symbol ${discountValue.isEmpty ? '0' : discountValue}",
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
      SizedBox(height: 5),

    ],
  );
}
