import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_application_vendor/screen/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    Timer(Duration(seconds: 5),(){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context)=> const LoginScreen(),
      ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary =  const Color(0xffC8B7A6);
    Color secondary= const Color(0xff2B3336);
    return  Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:const [
            Text('Bezaw',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30,
                  fontWeight: FontWeight.bold,
                letterSpacing: 2
              ),
            ),
            Text('Application Vendor',style: TextStyle(fontSize: 20),)
          ],
        ),
      ),
    );
  }
}


