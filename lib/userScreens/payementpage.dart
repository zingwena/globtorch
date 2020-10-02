/*import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paynow/paynow.dart';
import 'dart:math';
import 'dart:async';

class Payement extends StatefulWidget {
  @override
  _PayementState createState() => _PayementState();
}

class _PayementState extends State<Payement> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  String _status = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.withOpacity(.7),
        title: Text("Course payement"),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Container(
              color: Colors.greenAccent.withOpacity(.5),
            
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Ecocash Flutter Demo:',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                      color: Colors.white
                    )
                  ),
                  cursorColor:Colors.white ,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,

                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "5.00",
                    hintStyle: TextStyle(color:Colors.white),
                    icon: Icon(Icons.monetization_on)
                  ),
                  keyboardType: TextInputType.number,
                  controller: _amountController,

                ),
                SizedBox(height: 15,),
                ArgonTimerButton(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.45,
                  minWidth: MediaQuery.of(context).size.width * 0.30,
                  highlightColor: Colors.transparent,
                  highlightElevation: 0,
                  roundLoadingShape: false,
                  onTap: (startTimer, btnState) {
                    if (btnState == ButtonState.Idle) {
                      startTimer(15);
                    }



                    Paynow paynow = Paynow(integrationKey: "960ad10a-fc0c-403b-af14-e9520a50fbf4", integrationId: "6054", returnUrl: "http://google.com", resultUrl: "http://google.co");
                    Payment payment = paynow.createPayment("user", "user@email.com");

                    payment.add("Banana", 1.9);


                    // Initiate Mobile Payment
                    paynow.sendMobile(payment, _phoneController.text ?? "")
                      ..then((InitResponse response){
                        // display results
                        print(response());

                        // Check Transaction status from pollUrl
                        paynow.checkTransactionStatus(response.pollUrl)
                          ..then((StatusResponse status){
                            print(status.paid);
                          });
                      });
                  },

                  child: Text(
                    "PAY",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  loader: (timeLeft) {
                    return Text(
                      "Wait | $timeLeft",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    );
                  },
                  borderRadius: 5.0,
                  color: Colors.greenAccent ,
                  elevation: 0,
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
        ]));
  }
}
*/
