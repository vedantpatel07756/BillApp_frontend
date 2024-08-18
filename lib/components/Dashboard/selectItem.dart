


import 'dart:convert';
import 'package:billapp/components/Dashboard/invoiceScreen.dart';
import 'package:billapp/config.dart';
import 'package:http/http.dart' as http;
import 'package:billapp/module/itemdata.dart';
import 'package:billapp/module/partydata.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectItem extends StatefulWidget {
  final PartyData party;

  const SelectItem({super.key, required this.party});

  @override
  State<SelectItem> createState() => _SelectItemState();
}



class _SelectItemState extends State<SelectItem> {
  Map<int, int> counters = {};
  Map<int, String> discountTypes = {};
  Map<int, String> discountValues = {};
  List<ItemData> items = [];
  String BussinessName = " ";
  String PhoneNo=" ";

Future<List<ItemData>> fetchItemData() async {
     final prefs = await SharedPreferences.getInstance();
    BussinessName = prefs.getString('BussinessName')?? "Shree Samarth Trading";
    PhoneNo =prefs.getString('PhoneNo')??"9284590263";
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


  void add(int id, int stock) {
    setState(() {
      if (widget.party.type == "Customer") {
        print("Party Type : ${widget.party.type}");
        if (counters[id]! < stock) {
          counters[id] = counters[id]! + 1;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Stock Limit reached")),
          );
        }
      } else {
        print("Party Type : ${widget.party.type}");
        counters[id] = counters[id]! + 1;
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

  late Future<List<ItemData>>  futuredata ;

void refresh() async {
  final prefs = await SharedPreferences.getInstance();
  final businessName = prefs.getString('BussinessName') ?? "Shree Samarth Trading";
  final phoneNo = prefs.getString('PhoneNo') ?? "9284590263";

  setState(() {
    BussinessName = businessName;
    PhoneNo = phoneNo;
  });
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final prefs = await SharedPreferences.getInstance();
    // BussinessName = prefs.getString('BussinessName')?? "Shree Samarth Trading";
    // PhoneNo =prefs.getString('PhoneNo')??"9284590263";
    
    futuredata=fetchItemData();



  }
List<String> mode=["Cash","Online","cheque"];
  String selectedMode="Cash";

 void showPaymentMethodSheet(BuildContext context, TextEditingController cashController, TextEditingController onlineController,List<ItemData> items) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Text(
                    "Enter Payment Method",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: (){
                    Navigator.pop(context); // Close the bottom sheet without saving
                  }, child: Text("X",style: TextStyle(color: Colors.red,fontSize: 25),))
              //      ElevatedButton(
              //   onPressed: () {
              //     Navigator.pop(context); // Close the bottom sheet without saving
              //   },
              //   child: Text("X",style: TextStyle(color: Colors.red),),
              // ),
                ],
              ),
              SizedBox(height: 20),
              Text("Amount Received By Cash"),
              TextField(
                controller: cashController,
                decoration: InputDecoration(
                  hintText: 'Enter amount received by cash',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Text("Amount Received By Online"),
              TextField(
                controller: onlineController,
                decoration: InputDecoration(
                  hintText: 'Enter amount received online',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),

               Buttonforinvoice(items, context,cashController,onlineController),
             
              SizedBox(height: 20),
             
            ],
          ),
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
  

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
    final TextEditingController cashController = TextEditingController();
      final TextEditingController OnlineController = TextEditingController();

    
  return Scaffold(
      appBar: AppBar(
        title: Text("Select Items"),
      ),
      body: FutureBuilder<List<ItemData>>(
        future: futuredata,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<ItemData> items = snapshot.data!;
            items.forEach((item) {
              if (!counters.containsKey(item.id)) {
                counters[item.id] = 0;
              }
              if (!discountTypes.containsKey(item.id)) {
                discountTypes[item.id] = 'Percentage';
              }
              if (!discountValues.containsKey(item.id)) {
                discountValues[item.id] = '';
              }
            });
            return Column(
              children: [
                BussinessDetail(context, nameController, phoneController),

                // Paymentmethod(cashController, OnlineController),
             
                ItemsDetail(items),

                // Button 


                     // Payment Method Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showPaymentMethodSheet(context,cashController,OnlineController,items);
                    },
                    child: Text("Enter Payment Detail",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,),),
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

  Padding Buttonforinvoice(List<ItemData> items, BuildContext context, TextEditingController cashController, TextEditingController onlineController) {
    return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Map<ItemData, Map<String, dynamic>> selectedItems = {};
                    items.forEach((item) {
                      if (counters[item.id]! > 0) {
                        selectedItems[item] = {
                          'count': counters[item.id]!,
                          'discountType': discountTypes[item.id] ?? "Percentage",
                          'discountValue': discountValues[item.id] ?? 0
                        };
                      }
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => InvoiceScreen(
                          party: widget.party,
                          selectedItems: selectedItems,
                          Bussinessname: BussinessName,
                          BussinessPhone: PhoneNo,
                          PaymentCash:cashController.text,
                          PaymentOnline:onlineController.text,

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
              );
  }

  Expanded ItemsDetail(List<ItemData> items) {
    return Expanded(
                child: ListView(
                  children: items.map((item) {
                    return ItemContainer(
                      party: widget.party,
                      id: item.id,
                      name: item.name,
                      quantity: item.quantity,
                      salesPrice: item.salesPrice,
                      purchasePrice: item.purchasePrice,
                      unit: item.unit,
                      counter: counters[item.id]!,
                      discountType: discountTypes[item.id]!,
                      discountValue: discountValues[item.id]!,
                      add: () => add(item.id, int.tryParse(item.quantity) ?? 0),
                      remove: () => remove(item.id),
                      onCounterChanged: (value) {
                        setState(() {
                          counters[item.id] = value;
                        });
                      },
                      onDiscountTypeChanged: (type) {
                        setState(() {
                          discountTypes[item.id] = type;
                        });
                      },
                      onDiscountValueChanged: (value) {
                        setState(() {
                          discountValues[item.id] = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              );
  }

  Container BussinessDetail(BuildContext context, TextEditingController nameController, TextEditingController phoneController) {
    return Container(
                color: Colors.white,
                width: double.infinity, // Make it take full width
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        editButton(context, nameController, phoneController),
                      ],
                    ),
                    Text(
                      "Business Name: $BussinessName",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Business PhoneNo: $PhoneNo",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
  }

  Padding Paymentmethod(TextEditingController cashController, TextEditingController OnlineController) {
    return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: double.infinity, // Make it take full width
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical, // Adjusted for vertical scroll
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Mode",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 20),
                        Text("Amount Received By Cash"),
                        TextField(
                          controller: cashController,
                          decoration: InputDecoration(
                            hintText: 'Enter amount received by cash',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        Text("Amount Received By Online"),
                        TextField(
                          controller: OnlineController,
                          decoration: InputDecoration(
                            hintText: 'Enter amount received online',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }

   GestureDetector editButton(BuildContext context, TextEditingController nameController, TextEditingController phoneController) {
    return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.black45,
                  title: Text('Edit Business Info', style: TextStyle(color: Colors.white)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Business Name',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      TextField(
                        controller: phoneController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async{
                        // Handle the save logic here
                        String newName = nameController.text;
                        String newPhone = phoneController.text;
      
                                         final prefs = await SharedPreferences.getInstance();
                                              await prefs.setString('BussinessName', newName)  ;
                                              await prefs.setString('PhoneNo', newPhone)  ;
      
                                 
                     refresh();
      
                        // You can update the state or call a function to save these values
      
                        Navigator.of(context).pop();
                      },
                      child: Text('Save', style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.edit, color: Colors.blue, size: 20),
        );
  }


}

class ItemContainer extends StatelessWidget {
  final PartyData party;
  final int id;
  final String name;
  final String quantity;
  final String salesPrice;
  final String purchasePrice;
  final String unit;
  final int counter;
  final String discountType;
  final String discountValue;
  final VoidCallback add;
  final VoidCallback remove;
  final ValueChanged<int> onCounterChanged;
  final ValueChanged<String> onDiscountTypeChanged;
  final ValueChanged<String> onDiscountValueChanged;

  const ItemContainer({
    Key? key,
    required this.party,
    required this.id,
    required this.name,
    required this.quantity,
    required this.salesPrice,
    required this.purchasePrice,
    required this.unit,
    required this.counter,
    required this.discountType,
    required this.discountValue,
    required this.add,
    required this.remove,
    required this.onCounterChanged,
    required this.onDiscountTypeChanged,
    required this.onDiscountValueChanged,
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
                "Stock: $stock ${unit}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // Counter
              Row(
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
                  Container(
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onChanged: (value) {
                        int? newCounter = int.tryParse(value);
                        if (newCounter != null) {
                          if (party.type == "Customer") {
                            if (newCounter <= stock) {
                              onCounterChanged(newCounter);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Stock Limit reached")),
                              );
                            }
                          } else {
                            onCounterChanged(newCounter);
                          }
                        }
                      },
                      controller: TextEditingController(text: '$counter'),
                    ),
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
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              // Discount Type Dropdown
              Expanded(
                child: DropdownButton<String>(
                  value: discountType,
                  onChanged: (String? newValue) {
                    onDiscountTypeChanged(newValue!);
                  },
                  items: ['Percentage', 'Rupees'].map((String discountType) {
                    return DropdownMenuItem<String>(
                      value: discountType,
                      child: Text(discountType),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 10),
              // Discount Input
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Discount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    onDiscountValueChanged(value);
                  },
                  controller: TextEditingController(text: discountValue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
