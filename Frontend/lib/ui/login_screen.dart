
import 'package:covigenix/ui/fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:covigenix/ui/otp.dart';

import '../helper.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>{
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.green,
                  Colors.green,
                  Colors.green,
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(1, Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),)),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),

                        FadeAnimation(1.4, Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(5.0),
                                child: Theme(
                                  data: ThemeData(
                                    primarySwatch: Colors.green,
                                  ),
                                  child: TextField(
                                    //cursorColor: Colors.green,
                                    decoration: InputDecoration(
                                        hintText: "Phone number",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        //focusColor: Colors.green,
                                        //hoverColor: Colors.green,
                                        //border: InputBorder.none
                                    ),
                                    maxLength: 10,
                                    keyboardType: TextInputType.number,
                                    controller: _controller,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        SizedBox(height: 10,),
                        SizedBox(height: 10,),
                        FadeAnimation(1.6, Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              //color: Colors.blue
                              color: Colors.green
                          ),
                          child: Center(
                            child:TextButton(
                              onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => OTPScreen(_controller.text, Helper.TYPE_PATIENT)));
                              },
                              child: Text("Login as a Patient", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            )
                          ),

                        )),
                        SizedBox(height: 20,),
                        SizedBox(height: 20,),
                    FadeAnimation(1.6, Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          //color: Colors.blue
                          color: Colors.green
                      ),
                      child: Center(
                        child:TextButton(
                          onPressed: (){
                                   Navigator.of(context).pushReplacement(MaterialPageRoute(
                                   builder: (context) => OTPScreen(_controller.text, Helper.TYPE_PROVIDER)));
                          },
                          child: Text("Login as a Service Provider", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        )
                      )

                    )),
                        Container(
                          margin: EdgeInsets.all(20.0),
                          padding: EdgeInsets.all(12.0),
                          height: 70,
                          decoration: BoxDecoration(
                            image:DecorationImage(
                              image:AssetImage("assets/images/logo.png",),
                              fit: BoxFit.fitHeight
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
            )
          ],
        ),


      ),
    );
  }
}
/*/class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Center(

                  child: Text(
                    'Please provide your Phone Number',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40, right: 10, left: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    prefix: Padding(
                      padding: EdgeInsets.all(4),
                    ),
                  ),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: _controller,
                ),
              )
            ]),
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            // ignore: deprecated_member_use
            child: FlatButton(
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => OTPScreen(_controller.text, Helper.TYPE_PATIENT)));
              },
              child: Text(
                'Proceed as Patient',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            // ignore: deprecated_member_use
            child: FlatButton(
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => OTPScreen(_controller.text, Helper.TYPE_PROVIDER)));
              },
              child: Text(
                'Proceed as Provider',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}*/
