import 'package:flutter/cupertino.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';

class ImageState extends ChangeNotifier {
  var imageUrl;

  void setImageUrl(String url) {
    print('Image set hai');
    imageUrl = url;
    notifyListeners();
  }

  String get getImageUrl {
    print('Image set hai');
    return imageUrl;
  }
}
