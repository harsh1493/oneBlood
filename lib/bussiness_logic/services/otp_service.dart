import 'package:flutter_otp/flutter_otp.dart';

class OtpService {
  String phoneNumber;
  String otp;
  String countryCode;

  void sendOTP({
    String phoneNumber,
    String otpNumber,
    String countryCode,
  }) {
    FlutterOtp otp = FlutterOtp();
    otp.sendOtp(phoneNumber, 'Use verification code $otpNumber for OneBlood',
        1000, 6000, countryCode);
    print('sent to $phoneNumber : $otpNumber');
  }
}
