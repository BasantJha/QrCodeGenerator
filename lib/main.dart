import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;
import 'package:qr_code_generator/Apicall.dart';
import 'package:qr_code_generator/Encryprt/encrypt.dart';
import 'package:qr_code_generator/WebApi/getUserInfo.dart';
//import 'package:web/constants/constants.dart';
//import 'package:web/customView/palatte_Textstyle.dart';
//import 'package:web/responsive/responsive_screen_width.dart';
import 'Responsive.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:encrypt/encrypt.dart';

import 'WebApi/get_pod.dart';
import 'modelclass.dart';



void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff00BFFF)
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CJ Hub',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: Qr_login(title: 'CJ Hub'),
    );
  }
}

class Qr_login extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Qr_login({ required this.title}) : super();

  final String title;

  @override
  _Qr_login createState() => _Qr_login();
}

class _Qr_login extends State<Qr_login>
{

  final double circleRadius = 100.0;
  
  String saltkey = "1234";
  String secretkey = "AklaInfosys";
  String ID = " ";
  String Ip = " ";
  late get_prod _getprod;
  late getuserInfo userInfo;
  bool apicalled = false;




  // Get Random string for  Unique Id...............//
  getRandomString(int length) {
    const characters =
        '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }



  // get UniqueId in the form of encryption....//
  getUniqueId() async
  {
    DateTime now = DateTime.now();
    var datetime = "${now.hour}""{$now.second}";
    String id = getRandomString(10) + datetime + "Employer" + saltkey;
    ID = getEncryptedData(id);

    print("UniqueId $ID");

    final get_prod getprod = await Apicall.posting(
        ID,
        "basant",
        Ip
    );
    setState(() {
      _getprod = getprod;
      apicalled = true;
    });
  }


  // get Ip Address .............. //

  getIpAddress() async{
    Ip = await Ipify.ipv4();

    getUniqueId();
    print("Ip $Ip");
  }


  @override
  void initState() {
    super.initState();
    getIpAddress();


    Apicall.timerforUniqueId = Timer.periodic(Duration(seconds: 40), (timer) {
      setState(() async {
        getUniqueId();
        print("unquie ID :$ID");
        print("IP Address :$Ip");
        final get_prod getprod = await Apicall.posting(
            ID,
            "basant",
            Ip
        );
        setState(() {
          _getprod = getprod;
          apicalled = true;
        });
        if(apicalled){
          Apicall.timerforApi!.cancel();
        }
      });
    });

    // Apicall.timerforApi = Timer.periodic(Duration(seconds: 1), (timer) async{
    //   final get_prod getprod = await Apicall.posting(
    //       ID,
    //       "basant",
    //       Ip
    //   );
    //   setState(() {
    //     _getprod = getprod;
    //     apicalled = true;
    //   });
    //   if(apicalled){
    //    Apicall.timerforApi!.cancel();
    //   }
    // });

    Apicall.timerforisqrassigncheck = Timer.periodic(Duration(seconds: 10), (timer) async{
      final  getprod = await Apicall.togetuserInfo(
          ID,
          "L0MIewmxbN+zB/1aThhVXEEVRInhqzZ6Br67OOWNaKBwDwXxYQ7yBmjrU0wJuIq9",
      );
      setState(() {
        userInfo = getprod;
      });
    });
  }



  SafeArea mainFunction_UI(){
    return SafeArea(
        child:SingleChildScrollView(
            child: Column(
              children: [
                _buildContainer(),
              ],
            )
        )
    );
  }


  @override
  Widget build(BuildContext context)
  {


    return Scaffold(

        body: Responsive(
          mobile: mainFunction_UI(),

          tablet: Center(
            child: Container(
              // width: flutterWeb_tabletWidth,
              child: mainFunction_UI(),
            ),
          ),

          desktop: Center(
            child: Container(
              // width: flutterWeb_desktopWidth,
              child: mainFunction_UI(),
            ),
          ) ,
        )



    );
  }

  Widget _buildContainer()
  => Stack(
      children: <Widget>[

         Column(
          children: <Widget>[

             Container(
              height: MediaQuery.of(context).size.height * .3,
              color: Colors.grey[300],
              padding: EdgeInsets.only(left: 20,top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200.0,
                    height: 100.0,
                    child: Image.asset("loginapplogo.png",
                    ),
                  ),


                ],
              ),
            ),

             Container(
              height: MediaQuery.of(context).size.height * .1,
              color: Colors.grey[300],
            ),
          ],
        ),

        Center(
          child: Container(
            alignment: Alignment.topCenter,
            width: 600,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .2,
                right: 20.0,
                left: 20.0),
            child:
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[

                Padding(
                  padding:
                  EdgeInsets.only(top: circleRadius / 7.2, ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: circleRadius/7.2,),



                            Qr_Code(),

                            Heading_Text("To use CJ Hub on your computer"),

                            SpaceBtweenText(),
                            SpaceBtweenText(),

                            SubHeading_Text('1. Open CJ Hub App on your Phone'),

                            SpaceBtweenText(),

                            SubHeading_Text('2. Tap Menu and Select Linked Devices'),

                            SpaceBtweenText(),

                            SubHeading_Text('3. Point your phone to this screen to capture the code'),

                            SpaceBtweenText(),

                          ],
                        )
                    ),
                  ),
                ),



              ],
            ),
          ),
        )
      ]
  );

  Container Heading_Text(String name){
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child:  Text(name,textAlign: TextAlign.center, style: TextStyle(fontSize: 25.0,color: Colors.black),),
          ),
        ],
      ),
    );
  }

  Padding SubHeading_Text( String value){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[


          Expanded(
            flex: 1,
            child:  Container(
              // color: Colors.amberAccent,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.4,
              child: Text(value,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800]
                ),),
            ),),

        ],
      ),
    );
  }

  Center Qr_Code(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImage(
            data:
           ''' {
              "Unique_Id": "$ID",
              "Ip": "$Ip",
              "secretkey":"$secretkey"
             }''',
            size: 300,
          ),
        ],
      ),
    );
  }

  SizedBox SpaceBtweenText(){
    return SizedBox(
      height: 10,
    );
  }
}


