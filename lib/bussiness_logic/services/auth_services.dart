import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:one_blood/homePage/home_page_ui.dart';
import 'package:one_blood/ui/pre_signin_ui/Signup_PersonalDetails.dart';

class AuthServices extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final user = FirebaseAuth.instance.currentUser;

  FirebaseAuth getAuth() {
    return _auth;
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCredential) {
    FirebaseAuth.instance.signInWithCredential(authCredential).whenComplete(() {
      notifyListeners();
    });
  }

  Future<void> setUserProfile({String userName, String photoUrl}) async {
    var user = _auth.currentUser;
    try {
      await user.updateProfile(
          displayName:
              userName == null ? _auth.currentUser.displayName : userName,
          photoURL: photoUrl == null ? _auth.currentUser.photoURL : photoUrl);
      await _auth.currentUser.reload();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateEmail({String email}) async {
    try {
      await user.updateEmail(email);
      await _auth.currentUser.reload();
      print('email updated');
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePhoneNumber(
      {PhoneAuthCredential phoneAuthCredential}) async {
    try {
      await user.updatePhoneNumber(phoneAuthCredential);
      await _auth.currentUser.reload();
      print('phone number updated');
    } catch (e) {
      print(e);
    }
  }

  void updatePassword({String newPassword}) {
    try {
      user.updatePassword(newPassword);
      print('password updated');
    } catch (e) {
      print(e);
    }
  }

  Future<User> googleSignIn(BuildContext context, bool isFromReg) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    User userDetails = (await _auth.signInWithCredential(credential)).user;
    ProviderDetails providerInfo = ProviderDetails(userDetails.uid);
    List<ProviderDetails> providerData = List<ProviderDetails>();
    providerData.add(providerInfo);
    UserDetails details = UserDetails(
        providerDetails: userDetails.uid,
        userName: userDetails.displayName,
        photoUrl: userDetails.photoURL,
        providerData: providerData);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return isFromReg ? PersonalDetails() : HomePageUi();
    }));
    print(userDetails);
    return userDetails;
  }

  googleSignOut() {
    _googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
  }
}

class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final List<ProviderDetails> providerData;
  UserDetails(
      {@required this.providerDetails,
      @required this.userName,
      @required this.photoUrl,
      @required this.providerData});
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}
