import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_app_with_bloc/model/login_user_model.dart';
import 'package:notes_app_with_bloc/screens/homePage.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin(BuildContext context) async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        postDetailsToFirestoreFromGoogleLogin(context);
      });
    }

    notifyListeners();
  }

  postDetailsToFirestoreFromGoogleLogin(BuildContext context) async {
    //calling firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;

    //calling user model(from firebase predefined) and calling sign up model
    User? user = _auth.currentUser;
    LoginUserModel loginModel = LoginUserModel();
    //writing all  values

    loginModel.email = user!.email;
    loginModel.name = user.displayName;
    loginModel.uid = user.uid;
    loginModel.imageUrl = user.photoURL;
    loginModel.provider = "google";

    //sending these values
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(loginModel.toMap())
        .then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      print("page pushed");
    });
  }
}
