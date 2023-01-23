import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_application_vendor/screen/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  Color primary =  const Color(0xffC8B7A6);
  Color secondary= const Color(0xff2B3336);

  return Scaffold(
    backgroundColor: secondary,
    body: Center(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Your application sent to Shop App Administrators\ Admins will contact you soon!',
              style: TextStyle(color: primary, fontSize: 22),
                    textAlign: TextAlign.center,),
          SizedBox(height: 20,),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: primary, //<-- SEE HERE
            ),
              child: Text('Sign Out',style: TextStyle(color: secondary),),
              onPressed: (){
              FirebaseAuth.instance.signOut().then((value){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen(),
                  )
                );
              });
              }, )
        ],
      ),
    ),
    ),
    );
  }
}
