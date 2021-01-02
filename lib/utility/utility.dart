import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

String dateFormatter(DateTime dt) {
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(dt);
}

DateTime timeStamptoDateTime(var timeStamp) {
  Timestamp ts = timeStamp;
  return ts.toDate();
}

String timeFormatter(DateTime dateTime) {
  String sfx = dateTime.hour > 12 ? 'PM' : 'AM';
  return (dateTime.hour % 12).toString() +
      ':' +
      dateTime.minute.toString() +
      ' ' +
      sfx;
}

String toTime(DateTime dt) {
  int day = dt.day;
  int month = dt.month;
  int year = dt.year;
  bool isAM = true;
  var hr = dt.hour;
  var now = DateTime.now();

  if (year == now.year && month == now.month && day == now.day) {
    if (now.hour > dt.hour)
      return (now.hour - dt.hour).toString() + 'hr';
    else
      return (now.minute - dt.minute).toString() + 'min';
  } else if (year == now.year && month == now.month && day == now.day - 1) {
    return 'Yesterday';
  } else {
    return '$day/$month/$year';
  }
}

uploadImage() async {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  PickedFile image;
  image = await _picker.getImage(source: ImageSource.gallery);
  var file = File(image.path);
  if (image != null) {
    var snapshot = await _storage.ref().child(image.path).putFile(file);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } else {
    print('No path received');
  }
}

uploadCameraImage() async {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  PickedFile image;
  image = await _picker.getImage(source: ImageSource.camera);
  var file = File(image.path);
  if (image != null) {
    var snapshot = await _storage.ref().child(image.path).putFile(file);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } else {
    print('No path received');
    return null;
  }
}
