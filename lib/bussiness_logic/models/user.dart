import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:one_blood/utility/utility.dart';

class User {
  String imageUrl;
  final String uid;
  String userName;
  final String gender;
  String email;
  final String bloodGroup;
  String phoneNumber;
  final DateTime dob;
  String address;
  final bool covid;
  GeoPoint coordinates;
  final int weight;
  String city;
  Map location;
  final bool wannaDonate;

  User(
      {this.location,
      this.wannaDonate,
      this.imageUrl,
      this.uid,
      this.city,
      this.weight,
      this.coordinates,
      this.gender,
      this.userName,
      this.bloodGroup,
      this.email,
      this.address,
      this.dob,
      this.phoneNumber,
      this.covid});

  User.fromJson(Map<String, dynamic> userData)
      : wannaDonate = userData['wannaDonate'],
        location = userData['location'],
        imageUrl = userData['imageUrl'],
        userName = userData['userName'],
        uid = userData['uid'],
        phoneNumber = userData['phoneNumber'],
        address = userData['address'],
        email = userData['email'],
        coordinates = userData['coordinates'],
        dob = timeStamptoDateTime(userData['dob']),
        covid = userData['covid'],
        weight = userData['weight'],
        gender = userData['gender'],
        city = userData['city'],
        bloodGroup = userData['bloodGroup'];
}
