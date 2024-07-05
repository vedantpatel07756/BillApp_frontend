// import 'dart:math';
import 'package:billapp/components/Party/partytrasaction.dart';
import 'package:billapp/components/Party/update.dart';
import 'package:billapp/config.dart';
import 'package:billapp/module/partydata.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// delete party 
Future<bool> deleteParty(int id) async {
  // String baseurl='http://192.168.43.21:5000';
  String baseurl = Config.baseURL;
  final url = '$baseurl/delete_party/$id'; // Use your API's URL

  final response = await http.delete(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    print('Party deleted successfully');
    return true;
  } else {
    print('Failed to delete party');
    return false;
  }
}

class PartyProfile extends StatefulWidget {

  final int id;
  final String name;
  final String balance;
  final String type;
  final String gstNumber;
  final String panNumber;
  final String contactNumber;
  final String task;

  const PartyProfile({super.key,
                      required this.id,
                     required  this.name,
                     required  this.balance,
                     required  this.type,
                     required  this.gstNumber,
                     required  this.panNumber,
                     required  this.contactNumber,
                     required this.task

  });




  @override
  State<PartyProfile> createState() => _PartyProfileState();
}




class _PartyProfileState extends State<PartyProfile> {
   List<String> tags=["Transaction", "Detail"];
    String selectedTag="Transaction";

  late PartyData partyinfo;



  @override
  void initState() {
    super.initState();
    // Convert balance from String to int
    int balance = int.tryParse(widget.balance) ?? 0;

    // Initialize partyinfo with the data from widget
    partyinfo = PartyData(
      id: widget.id,
      name: widget.name,
      contactNumber: widget.contactNumber,
      gstNumber: widget.gstNumber,
      panNumber: widget.panNumber,
      type: widget.type,
      balance: balance,
      task: widget.task, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bar(),
      body: Container(
        child: Column(
          children: [
            basicDetail(),
            selectTags(),
            Expanded( // Wrap in Expanded to give constraints
              child: Container(
                child: (selectedTag == "Detail")
                    ? otherdetails()
                    : PartyTransaction(id: widget.id,partyinfo: partyinfo,),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Container otherdetails() {
    return Container(
            width: 500,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                Text("Contact Number",style:TextStyle(fontSize: 18),),
                Row(
                  
                  children: [
                      Icon(Icons.call,color: Colors.blue,),
                      SizedBox(width: 10,),
                      Text(widget.contactNumber,style:TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)
              ],),

                SizedBox(height: 20,),
              Text("GST Number",style:TextStyle(fontSize: 18),),
              Text(widget.gstNumber,style:TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),

                SizedBox(height: 20,),
              Text("GST Number",style:TextStyle(fontSize: 18),),
              Text(widget.panNumber,style:TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)


                
                
              ],
            ));
  }


// SelectTag Between Transaction and Detail 

  SingleChildScrollView selectTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
          width: MediaQuery.of(context).size.width+30,
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
            
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: 
                     tags.map((tag){
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTag=tag;
                                  print("Button Pressed ${selectedTag}");
                                });
                              },
                              child: Container(
                                                      
                                width: 180,
                                decoration: BoxDecoration(
                                  border: BorderDirectional(bottom: BorderSide(color: (selectedTag==tag)?Color.fromARGB(255, 10, 21, 232):Colors.grey))
                                  // color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(tag,style: TextStyle(fontSize: 20,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: (selectedTag==tag)?Color.fromARGB(255, 10, 21, 232):Colors.grey,
                                                                    ),))),
                            ),
                          );
                    }).toList()
                
                   
                
              ),
            ),
          ),
    );
  }


// App Bar 
  AppBar bar() {
    return AppBar(
      // title:Text(widget.name),
      
      backgroundColor: Colors.white,
      title: GestureDetector(
        onVerticalDragDown: (details) {
          setState(() {
            print("Drage Down");
          });
        },
        child: SizedBox(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  // Update Querry 
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Update(
                    id: widget.id,
                    name: widget.name,
                    balance: widget.balance,
                    type: widget.type,
                    gstNumber: widget.gstNumber,
                    panNumber: widget.panNumber,
                    contactNumber: widget.contactNumber,
                  ) ))
                  .then((result){
                                if (result == true) {
                                  // Refresh your previous page here
                                  Navigator.of(context).pop(true);
                                  // setState(() {
                                  //   // Code to refresh your page data, e.g., fetching new data from a server
                                  // });

                                  
                                }
                              });;
                },
                
                child: Icon(Icons.create_rounded,color: Colors.blue,)
                
                ),
              SizedBox(width: 15,)
              ,
              GestureDetector(
                onTap: () async {
                  // Deleate Querry pass
                   bool isDeleted = await deleteParty(widget.id);
                  if (isDeleted) {
                    Navigator.pop(context, true); // Pass true if the party was deleted
                  } 
        
                },
                child: Icon(Icons.delete_sweep_outlined,size: 30,color: Colors.red,)
                )
            ],
          ) ,
        ),
      ),
    );
  }


// Detail  After App Bar 
  Container basicDetail() {
    return Container(
          width: MediaQuery.of(context).size.width+30,
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
                        color:Colors.white,
                        border: BorderDirectional(bottom: BorderSide(width: 0.5))
                        ),
          
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.name.toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                    
                    // Text(" PDF Statement >",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.red),),
                  ],
                ),
            
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹ ${widget.balance}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                    SizedBox(
                      height: 80,
            
                    ),
                    Text(" ${widget.type}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,),),
                  ],
                ),
              ],
            ),
          ),
        );
  }
}