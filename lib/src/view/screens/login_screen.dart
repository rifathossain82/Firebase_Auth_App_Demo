import 'package:firebase_auth_app_demo/src/auth/firebase_authentication.dart';
import 'package:firebase_auth_app_demo/src/services/helper.dart';
import 'package:firebase_auth_app_demo/src/services/service_2.dart';
import 'package:firebase_auth_app_demo/src/view/screens/home_screen.dart';
import 'package:firebase_auth_app_demo/src/view/widgets/k_button.dart';
import 'package:firebase_auth_app_demo/src/view/widgets/k_text_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  var deviceTokenToSendPushNotification = '';

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    print("Token Value $deviceTokenToSendPushNotification");
  }

  @override
  void initState() {
    FirebaseMessaging.instance.subscribeToTopic("rh100");
    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);

        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    getDeviceTokenToSendNotification();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.05,),
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
                onPressed: loginOrVerify,
                title: codeVisibility? 'Verify' : 'Login',
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginOrVerify()async{
    try{
      if(codeVisibility){
        if(codeController.text.isEmpty){
          KSnackBar(context, 'Please Enter OTP!');
        }else{
          await firebaseAuthentication.verifyOTP(codeController.text);
          if(mounted){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
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
  }
}
