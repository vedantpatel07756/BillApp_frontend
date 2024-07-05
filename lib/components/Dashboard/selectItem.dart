
// import 'dart:convert';
// import 'package:billapp/components/Dashboard/invoiceScreen.dart';
// import 'package:http/http.dart' as http;
// import 'package:billapp/module/itemdata.dart';
// import 'package:billapp/module/partydata.dart';
// import 'package:flutter/material.dart';

// class SelectItem extends StatefulWidget {
//   final PartyData party;

//   const SelectItem({super.key, required this.party});

//   @override
//   State<SelectItem> createState() => _SelectItemState();
// }

// Future<List<ItemData>> fetchItemData() async {
//   final response = await http.get(Uri.parse('http://10.0.2.2:5000/items/get_item'));

//   if (response.statusCode == 200) {
//     List jsonResponse = json.decode(response.body);
//     print(jsonResponse);
//     return jsonResponse.map((data) => ItemData.fromJson(data)).toList();
//   } else {
//     throw Exception('Failed to load party data');
//   }
// }

// class _SelectItemState extends State<SelectItem> {
//   Map<int, int> counters = {};

//   void add(int id, int stock) {
//     setState(() {
//       if (counters[id]! < stock) {
//         counters[id] = counters[id]! + 1;
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Stock Limit reached")),
//         );
//       }
//     });
//   }

//   void remove(int id) {
//     setState(() {
//       if (counters[id]! > 0) {
//         counters[id] = counters[id]! - 1;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Select Items"),
//       ),
//       body: FutureBuilder<List<ItemData>>(
//         future: fetchItemData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             List<ItemData> items = snapshot.data!;
//             items.forEach((item) {
//               if (!counters.containsKey(item.id)) {
//                 counters[item.id] = 0;
//               }
//             });
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView(
//                     children: items.map((item) {
//                       return ItemContainer(
//                         id: item.id,
//                         name: item.name,
//                         quantity: item.quantity,
//                         salesPrice: item.salesPrice,
//                         purchasePrice: item.purchasePrice,
//                         counter: counters[item.id]!,
//                         add: () => add(item.id, int.tryParse(item.quantity) ?? 0),
//                         remove: () => remove(item.id),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Handle the generation of the bill here
//                       print("Generate Bill for ${widget.party.name}");

//                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>InvoiceScreen(party: widget.party)));

//                     },
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                         Color.fromARGB(255, 100, 33, 243).withOpacity(0.5),
//                       ),
//                       foregroundColor: MaterialStateProperty.all<Color>(
//                         Colors.white,
//                       ),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                     ),
//                     child: Text(
//                       "Generate Bill / Invoice PDF",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return Center(child: Text('No items found'));
//           }
//         },
//       ),
//     );
//   }
// }



// class ItemContainer extends StatelessWidget {
//   final int id;
//   final String name;
//   final String quantity;
//   final String salesPrice;
//   final String purchasePrice;
//   final int counter;
//   final VoidCallback add;
//   final VoidCallback remove;

//   const ItemContainer({
//     Key? key,
//     required this.id,
//     required this.name,
//     required this.quantity,
//     required this.salesPrice,
//     required this.purchasePrice,
//     required this.counter,
//     required this.add,
//     required this.remove,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     int stock = int.tryParse(quantity) ?? 0;

//     return Container(
//       width: 500,
//       margin: EdgeInsets.all(20),
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 name,
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Stock: $stock Bags",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 17,
//                     fontWeight: FontWeight.w400),
//               ),
//               // Counter
//               Container(
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: remove,
//                       child: Container(
//                         decoration: BoxDecoration(border: Border.all()),
//                         child: Icon(
//                           Icons.remove,
//                           color: Color.fromARGB(255, 44, 33, 243),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                     Text(
//                       "$counter",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                     ),
//                     SizedBox(width: 5),
//                     GestureDetector(
//                       onTap: add,
//                       child: Container(
//                         decoration: BoxDecoration(border: Border.all()),
//                         child: Icon(
//                           Icons.add,
//                           color: Color.fromARGB(255, 44, 33, 243),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


// Try New ----------------------------------------------------


import 'dart:convert';
import 'package:billapp/components/Dashboard/invoiceScreen.dart';
import 'package:billapp/config.dart';
import 'package:http/http.dart' as http;
import 'package:billapp/module/itemdata.dart';
import 'package:billapp/module/partydata.dart';
import 'package:flutter/material.dart';

class SelectItem extends StatefulWidget {
  final PartyData party;

  const SelectItem({super.key, required this.party});

  @override
  State<SelectItem> createState() => _SelectItemState();
}

Future<List<ItemData>> fetchItemData() async {
  // String baseurl='http://192.168.43.21:5000';
     String baseurl = Config.baseURL;
  final response = await http.get(Uri.parse('$baseurl/items/get_item'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return jsonResponse.map((data) => ItemData.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load party data');
  }
}





class _SelectItemState extends State<SelectItem> {

       // Get the current date and due date







  Map<int, int> counters = {};
  List<ItemData> items = [];

  void add(int id, int stock) {
    setState(() {
      if (counters[id]! < stock) {
        counters[id] = counters[id]! + 1;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Stock Limit reached")),
        );
      }
    });
  }

  void remove(int id) {
    setState(() {
      if (counters[id]! > 0) {
        counters[id] = counters[id]! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Items"),
      ),
      body: FutureBuilder<List<ItemData>>(
        future: fetchItemData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            items = snapshot.data!;
            items.forEach((item) {
              if (!counters.containsKey(item.id)) {
                counters[item.id] = 0;
              }
            });
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: items.map((item) {
                      return ItemContainer(
                        id: item.id,
                        name: item.name,
                        quantity: item.quantity,
                        salesPrice: item.salesPrice,
                        purchasePrice: item.purchasePrice,
                        counter: counters[item.id]!,
                        add: () => add(item.id, int.tryParse(item.quantity) ?? 0),
                        remove: () => remove(item.id),
                      );
                    }).toList(),
                  ),
                ),


                // Generate Button 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Map<ItemData, int> selectedItems = {};
                      items.forEach((item) {
                        if (counters[item.id]! > 0) {
                          selectedItems[item] = counters[item.id]!;
                        }
                      });


                      
                    


                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InvoiceScreen(
                            party: widget.party,
                            selectedItems: selectedItems,
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 100, 33, 243).withOpacity(0.5),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Generate Bill / Invoice PDF",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No items found'));
          }
        },
      ),
    );
  }
}

class ItemContainer extends StatelessWidget {
  final int id;
  final String name;
  final String quantity;
  final String salesPrice;
  final String purchasePrice;
  final int counter;
  final VoidCallback add;
  final VoidCallback remove;

  const ItemContainer({
    Key? key,
    required this.id,
    required this.name,
    required this.quantity,
    required this.salesPrice,
    required this.purchasePrice,
    required this.counter,
    required this.add,
    required this.remove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int stock = int.tryParse(quantity) ?? 0;

    return Container(
      width: 500,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Stock: $stock Bags",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
              ),
              // Counter
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: remove,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Icon(
                          Icons.remove,
                          color: Color.fromARGB(255, 44, 33, 243),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "$counter",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: add,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Icon(
                          Icons.add,
                          color: Color.fromARGB(255, 44, 33, 243),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
