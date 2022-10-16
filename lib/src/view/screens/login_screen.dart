import 'package:firebase_auth_app_demo/src/auth/firebase_authentication.dart';
import 'package:firebase_auth_app_demo/src/services/helper.dart';
import 'package:firebase_auth_app_demo/src/view/screens/home_screen.dart';
import 'package:firebase_auth_app_demo/src/view/widgets/k_button.dart';
import 'package:firebase_auth_app_demo/src/view/widgets/k_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  bool codeVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KTextField(
              controller: phoneController,
              hintText: 'Enter Phone Number',
            ),
            const SizedBox(height: 16,),
            Visibility(
              visible: codeVisibility,
              child: KTextField(
                controller: codeController,
                hintText: 'Enter Code',
              ),
            ),
            const SizedBox(height: 16,),
            KButton(
              onPressed: ()async{
                try{
                  if(codeVisibility){
                    if(codeController.text.isEmpty){
                      KSnackBar(context, 'Please Enter OTP!');
                    }else{
                      await firebaseAuthentication.verifyOTP(codeController.text);
                      if(mounted){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                      }
                    }
                  }else{
                    if(phoneController.text.isEmpty){
                      KSnackBar(context, 'Please Enter Valid Phone Number!');
                    }else{
                      firebaseAuthentication.loginWithPhone(phoneController.text);
                      codeVisibility = true;
                      setState(() {});
                    }

                  }
                }catch(e){
                  KSnackBar(context, 'Failed To Login');
                }
              },
              title: codeVisibility? 'Verify' : 'Login',
            )
          ],
        ),
      ),
    );
  }
}
