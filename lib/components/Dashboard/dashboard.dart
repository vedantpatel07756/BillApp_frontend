
import 'package:billapp/components/Dashboard/CreateBill.dart';
import 'package:billapp/components/Dashboard/billinvoice.dart';
import 'package:billapp/components/Dashboard/stockValue.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../module/partydata.dart';
import 'package:billapp/config.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}


Future<List<Map<String, dynamic>>> fetchInvoices() async {
  //  String baseurl='http://192.168.43.21:5000';
    String baseurl = Config.baseURL;
  final response = await http.get(Uri.parse('$baseurl/getinvoices'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);

    // print(jsonData);
    return List<Map<String, dynamic>>.from(jsonData);
  } else {
    throw Exception('Failed to load invoices');
  }
}


class _DashboardState extends State<Dashboard> {
  bool isTransactionData = true;
  int toCollect = 0;
  int toPay = 0;
   late List<PartyData> partypass;
  late Future<List<Map<String, dynamic>>> futureInvoices;

  @override
  void initState() {
    super.initState();
    print('initState called');
    fetchAndProcessPartyData();
    futureInvoices = fetchInvoices();
  }

  Future<void> fetchAndProcessPartyData() async {
    // String baseurl = 'http://192.168.43.21:5000';
      String baseurl = Config.baseURL;

    try {
      print("Fetching data...");
      final response = await http.get(Uri.parse('$baseurl/partydata'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<PartyData> partyDataList = jsonResponse.map((data) => PartyData.fromJson(data)).toList();

        partypass = partyDataList;
        int toCollectTemp = 0;
        int toPayTemp = 0;

        for (var partyData in partyDataList) {
          print("Check........${partyData.type}");
          if (partyData.type == 'Customer') {
            toCollectTemp += partyData.balance;
          } else if (partyData.type == 'Supplier') {
            toPayTemp += partyData.balance;
          }
        }

        setState(() {
          print("toCollect = $toCollectTemp, toPay = $toPayTemp");
          toCollect = toCollectTemp;
          toPay = toPayTemp;
        });
      } else {
        throw Exception('Failed to load party data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

 Future<void> _refreshInvoice() async {
    setState(() {
      // futureInvoice = fetchInvoice(widget.invoiceId);
      futureInvoices=fetchInvoices();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshInvoice,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    combinevalue(toCollect, toPay),
                    TransactionHeading(),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: futureInvoices,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return NoTransaction();
                        } else {
                          return Column(
                            children: snapshot.data!.map((invoice) {
                              var party = partypass.firstWhere((party) => party.id == invoice['party_id']);
                              return invoiced(
                                context,
                                party,
                                invoice['id'],
                                invoice['total_amount'],
                                invoice['invoice_date'],
                                invoice['party_id'],
                                invoice['item_id'],
                                invoice['unit_price'],
                                invoice['quantity'],
                                invoice['status'],
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.purple),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateBill(partyget: partypass),
                  ),
                );
              },
              child: Text(
                "BILL / Invoice",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Container invoiced(){

  //   return Container(child: Text("data"));
  // } 

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

  Container TransactionHeading() {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(width: 0.5),
          top: BorderSide(),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transactions",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Container combinevalue(int toCollect, int toPay) {
    return Container(
      width: 500,
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                //------------------------------------- To Collect
                Container(
                  width: 140,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(113, 42, 242, 85),
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹ $toCollect",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "To Collect",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                //------------------------------------- To Pay
                Container(
                  padding: EdgeInsets.all(20),
                  width: 140,
                  margin: EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(112, 242, 42, 42),
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹ $toPay",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "To Pay",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                //------------------------------------- Stock Value
                GestureDetector(
                  onTap:(){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StockValue()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: 150,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      // color: Color.fromARGB(112, 242, 42, 42),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Stock Value",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Value of Item >",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //------------------------------------- Stock Value
                Container(
                  padding: EdgeInsets.all(20),
                  width: 150,
                  margin: EdgeInsets.only(left: 20, top: 20),
                  decoration: BoxDecoration(
                    // color: Color.fromARGB(112, 242, 42, 42),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Value",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Value of Item >",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

