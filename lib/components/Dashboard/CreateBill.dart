import 'package:billapp/components/Dashboard/selectItem.dart';
import 'package:billapp/module/partydata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class CreateBill extends StatefulWidget {
//   final  List<PartyData> partyget;
//   const CreateBill({super.key,
//                     required this.partyget,
//   });

//   @override
//   State<CreateBill> createState() => _CreateBillState();
// }

// class _CreateBillState extends State<CreateBill> {
//   DateTime today = DateTime.now();
  
//   @override
//   Widget build(BuildContext context) {
//   String formattedDate = DateFormat('d MMMM yyyy').format(today);
//    PartyData? selectedParty;
//     return Scaffold(
      
//        appBar: AppBar(
//         title: Text("Create Bill/Invoice ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
//         backgroundColor: Colors.white,
//        ),

//        body: Column(
//         children: [
//           Date(formattedDate),

//           selectPartyName(selectedParty),

//           Container(
//           padding: EdgeInsets.all(20),
//           width: 500,
//           color: Colors.white,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Items",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
//                   SizedBox(height: 20),


//                   // here 

//                     //----------------------------------------- Add ItemButton 
 
//                 SizedBox(
//                   width:  double.infinity,
//                   child: ElevatedButton(
                    
//                     style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 100, 33, 243).withOpacity(0.5)),
//                     // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                     // elevation: MaterialStateProperty.all<double>(0),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0), // Adjust border radius to make it more square-like
//                       ),
//                     ),
//                     ),
                    

//                     onPressed: (){
//                     // code 

//                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SelectItem(name:selectedParty!.name)));
//                   }, 
//                   child: Text("Add Items",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),)
                  
//                   ),
//                 )

                 
//               ],
//             ),


              
//           ),


         




//         ],
//        ),
//     );
//   }

//   Container selectPartyName(PartyData? selectedParty) {
//     late String name;
//     return Container(
//           margin: EdgeInsets.only(top: 10),
//           padding: EdgeInsets.all(20),
//           width: 500,
//           color: Colors.white,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Party Name",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
//               SizedBox(height: 10,),
              
//               // Try 
             
//                   Padding(
//       padding: const EdgeInsets.all(7),
//       child: Column(
//         children: [
//           DropdownButtonFormField<PartyData>(
//             value: selectedParty,
//             decoration: InputDecoration(
//               labelText: 'Select Party',
//               border: OutlineInputBorder(),
//             ),
//             items: widget.partyget.map((PartyData party) {
//               return DropdownMenuItem<PartyData>(
//                 value: party,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("${party.name}"),
//                     Text("(${party.type})"),
//                   ],
//                 ),
//               );
//             }).toList(),
//             onChanged: (PartyData? newValue) {
//               setState(() {
//                 selectedParty = newValue;
//                 // name = newValue.name;
//               });
//             },
//           ),
//           SizedBox(height: 20),

// // Text("${selectedParty}"),
//           // (selectedParty != null)
//           //     ? Text('Selected Party: ${selectedParty!.name}  (${selectedParty!.type})')
//           //     : Text('Not sected'),
//         ],
//       ),
//     ),

    

//               // Try 
//             ],
//           ),
//         );
//   }

//   Container Date(String formattedDate) {
//     return Container(
//           margin: EdgeInsets.only(top: 10),
//            padding: EdgeInsets.all( 20),

//           decoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Date",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),

//               Text('$formattedDate',style: TextStyle(fontSize: 20),),
//               // Text("26 june 2024",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),



              
//             ],
//           ),
//         );
//   }
// }

// class TodayDate extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) { 
//     DateTime today = DateTime.now();
//     String formattedDate = DateFormat('d MMMM yyyy').format(today);

//     return Text(
//       '$formattedDate',
//       style: TextStyle(fontSize: 20),
//     );
//   }
// }
















// new  





class CreateBill extends StatefulWidget {
  final List<PartyData> partyget;
  const CreateBill({
    super.key,
    required this.partyget,
  });

  @override
  State<CreateBill> createState() => _CreateBillState();
}

class _CreateBillState extends State<CreateBill> {
  DateTime today = DateTime.now();
  PartyData? selectedParty;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d MMMM yyyy').format(today);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Bill/Invoice",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Date(formattedDate),
          selectPartyName(),
          Container(
            padding: EdgeInsets.all(20),
            width: 500,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Items",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                // Add Item Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 100, 33, 243).withOpacity(0.5)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (selectedParty != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SelectItem(
                              party: selectedParty!,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Add Items",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container selectPartyName() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(20),
      width: 500,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Party Name",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(7),
            child: Column(
              children: [
                DropdownButtonFormField<PartyData>(
                  value: selectedParty,
                  decoration: InputDecoration(
                    labelText: 'Select Party',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.partyget.map((PartyData party) {
                    return DropdownMenuItem<PartyData>(
                      value: party,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${party.name}"),
                          Text("(${party.type})"),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (PartyData? newValue) {
                    setState(() {
                      selectedParty = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container Date(String formattedDate) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Date",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Text(
            '$formattedDate',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
