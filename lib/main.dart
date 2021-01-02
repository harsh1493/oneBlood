import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/models/user.dart';
import 'package:one_blood/homePage/add_request_ui.dart';

import 'package:one_blood/homePage/donor_list.dart';
import 'package:one_blood/homePage/eligibility_ui.dart';
import 'package:one_blood/homePage/find_donors_ui.dart';
import 'package:one_blood/homePage/home_page_ui.dart';
import 'package:one_blood/homePage/manage_account.dart';
import 'package:one_blood/homePage/map_view.dart';
import 'package:one_blood/homePage/my_requests.dart';
import 'package:one_blood/homePage/requests_ui.dart';
import 'package:one_blood/ui/pre_signin_ui/Signup_PersonalDetails.dart';
import 'package:one_blood/ui/pre_signin_ui/login_ui.dart';
import 'package:one_blood/ui/pre_signin_ui/onboarding_page.dart';
import 'package:one_blood/ui/pre_signin_ui/otp_verification_ui.dart';
import 'package:one_blood/ui/pre_signin_ui/signup_ui.dart';
import 'package:one_blood/ui/pre_signin_ui/splash_screen.dart';
import 'package:one_blood/ui/pre_signin_ui/welcome_mobile_verification.dart';
import 'package:one_blood/ui/pre_signin_ui/welcome_ui.dart';
import 'package:provider/provider.dart';

import 'bussiness_logic/models/posts.dart';
import 'bussiness_logic/models/request.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DatabaseHandler(),
        ),
        StreamProvider<List<Request>>.value(
          value: DatabaseHandler().allRequests,
        ),
        StreamProvider<List<User>>.value(
          value: DatabaseHandler().allUsers,
        )
      ],
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
            //  canvasColor: Colors.white,
            canvasColor: Colors.transparent,
            accentColor: Colors.red,
            unselectedWidgetColor: Colors.red,
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black),
              textTheme: TextTheme(
                  title: TextStyle(color: Colors.black, fontSize: 20)),
              color: Colors.white,
            ),
            colorScheme: ColorScheme.light(background: Colors.white)),
        initialRoute: SplashScreen1.id,
        routes: {
          SplashScreen1.id: (context) => SplashScreen1(),
          OnboardingPage.id: (context) => OnboardingPage(),
          WelcomeUi.id: (context) => WelcomeUi(),
          LoginUI.id: (context) => LoginUI(),
          SignupUI.id: (context) => SignupUI(),
          MobileVerification.id: (context) => MobileVerification(),
          OtpVerificationUI.id: (context) => OtpVerificationUI(),
          PersonalDetails.id: (context) => PersonalDetails(),
          HomePageUi.id: (context) => HomePageUi(),
          FindDonorsUi.id: (context) => FindDonorsUi(),
          DonorList.id: (context) => DonorList(),
          AddRequest.id: (context) => AddRequest(),
          RequestsUi.id: (context) => RequestsUi(),
          MyRequests.id: (context) => MyRequests(),
          ManageAccount.id: (context) => ManageAccount(),
          EligibilityUi.id: (context) => EligibilityUi(),
          MapView.id: (context) => MapView()
        },
        //home: SplashScreen1(),
      ),
    );
  }
}
