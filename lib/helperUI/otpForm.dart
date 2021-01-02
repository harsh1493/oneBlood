import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_blood/ui/pre_signin_ui/otp_verification_ui.dart';

class OtpForm extends StatefulWidget {
  final otpLength;
  final otp;
  final Function notify;
  OtpForm(
      {@required this.otpLength, @required this.otp, @required this.notify});

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  List<TextEditingController> subFormControllers = [];
  List<Widget> formBoxes = [];

  void populateOtpForm() {
    for (int i = 0; i < widget.otpLength; i++) {
      TextEditingController tc = new TextEditingController();
      subFormControllers.add(tc);
    }
    for (int i = 0; i < widget.otpLength; i++) {
      formBoxes.add(OtpSubForm(
        notify: widget.notify,
        textEditingController: subFormControllers[i],
      ));
      formBoxes.add(SizedBox(
        width: 20,
      ));
    }
  }

  void clearOtp() {
    for (int i = 0; i < widget.otpLength; i++) {
      subFormControllers[i].text = '';
    }
  }

  void getFormValue() {
    String s = '';
    for (var c in subFormControllers) {
      s += c.text;
    }
    setState(() {
      if (s == otpNumber) {
        isOtpCorrect = true;
      } else {
        isOtpCorrect = false;
      }
    });
    //widget.notify();
  }

  void fillOtp() {
    for (int i = 0; i < widget.otpLength; i++) {
      subFormControllers[i].text = widget.otp[i];
    }
    widget.notify();
  }

  @override
  void initState() {
    populateOtpForm();

    // Timer(Duration(milliseconds: 500), fillOtp);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getFormValue();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: formBoxes,
    );
  }
}

class OtpSubForm extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function notify;
  OtpSubForm({@required this.textEditingController, @required this.notify});
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Expanded(
      flex: 1,
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        textInputAction: TextInputAction.next,
        onEditingComplete: node.nextFocus,
        maxLengthEnforced: false,
        onChanged: (value) {
          notify();
          print(value);
          if (value.length == 1)
            FocusScope.of(context).nextFocus();
          else if (value.length == 0) FocusScope.of(context).previousFocus();
        },
        keyboardType: TextInputType.number,
        controller: textEditingController,
        style: TextStyle(color: Colors.black),
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
          hintText: '__',
          hintStyle: TextStyle(
            color: Colors.black54,
          ),
          fillColor: Color.fromRGBO(21, 251, 251, 1),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
