import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app_demo/src/services/notification_services.dart';

class FirebaseAuthentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationReceived = '';

  loginWithPhone(String phoneNumber) {
    try{
      auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {
            auth.signInWithCredential(credential).then((value) {
              print('Login Success');
            });
          },
          verificationFailed: (FirebaseAuthException exception) {
            print(exception.message);
          },
          codeSent: (String verificationId, int? code) {
            verificationReceived = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {

          });
    }catch(e){
      throw Exception();
    }
  }


  verifyOTP(String otp) async{
    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationReceived ,
          smsCode: otp
      );

      await auth.signInWithCredential(credential).then((value){
        print('Logged Success');
       NotificationService().showNotification(
          title: 'Firebase Auth App',
          body: 'Hey! You Logged In Successfully!',
          payload: 'abc.com'
        );


      });
    }catch(e){
      throw Exception();
    }
  }
}
