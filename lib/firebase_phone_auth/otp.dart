import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/firebase_phone_auth/wrapper.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {

  final String vid;
  final String phonenumber;

  const OtpPage({super.key, required this.vid, required this.phonenumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {

  var code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
       body: SingleChildScrollView(
         child: ListView(
           shrinkWrap: true,
           children: [
             //Image.asset("");
             Center(child: Text("OTP Verification",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
             Center(child: Text("Enter OTP sent your phone number ${widget.phonenumber}")),
             SizedBox(height: 20,),
             textcode(),
             SizedBox(height: 80,),
             button(),
           ],
         ),
       ),
    );
  }

  Widget textcode() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Pinput(
          length: 6,
          onChanged: (value){
            setState(() {
              code = value;
            });
          },
        ),
      ),
    );
  }

  Widget button() {
    return MaterialButton(
        onPressed: (){
          signIn();
        },
      color: Colors.blue,
      child: Text("Verify & Proceed",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
    );
  }

  signIn()async{

  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.vid,
      smsCode: code) ;

  try{
    await FirebaseAuth.instance.signInWithCredential(credential).then((value){
      Get.offAll(Wrapper());
    });
  }on FirebaseAuthException catch(e){
    Get.snackbar('Error Occurred', e.code);
  }catch (e){
    Get.snackbar('Error Occurred', e.toString());
  }
  }

}
