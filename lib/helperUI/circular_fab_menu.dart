import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultiFabCircular extends StatelessWidget {
  const MultiFabCircular({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 50,
      child: FabCircularMenu(
          onDisplayChange: (c) {
            if (c) {
              print('change');
            }
          },
          fabSize: 40,
          fabElevation: 0,
          ringWidth: 0,
          ringColor: Colors.white,
          ringDiameter: 150,
          fabColor: Colors.red,
          alignment: Alignment.bottomCenter,
          fabOpenIcon: Icon(
            CupertinoIcons.drop_fill,
            color: Colors.white,
          ),
          fabCloseIcon: Icon(
            CupertinoIcons.drop,
            color: Colors.white,
          ),
          children: <Widget>[
            FloatingActionButton(
              onPressed: null,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              child: Text(
                'A+',
                style: TextStyle(fontSize: 20),
              ),
            ),
            FloatingActionButton(
              onPressed: null,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              child: Text(
                'A+',
                style: TextStyle(fontSize: 20),
              ),
            ),
            FloatingActionButton(
              onPressed: null,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              child: Text(
                'A+',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ]),
    );
  }
}
