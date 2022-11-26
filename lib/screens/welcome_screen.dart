import 'package:chatapp5/screens/registration_screen.dart';
import 'package:chatapp5/screens/signin_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/my_button.dart';

class WelcomeScreen extends StatelessWidget {
  static final String pageRoute = 'welcome_screen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 180,
              width: double.infinity,
              child: Image.asset('images/logo.png')),
          Text(
            'MessageMe pls, thank you!',
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Color(0xff2e386b)),
          ),
          MyButton(
            color: (Colors.yellow[900]!),
            onPressed: () {
              Navigator.pushNamed(context, SigninScreen.screenRoute);
            },
            title: 'Sign in',
          ),
          MyButton(
              color: Colors.blue[800]!,
              title: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.screenRoute);
              })
        ],
      ),
    );
  }
}
