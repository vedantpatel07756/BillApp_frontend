

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:billapp/components/Dashboard/getPDF.dart';
import 'package:billapp/config.dart';
import 'package:billapp/module/itemdata.dart';
import 'package:billapp/module/partydata.dart';

class InvoiceScreen extends StatefulWidget {
  final PartyData party;
  final Map<ItemData, Map<String, dynamic>> selectedItems;
  final String Bussinessname,BussinessPhone,PaymentCash,PaymentOnline;


  const InvoiceScreen({
    Key? key,
    required this.party,
    required this.selectedItems,
    required this.Bussinessname,
    required this.BussinessPhone,
    required this.PaymentCash,
    required this.PaymentOnline,
  }) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class Discount {
  final String type; // Percentage or Fixed
  final double value; // Percentage value or Fixed amount

  Discount({
    required this.type,
    required this.value,
  });
}

class _InvoiceScreenState extends State<InvoiceScreen> {

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



 Future<bool> sendJsonData() async {
  List<Map<String, dynamic>> itemDetails = widget.selectedItems.entries.map((entry) {
    final ItemData item = entry.key;
    final int quantity = entry.value['count'];
    final int totalPrice = int.parse(item.salesPrice) * quantity;
    // final discount = calculateDiscount(
    //   Discount(type: entry.value['discountType'], value: double.parse(entry.value['discountValue'])),
    //   totalPrice,
    // );
     final discount = entry.value['discountValue'];
    return {
      'item_id': item.id,
      'quantity': quantity,
      'unit_price': item.salesPrice,
      'discount': discount,
      'discount_type': entry.value['discountType'], // Include discount type
    };
  }).toList();

  Map<String, dynamic> data = {
    'party_id': widget.party.id,
    'bussinessName':widget.Bussinessname,
    'bussinessPhone':widget.BussinessPhone,
    'paymentCash':widget.PaymentCash,
    'paymentOnline':widget.PaymentOnline,
    'invoice_date': currentDate.toString(),
    'total_amount': totalAmount.toString(),
    'status': 'Unpaid',
    'item': itemDetails,
  };

  String jsonData = jsonEncode(data);

  final response = await http.post(
    Uri.parse('${Config.baseURL}/postinvoices'),
    headers: {"Content-Type": "application/json"},
    body: jsonData,
  );

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data saved to database")));
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Getpdf(party: widget.party, selectedItems: widget.selectedItems)));
    return true;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save data to database")));
    return false;
  }
}
  @override
  Widget build(BuildContext context) {
    int balance = totalAmount-(int.tryParse(widget.PaymentOnline ?? '0')! + int.tryParse(widget.PaymentCash ?? '0')!);
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                  ),
                  onPressed: () async{
                    bool check = await  sendJsonData();

                    if(check){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Getpdf(party: widget.party, selectedItems: widget.selectedItems,bussinessName:widget.Bussinessname,bussinessPhone:widget.BussinessPhone,PaymentCash:widget.PaymentCash,PaymentOnline:widget.PaymentOnline)));
                    }
                   
                    
                  },
                  child: Text(
                    "Save Data and Generate PDF >",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
                            "${widget.Bussinessname}",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'Times'),
                          ),
                          Text(
                            "Mobile: ${widget.BussinessPhone}",
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
                              Text("Mobile No.", style: TextStyle(fontSize: 10)),
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
}

