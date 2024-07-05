import 'package:billapp/components/Items/itemData.dart';
import 'package:billapp/components/Items/items.dart';
import 'package:billapp/components/Items/updateStock.dart';
import 'package:billapp/config.dart';
import 'package:billapp/module/itemdata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockValue extends StatefulWidget {
 
  const StockValue({super.key});
   
  @override
  State<StockValue> createState() => _StockValueState();
}



class _StockValueState extends State<StockValue> {

   int totalStockValue=0;
  late Future<List<ItemData>> futureItemData;

  @override
  void initState() {
    super.initState();
    futureItemData = fetchItemData();
  }


 Future<List<ItemData>> fetchItemData() async {
    // String baseurl='http://192.168.43.21:5000';
       String baseurl = Config.baseURL;
    final response = await http.get(Uri.parse('$baseurl/items/get_item'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<ItemData> items = jsonResponse.map((data) => ItemData.fromJson(data)).toList();

      // Calculate total stock value
      int totalValue = 0;
      for (var item in items) {
        totalValue += int.tryParse(item.salesPrice)! * int.tryParse(item.quantity)!;
      }

      // Update state with the new total stock value
      setState(() {
        totalStockValue = totalValue;
      });

      return items;
    } else {
      throw Exception('Failed to load item data');
    }
  }


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: Text("Stock Value",style: TextStyle(fontWeight: FontWeight.w600),),
        backgroundColor: Colors.white,
      ),

      body: FutureBuilder<List<ItemData>>(
        future: futureItemData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<ItemData> items = snapshot.data!;
           
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                      children: [
                        totalValue(totalStockValue),
              
                        Textinfo(),
              
                        SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                // margin: EdgeInsets.all(10),
                child: Column(
                   children: items.map((item) => itemsLists(item.id,item.name,item.quantity,item.salesPrice,item.purchasePrice)).toList(),
                  
                ),
              ),
                        )
                      ],
                    ),
            );


          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }


GestureDetector itemsLists(int id, String name,String quantity,String sales_price,String Purpase_price) {
    // print(name);
    int value = int.tryParse(sales_price)!* int.tryParse(quantity)!;
    

    return  GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ItemsDatas(id:id,
                                                                  name:name,
                                                                  quantity:quantity,
                                                                  sales_price:sales_price,
                                                                  purchase_price:Purpase_price))).then((value){
                                                                    if(value){
                                                                      Navigator.of(context).pop(true);
                                                                    }

                                                                    setState(() {
                                                                      
                                                                    });
                                                                  });
      },
      child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
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
                          
                        ],),

                      SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            border: BorderDirectional(top:BorderSide()),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 3,vertical: 10),
                          // color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text("Value :",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),

                              Text("₹ ${value}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20), )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
    );
  }






  Container Textinfo() {
    return Container(
          width: 500,
          padding: EdgeInsets.all(10),
          decoration:BoxDecoration(
            color: Colors.white,
            border: BorderDirectional(top: BorderSide())
          ) ,
          child: Text("Items Available",style: TextStyle(color: Colors.blue,fontSize: 25,fontWeight: FontWeight.w600),),
        );
  }

  Container totalValue(int totalStockValue) {
    return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Center(child: Text("Total Stock Value", style:TextStyle(fontSize: 26,fontWeight: FontWeight.w600) ,)),

              SizedBox(height: 10,),
              Center(child: Text("₹ ${totalStockValue}",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: Colors.green),),)
            ],
          ),
        );
  }
}



