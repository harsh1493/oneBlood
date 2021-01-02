import 'package:flutter/material.dart';

class EligibilityUi extends StatefulWidget {
  static final String id = 'eligbility_ui';
  @override
  _EligibilityUiState createState() => _EligibilityUiState();
}

class _EligibilityUiState extends State<EligibilityUi> {
  int index = 0;
  bool eligible = true;
  final _pageViewController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: Visibility(
            visible: index < 4,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  if (index > 0) {
                    index -= 1;
                    _pageViewController.animateToPage(index,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.decelerate);
                  } else {
                    Navigator.pop(context);
                  }
                });
              },
            ),
          ),
          actions: [
            Visibility(
                visible: index >= 4,
                child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () => Navigator.pop(context)))
          ],
          elevation: 0,
          toolbarHeight: 120,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Text(
              index < 4
                  ? 'Check if you can give blood'
                  : eligible
                      ? 'Great!'
                      : 'Sorry!',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: index == 4 ? 30 : 20),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              PageView(
                allowImplicitScrolling: false,
                controller: _pageViewController,
                onPageChanged: (i) {
                  setState(() {
                    index = i;
                  });

                  print(i);
                },
                children: [
                  ConditionPage(
                    index: index,
                  ),
                  ConditionPage(
                    index: index,
                  ),
                  ConditionPage(
                    index: index,
                  ),
                  ConditionPage(
                    index: index,
                  ),
                  eligible
                      ? ConditionPage(
                          index: index,
                        )
                      : ConditionPage(
                          index: index + 1,
                        )
                ],
              ),
              Visibility(
                visible: index <= 3,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(33, 31, 37, 0.5),
                                    Colors.red
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight,
                                )),
                            child: FlatButton(
                                onPressed: () {
                                  print('Yes');
                                  setState(() {
                                    eligible = eligible && false;
                                    if (index < 4) {
                                      index += 1;
                                      _pageViewController.animateToPage(index,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.decelerate);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(33, 31, 37, 0.5),
                                    Colors.red
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight,
                                )),
                            child: FlatButton(
                                onPressed: () {
                                  print('No');
                                  setState(() {
                                    index += 1;
                                    eligible = eligible && true;
                                    //_pageViewController.jumpToPage(index);
                                    _pageViewController.animateToPage(index,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.decelerate);
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ConditionPage extends StatelessWidget {
  final index;
  ConditionPage({@required this.index});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(
              conditions[index.toString()][0],
            ),
            fit: BoxFit.fitHeight,
            height: 250,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            conditions[index.toString()][1],
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          index == 4 || index == 5
              ? conditions[index.toString()][0] == 'assets/ok.png'
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '\n' + conditions[index.toString()][2],
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(10, 80, 10, 10),
                      child: Text(
                        '\n' + conditions['5'][2],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
              : SizedBox(
                  height: 40,
                ),
        ],
      ),
    );
  }
}

var conditions = {
  '0': [
    'assets/cough.png',
    'Do you have a chesty cough,\nsore throat,or you are \nrecovering from cold?'
  ],
  '1': [
    'assets/bacteria.png',
    'Have you had any infection in the \n last 2 weeks or have you taken \nantibiotics within the last 7 days?'
  ],
  '2': [
    'assets/tattoo.png',
    'In Last 4 months have you had a \ntattoo,semi-permanent make up or \nany cosmetic treatments that \ninvolved piercing the skin?'
  ],
  '3': [
    'assets/heartConditions.png',
    'Have you got,or have you had,any \nheart conditions?'
  ],
  '4': [
    'assets/ok.png',
    'You have passed our eligibility \ncheck and it looks like you can give \nblood',
    "Please remember that this checker only covered the most common reasons that people can't give blood and other eligibility criteria do apply.Staff at the hospital make the final decision as weather you can give blood"
  ],
  '5': [
    'assets/notOk.png',
    'You have not passed our eligibility \ncheck and it looks like you cannot give blood',
    'You can always help by sharing a blood request with a friend'
  ],
};
