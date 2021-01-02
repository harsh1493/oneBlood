import 'package:flutter/material.dart';

const mapBoxAccessToken =
    'pk.eyJ1IjoiaGFyc2gxNDkzIiwiYSI6ImNraTMzcXNtZTNxNmgyc2t6cWMyNzJkMzMifQ.DGUnNYDz5s0V5gcWQg62CQ';
const openCageMapApiKey = 'de0388e317d74753b5db20749f8d776b';
const locationIqApiKey = 'pk.7d0d5b28f30625144cbc4a8af1ad452d';
const mapID = '602f6e33eae2eea3';
const altDp =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTHXi6kWCo1P3qJAuOnEAs6jWS1Dg1BqRkk8Q&usqp=CAU';
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
];

enum Gender { male, female, other }
enum Choice { yes, no }
var b = {
  'Ap': 'A+',
  'Am': 'A-',
  "Bp": 'B+',
  "Bm": 'B-',
  'ABp': 'AB+',
  'ABm': 'AB-',
  'Op': 'O+',
  'Om': 'O-',
  'Any': 'Any',
  'Other': 'Other'
};
var month = {
  '1': 'Jan',
  '2': 'Feb',
  '3': 'Mar',
  '4': 'Apr',
  '5': 'May',
  '6': 'June',
  '7': 'July',
  '8': 'Aug',
  '9': 'Sept',
  '10': 'Oct',
  '11': 'Nov',
  '12': 'Dec',
};
var weekDay = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday'
];
var conditions = {
  '0': [
    'assets/cough.png',
    'Do you have a chesty cough,\nsore throat,or you are \nrecovering from cold?'
  ],
  '1': [
    'assets/bacteria.png',
    'Have you had any infection in the \n last 2 weeks or have you taken \nantibiotics within the last 7 days'
  ],
  '2': [
    'assets/tattoo.png',
    'In Last 4 months have you had a \ntattoo,semi-permanent make up or \nany cosmetic treatments that \ninvolved piercing the skin?'
  ],
};
