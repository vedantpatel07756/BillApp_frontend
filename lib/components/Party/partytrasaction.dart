import 'dart:convert';

import 'package:billapp/components/Dashboard/convertToPDF.dart';
import 'package:billapp/config.dart';
import 'package:billapp/module/partydata.dart';
import 'package:flutter/material.dart';
import 'package:billapp/module/Invoicedata.dart';  
import 'package:http/http.dart' as http;




// Function to fetch invoices
Future<List<Invoice>> fetchInvoices(int partyId) async {
  final response = await http.get(Uri.parse('${Config.baseURL}/invoices/$partyId'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Invoice.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load invoices');
  }
}

// PartyTransaction widget
class PartyTransaction extends StatefulWidget {
  final int id;
  PartyData partyinfo;
  PartyTransaction({required this.id,
                    required this.partyinfo,
  
  });

  @override
  _PartyTransactionState createState() => _PartyTransactionState();
}

class _PartyTransactionState extends State<PartyTransaction> {
  late Future<List<Invoice>> futureInvoices;

  @override
  void initState() {
    super.initState();
    futureInvoices = fetchInvoices(widget.id);
  }

 @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(10),
      child: FutureBuilder<List<Invoice>>(
        future: futureInvoices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return NoTransaction();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return NoTransaction();
          } else {
            List<Invoice> invoices = snapshot.data!;
            return ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                Invoice invoice = invoices[index];
                return invoicedata(
                  widget.partyinfo,
                  invoice.id,
                  invoice.totalAmount,
                  invoice.invoiceDate,
                  invoice.status,
                );
              },
            ); 
          }
        },
      ),
    );
  }


 Container NoTransaction() {
    return Container(
      padding: EdgeInsets.all(50),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.calendar_month,
              size: 100,
            ),
            Text(
              "No Transaction found",
              style: TextStyle(color: Colors.grey, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
  
  GestureDetector invoicedata(PartyData partyinfo, int invoiceId, String amount, String date, String status) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Converttopdf(party: partyinfo, invoice_id: invoiceId))).then((value){
          if(value){
            Navigator.of(context).pop(true);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Invoice $invoiceId",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  "₹ $amount",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: (status == "Unpaid")
                        ? Color.fromARGB(66, 244, 67, 54)
                        : Color.fromARGB(49, 76, 175, 54),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: (status == "Unpaid") ? Colors.red : Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

