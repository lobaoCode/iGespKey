import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
));

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String resultado = "Token: ";
  Future _scanQr() async{
    try {
      String qrLeitura = await BarcodeScanner.scan();
      setState(() {
        resultado = qrLeitura;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        resultado = "Sem permissão a camera";
      } else {
        setState(() {
          resultado = "Error: $e";
        });
      }
    } on FormatException {
      setState(() {
        resultado = "Retorne para tela inicial para refazer a leitura";
      });
    } catch (e) {
      setState(() {
          resultado = "Error: $e";
        });
    }
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("iGespKey"),
      ),
      body: Center(
        child: Text(
          resultado,
          style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanQr, 
        label: Text("Scan"),
        icon: Icon(Icons.camera_roll),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}



