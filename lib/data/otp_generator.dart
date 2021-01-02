import 'dart:math';

String getOTP() {
  var rng = new Random();
  String s = '';
  for (var i = 0; i < 6; i++) {
    s += rng.nextInt(10).toString();
  }
  print(s);
  return s;
}
