import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'otp.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {

  TextEditingController phonenumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
         // Image.asset(""),
          SizedBox(height: 100,),
          Center(child: Text("Enter Phone Number",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
          Center(child: Text("We will send you an otp on this phone number")),
          SizedBox(height: 20,),
          phonetext(),
          SizedBox(height: 50,),
          button()
        ],
      ),
    );
  }

  Widget phonetext() {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: TextField(
        controller: phonenumber,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefix: Text("+91"),
          prefixIcon: Icon(Icons.phone),
          labelText: 'Enter Phone Number',
          hintStyle: TextStyle(color: Colors.grey),
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue))
        ),
      ),
    );
  }

  Widget button() {
    return Center(
      child: MaterialButton(
          onPressed: (){
            sendcode();
          },
        color: Colors.blue,
        child: Text("Recieve OTP",
        style: TextStyle(color: Colors.white),),
      )
    );
  }

   sendcode() async{
   try{
     await FirebaseAuth.instance.verifyPhoneNumber(

        phoneNumber: '+91'+phonenumber.text,

         verificationCompleted: (PhoneAuthCredential credential){},

         verificationFailed: (FirebaseAuthException e){
          Get.snackbar('Error Occured', e.code);
         },

         codeSent: (String vid,int? tocken){
          Get.to(OtpPage(vid: vid,phonenumber: phonenumber.text,));
         },

         codeAutoRetrievalTimeout: (vid){}
     );
   }on FirebaseAuthException catch(e){
     Get.snackbar('Error Occured', e.code);
   }catch(e){
     Get.snackbar("Error Occured", e.toString());
   }
  }



}
