import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:igespkey/componentes/CircleTimer.dart';
import 'package:otp/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
));

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String resultado = " - ";
  Timer timer;
  String key = "";
  int timeCurrent = 0;
  SharedPreferences prefs;
  
  @override
  void initState(){
    super.initState();
    loadKey();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
    ]);
  }

  loadKey() async {
    prefs =  await SharedPreferences.getInstance();
    setState(() {
      key = prefs.get('token');
      if (key == null) {
        key = "";
      } else {
        resultado = OTP.generateTOTPCodeString(key, new DateTime.now().millisecondsSinceEpoch);
        _startTimer();
      } 
    });
  }

  Future _startTimer () async{
    if (key != "") {
        timeCurrent = 1;
        timer = new Timer.periodic(
        Duration(milliseconds: 1),
        (Timer timer1) => setState( () {
          timeCurrent++;
          if (timeCurrent == 31000){
            timeCurrent = 0;
            resultado = OTP.generateTOTPCodeString(key, new DateTime.now().millisecondsSinceEpoch);
          }
        },),
      );
    }
  }

  Future _scanQr() async {
    try {
      String qrLeitura = await BarcodeScanner.scan();
      prefs =  await SharedPreferences.getInstance();
      setState(() {
        key = qrLeitura;
        resultado = OTP.generateTOTPCodeString(key, new DateTime.now().millisecondsSinceEpoch);
        prefs.setString('token', qrLeitura);
      });
      _startTimer();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
         resultado = "Sem permissão a camera";
        });
      } else {
        setState(() {
          resultado = "Error: $e";
        });
      }
    } on FormatException {
      setState(() {
        resultado = "QrCode inválido";
      });
    } catch (e) {
      setState(() {
          resultado = "Error: $e";
        });
    }
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:Text(""),
        backgroundColor: Colors.black12,
        bottom: PreferredSize(
          child: Image.asset(
              'assets/logo_iToken.png', 
              fit: BoxFit.cover,
              height: 200,
              width: 200
            ), 
          preferredSize: Size.fromHeight(150.0),
        ),
      ),
      body: Center(
        child: CustomPaint(
          foregroundPainter: CircleTimer(timeCurrent),
            child:Container(
              width: 200,
              height: 200,
              child: Center(
                child:Text(
                  resultado,
                  style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)
                )
              )
            )
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanQr, 
        label: Text("Scan"),
        icon: Icon(Icons.camera),
        backgroundColor: Colors.black45,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}



