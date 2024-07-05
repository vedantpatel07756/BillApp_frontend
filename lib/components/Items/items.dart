import 'package:billapp/config.dart';
import 'package:billapp/module/itemdata.dart';
import 'package:flutter/material.dart';
import 'package:billapp/components/Items/createItems.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:billapp/components/Items/updateStock.dart';
import 'package:billapp/components/Items/itemData.dart';

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

Future<List<ItemData>> fetchItemData() async {
  // String baseurl='http://192.168.43.21:5000';
  String baseurl = Config.baseURL;
  final response = await http.get(Uri.parse('${baseurl}/items/get_item'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return jsonResponse.map((data) => ItemData.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load party data');
  }
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: FutureBuilder<List<ItemData>>(
        future: fetchItemData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<ItemData> items = snapshot.data!;
           
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      
                      children: items.map((item) => itemsLists(item.id,item.name,item.quantity,item.salesPrice,item.purchasePrice)).toList(),
                    ),
                  ),
                ),
                Center(child: CreateItemsBtn()),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  GestureDetector itemsLists(int id, String name,String quantity,String sales_price,String Purpase_price) {
    print(name);
    return  GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ItemsDatas(id:id,
                                                                  name:name,
                                                                  quantity:quantity,
                                                                  sales_price:sales_price,
                                                                  purchase_price:Purpase_price))).then((value){
                                                                    setState(() {
                                                                      
                                                                    });
                                                                  });
      },
      child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow:[BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),]
      
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(name,style: TextStyle(fontSize: 20),),
                            Row(children: [
                              Text("$quantity",style: TextStyle(fontSize: 20),),
                              Text("  QTY",style: TextStyle(fontSize: 15,color: Colors.grey),)
                            ],)
      
                          ],
                        ),
      
                        SizedBox(height: 10,),
      
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("Sales Price",style: TextStyle(fontSize: 15),),
                                Text("₹ $sales_price",style: TextStyle(fontSize: 20),),
      
                              ],
                            ),
                            Column(
                              children: [
                                Text("Purchase Price",style: TextStyle(fontSize: 15),),
                                Text("₹ $Purpase_price",style: TextStyle(fontSize: 20),),
      
                              ],),
                            
                            GestureDetector(
                              onTap: (){
                                // Update Stock COde 
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Updatestock(id:id,quantity:quantity)))
                                .then((result){
                                  if(result){
                                    setState(() {
                                    
                                  });
                                  }
                                 
                                });
                              },
                              child: Icon(Icons.format_list_bulleted,size: 35,color: Colors.blue,))
                          
                        ],)
                      ],
                    ),
                  ),
    );
  }

  ElevatedButton CreateItemsBtn() {
    return ElevatedButton(
      
        onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateItems())).then((result){
                              if (result == true) {
                                // Refresh your previous page here
                                setState(() {
                                  // Code to refresh your page data, e.g., fetching new data from a server
                                });
                              }
                            });
        }, 
        child: Text(
      'Add Item +',
      style: TextStyle(color: Colors.white),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // Background color
    ),);
  }
}











// import 'package:billapp/module/itemdata.dart';
// import 'package:flutter/material.dart';
// import 'package:billapp/components/Items/createItems.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class Items extends StatefulWidget {
//   const Items({Key? key}) : super(key: key);

//   @override
//   State<Items> createState() => _ItemsState();
// }

// class _ItemsState extends State<Items> {
//   late Future<List<ItemData>> futureItemData;

//   @override
//   void initState() {
//     super.initState();
//     futureItemData = fetchItemData(); // Initialize futureItemData here
//   }

//   Future<List<ItemData>> fetchItemData() async {
//     final response =
//         await http.get(Uri.parse('http://10.0.2.2:5000/items/get_item'));

//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((data) => ItemData.fromJson(data)).toList();
//     } else {
//       throw Exception('Failed to load item data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<ItemData>>(
//         future: futureItemData, // Use futureItemData here
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             List<ItemData> items = snapshot.data!;
//             return Column(
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child: Column(
//                       children: items.map((item) => itemsLists(item)).toList(),
//                     ),
//                   ),
//                 ),
//                 CreateItemsBtn(),
//               ],
//             );
//           } else {
//             return Center(child: Text('No data available'));
//           }
//         },
//       ),
//     );
//   }

//   Widget itemsLists(ItemData item) {
//     return Container(
//       margin: EdgeInsets.all(20),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.5),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 item.itemName ?? 'No Name', // Handle null name
//                 style: TextStyle(fontSize: 20),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     "${item.quantity ?? '0'}", // Handle null quantity
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   Text(
//                     "  QTY",
//                     style: TextStyle(fontSize: 15, color: Colors.grey),
//                   )
//                 ],
//               )
//             ],
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     "Sales Price",
//                     style: TextStyle(fontSize: 15),
//                   ),
//                   Text(
//                     "₹ ${item.salesPrice ?? '0'}", // Handle null salesPrice
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Text(
//                     "Purchase Price",
//                     style: TextStyle(fontSize: 15),
//                   ),
//                   Text(
//                     "₹ ${item.purchasePrice ?? '0'}", // Handle null purchasePrice
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   // Implement action for update stock
//                 },
//                 child: Icon(Icons.format_list_bulleted,
//                     size: 35, color: Colors.blue),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   ElevatedButton CreateItemsBtn() {
//     return ElevatedButton(
//       onPressed: () {
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => CreateItems()));
//       },
//       child: Text(
//         'Add Item +',
//         style: TextStyle(color: Colors.white),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }
// }
