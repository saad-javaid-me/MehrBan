import 'package:donation_app/SignupANDLogin/LogInScreen.dart';
import 'package:donation_app/SignupANDLogin/SignUpScreen.dart';
import 'package:donation_app/colors/colors.dart';
import 'package:flutter/material.dart';

import '../Custom/custombutton.dart';


class AfterGetStartedScreen extends StatelessWidget{
  const AfterGetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SizedBox(
                width: double.infinity,
                height: double.infinity,
              child: Image.asset("assets/images/donationbg.png"),

            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Text("MehrBan",style: TextStyle(fontSize: 60 ,color: Colors.white,fontFamily: "dancing",fontWeight: FontWeight.bold))),
                  SizedBox(height: 50,),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CustomButton(onPressed: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInScreen()));
                    },
                      fcolor: Colors.white,
                      bcolor: FColors.barPurple,
                      bordercolor: FColors.barPurple,
                      text: "Sign In",
                      fontsize: 20,
                    ),
                  ),
                  CustomButton(onPressed: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                   },
                    fcolor: Colors.white,
                    bcolor: Colors.transparent,
                    bordercolor: Colors.white,
                    text: "Sign Up",
                    fontsize: 20,
                  )
                ],
              ),
            ),



          ],
        ),
      ),
    );
  }

}