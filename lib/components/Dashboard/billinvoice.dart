 import 'package:billapp/components/Dashboard/convertToPDF.dart';
import 'package:billapp/components/Dashboard/stockValue.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../module/partydata.dart';

 
//  GestureDetector invoiced(BuildContext context, PartyData party, int invoice_id, String value,String date,int party_id,String item_id,String unit_price ,String quantity ,String status){



//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Converttopdf(
//                         party:party,
//                         invoice_id:invoice_id,
//         ))).then((value){
          
//         });
//       },
//       child: Container(
      
//         width: 500,
//         margin: EdgeInsets.all(15),
//         padding: EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all()
      
//         ),
        
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("${party.name}",style: TextStyle( fontSize:20, fontWeight: FontWeight.w600),),
      
//                 Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         color: (status=="Unpaid")?const Color.fromARGB(106, 244, 67, 54):const Color.fromARGB(133, 76, 175, 54),
//                         borderRadius: BorderRadius.circular(5)
//                       ),
//                       child: Text("$status",style: TextStyle(color: (status=="Unpaid")?Colors.red:Colors.green, fontSize:10, fontWeight: FontWeight.w600),)),
//                     SizedBox(width: 10,),
//                     Text("${party.type}",style: TextStyle(color: Colors.grey, fontSize:15, fontWeight: FontWeight.w600),),
//                   ],
//                 ),
      
//               ],
//             ),
      
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Invoice #$invoice_id",style: TextStyle(color: Colors.grey,fontSize: 17, fontWeight: FontWeight.w600),),
      
//                 Text("₹ $value",style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),)
//               ],
//             ),
      
//             Container(
//               margin: EdgeInsets.only(top: 10),
//               decoration: BoxDecoration(
//                 border: BorderDirectional(top: BorderSide())
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("$date",style: TextStyle(color: Colors.black,fontSize: 17, fontWeight: FontWeight.w500),),
      
//                 Text("View Bill",style: TextStyle(color: Colors.blue, fontSize: 19, fontWeight: FontWeight.w600),)
      
//                 ],
//               ),
//             )
      
      
//           ],
//         )),
//     );
//   } 


GestureDetector invoiced(
  BuildContext context, 
  PartyData party, 
  int invoice_id, 
  String value, 
  String date, 
  int party_id, 
  String item_id, 
  String unit_price, 
  String quantity, 
  String status
) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Converttopdf(
        party: party,
        invoice_id: invoice_id,
      ))).then((value) {
        // Perform any actions on return if needed
      });
    },
    child: Container(
      width: 500,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${party.name}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: (status == "Unpaid") 
                        ? const Color(0xFFFFC1C1) 
                        : const Color(0xFFC8E6C9),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "$status",
                      style: TextStyle(
                        color: (status == "Unpaid") ? Colors.red : Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${party.type}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Invoice #$invoice_id",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "₹ $value",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey.shade300,
            height: 20,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$date",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "View Bill",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}