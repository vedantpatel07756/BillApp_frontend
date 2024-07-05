// import 'package:billapp/components/Profile.dart/check.dart';
import 'package:billapp/components/Profile.dart/invoiceSet.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 500,
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               Container(
                      width: 100, // Make sure the width and height are the same
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Set the shape to circle
                        image: DecorationImage(
                          image: AssetImage("assest/image/vedant.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                Text("Shree Samarth Trading",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                Text("Mobile No: 9324195020",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),)
              ],
            ),
          ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Setting",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.blue),),
            ),


            Container(
              width: 500,
              decoration: BoxDecoration(
                color: Colors.white,

              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> InvoiceSettingsScreen(invoiceSet: invoiceSet)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Bussiness Setting " ,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400,),),
                          Icon(Icons.arrow_right_outlined),
                        ],
                      ),
                    ),
                  ),
                    Container(height: 1,color: Colors.blueGrey,),
                   Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Invoice Setting " ,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400,),),
                        Icon(Icons.arrow_right_outlined),
                      ],
                    ),
                  )
                ],
              ),
            )


        ],
      ),
    );
  }
}