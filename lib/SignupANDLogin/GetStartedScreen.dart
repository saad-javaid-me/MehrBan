import 'package:donation_app/Custom/custombutton.dart';
import 'package:donation_app/SignupANDLogin/AfterGetStartedScreen.dart';
import 'package:donation_app/colors/colors.dart';
import 'package:flutter/material.dart';


class GetStartedScreen extends StatelessWidget{
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
              width: double.infinity,
              height: double.infinity,
            child: Image.asset("assets/images/donationbg.png"),
              ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("MehrBan",style: TextStyle(fontSize: 60 ,color: Colors.white,fontFamily: "dancing",fontWeight: FontWeight.bold)),
              SizedBox(height: 60,),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Align( alignment: Alignment.bottomCenter,
                    child: CustomButton(text: "Get Started",onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AfterGetStartedScreen()));
                    },
                      fcolor: Colors.white,
                      bcolor: FColors.barPurple,
                      bordercolor: FColors.barPurple,
                      fontsize: 20,
                    )
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }

}