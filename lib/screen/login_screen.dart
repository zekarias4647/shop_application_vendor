import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:shop_application_vendor/screen/landing_screen.dart';
import 'package:shop_application_vendor/screen/registration_screen.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context, snapshot) {
          if(!snapshot.hasData){
            return SignInScreen(
              headerBuilder: (context, constrints, _){
                return   Padding(
                  padding:  EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Center(
                    child: Column(
                      children: const [
                        Text(
                          'Bezaw',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                        Text('Application Vendor',style: TextStyle(fontSize: 20),)
                      ],
                    ),
                  ),
                ),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'Welcome to Bezaw Application-vendor! Please sign in to continue.'
                        : 'Welcome to Bezaw Application-vendor! Please create an account to continue',
                  ),
                );
              },
              footerBuilder: (context, _) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'By signing in, you agree to our terms and conditions.',
                    style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,
                  ),
                );
              },
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(clientId: '1:1066251027809:android:c6498802341c4067e0b120'),
                PhoneProviderConfiguration()
              ],
            );
          }

          return const LandingScreen();
        });
  }
}
