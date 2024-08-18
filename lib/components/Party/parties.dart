
import 'package:billapp/components/Party/partyProfile.dart';
import 'package:billapp/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:billapp/module/partydata.dart';
import 'package:billapp/components/Party/create.dart';

// Fetch Party Data
Future<List<PartyData>> fetchPartyData() async {
  // String baseurl='http://192.168.43.21:5000';
  String baseurl = Config.baseURL;
  // final response = await http.get(Uri.parse('http://10.0.2.2:5000/partydata'));
  final response = await http.get(Uri.parse('$baseurl/partydata'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => PartyData.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load party data');
  }
}


class Parties extends StatefulWidget {
  @override
  _PartiesState createState() => _PartiesState();
}

class _PartiesState extends State<Parties> {
  List<String> myTag = ["Both","Supplier", "Customer"];
  String selectedTag = "Both"; // Initially selected tag

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FilterTag(),
      body: FutureBuilder<List<PartyData>>(
        future: fetchPartyData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return NoTransaction();
          } else {
            List<PartyData> partyData = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  //  Center(child: Create_party()),
                  Column(
                    children: [
                     SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: 
                                (selectedTag=="Both")?
                                partyData
                                .map((data) => pData(data.id,data.name, data.balance.toString(), data.type,data.gstNumber,data.panNumber,data.contactNumber,data.task))
                                .toList():partyData
                              .where((data) => data.type == selectedTag)
                              .map((data) => pData(data.id, data.name, data.balance.toString(), data.type,data.gstNumber,data.panNumber,data.contactNumber,data.task))
                              .toList(),
                          ),
                        ),
                   
                    ],
                  ),
                  Center(child: Create_party()), // Positioned widget moved here
                ],
              ),
            );
          }
        },
      ),
    );
  }

// NoTransaction
  Container NoTransaction() {
    return Container(
      padding: EdgeInsets.all(50),
      child: Column(
        children: [
          
             Expanded(
               child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 100,
                    ),
                    Text(
                      "No Parties  found Create Your First Party By Clicking on Create party",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    )
                  ],
                ),
                           ),
             ),
        

          Center(child: Create_party()), 
        ],
      ),
    );
  }



  // Create Party Button
  ElevatedButton Create_party() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Create())).then((result){
                              if (result == true) {
                                // Refresh your previous page here
                                setState(() {
                                  // Code to refresh your page data, e.g., fetching new data from a server
                                });
                              }
                            });
        print('Button Pressed');
      },
      child: Text(
        'Create Party +',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Background color
      ),
    );
  }

  // Filter Method
  AppBar FilterTag() {
    return AppBar(
      
      toolbarHeight: 70,
      backgroundColor: Colors.white,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text("Filter By: "),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: myTag
                  .map((tag) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedTag == tag) {
                              // selectedTag=null;
                            }
                            selectedTag = tag;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, left: 15),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: selectedTag == tag
                                ? (tag == "Supplier" ? Colors.red :(tag == "Customer"? Colors.green:Colors.blue[300]))
                                : Color.fromARGB(23, 158, 158, 158),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 15,
                                color: selectedTag == tag ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display party data details
  Widget pData(int id,String name, String balance, String type,String gstNumber,String pan_number,String contact_number,String task) {
    // int key=id;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
        PartyProfile(
            id: id,
            name: name,
            balance: balance,
            type: type,
            gstNumber: gstNumber,
            panNumber: pan_number,
            contactNumber: contact_number,
            task:task,
        )))
        .then((result){
                              if (result == true) {
                                // Refresh your previous page here
                                setState(() {
                                  // Code to refresh your page data, e.g., fetching new data from a server
                                });
                              }
                            });;
      },
      child: Container(
        width: 350,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      Icon((type=="Supplier")?Icons.arrow_upward:Icons.arrow_downward,color: (type=="Supplier")?Colors.red:Colors.green,),
                      Text("₹ $balance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(type, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey)),
                  Text(" ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
