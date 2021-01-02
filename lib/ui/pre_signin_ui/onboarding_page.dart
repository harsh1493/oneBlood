import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:one_blood/ui/pre_signin_ui/welcome_ui.dart';

class OnboardingPage extends StatefulWidget {
  static const String id = 'onboarding_page';
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> _animation;
  AnimationController controller2;
  Animation animation2;
  AnimationController controller3;
  Animation<Offset> animation3;

  int _selectedIndex = 0;
  double offset = 110.0;

  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
    controller2 = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    animation3 = Tween<Offset>(begin: Offset(0.5, 0), end: Offset(0, 0))
        .animate(controller2);
    _controller.reset();
    _controller.forward();
    controller2.reset();
    controller2.forward();
  }

  Widget build(BuildContext context) {
    //_controller.forward();

    const TextStyle optionStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    List<List<int>> pageContent = [
      [4, 69],
      [74, 135],
      [142, 179]
    ];

    _animation = new IntTween(
            begin: pageContent[_selectedIndex][0],
            end: pageContent[_selectedIndex][1])
        .animate(_controller);
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 251, 251, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40, top: 10),
              child: SlideTransition(
                  position: animation3,
                  child: Heading(
                    pageNo: _selectedIndex,
                  )),
            ),
            SizedBox(
              height: 5,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (BuildContext context, Widget child) {
                  String frame = _animation.value.toString().padLeft(3, '0');
                  return new Image.asset(
                    'assets/whole/frame_${frame}_delay-0.03s.gif',
                    gaplessPlayback: true,
                    scale: 0.9,
                  );
                },
              ),
            ),
            Footer(pageNo: _selectedIndex),
            Spacer(),
            DotsIndicator(dotsCount: 3, position: _selectedIndex.toDouble()),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () {
                          print('skip');
                          setState(() {
                            _selectedIndex = 0;
                            _controller.reset();
                            _controller.forward();
                            controller2.reset();
                            controller2.forward();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Skip',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ))),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    print('skip');
                    setState(() {
                      if (_selectedIndex < 2) {
                        _selectedIndex++;
                        _controller.reset();
                        _controller.forward();
                        controller2.reset();
                        controller2.forward();
                      } else {
                        Navigator.pushNamed(context, WelcomeUi.id);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Next',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  final pageNo;

  Heading({@required this.pageNo});

  List<List<String>> pageText = [
    ['Find a donor\n', 'Find Blood Donors & \nRequest for Blood'],
    ['Be a Blood Donor\n', 'Become a Blood\nDonor & Save Lives'],
    ['Emergency Mode\n', 'Emergency Mode is There For You']
  ];

  @override
  Widget build(BuildContext context) {
    print(pageNo);
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pageText[pageNo][0],
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          Text(
            pageText[pageNo][1],
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  final pageNo;

  Footer({@required this.pageNo});

  List<String> pageText = [
    'Users will be able to find blood donors and request for\nblood for specific date,time & place',
    'Users will be able to create a donor account and will\nbe able to save lives',
    'In case of emergency,users will be able to get contact\nnumbers of public account of donors'
  ];

  @override
  Widget build(BuildContext context) {
    print(pageNo);
    return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          pageText[pageNo],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 13,
          ),
        ));
  }
}
