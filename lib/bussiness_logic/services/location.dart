import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../constants.dart';
import 'networking.dart';

double longitude;
double latitude;

class Location {
  static Future<GeoPoint> getLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationServiceEnabled) {
      print("location services available");
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      print({position.latitude, position.longitude, position.accuracy});
      latitude = position.latitude;
      longitude = position.longitude;
      return GeoPoint(latitude, longitude);
    } else {
      print("location services unavailable");
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
      return null;
    }
  }

  static Future<dynamic> reverseGeocodedLocation() async {
    await getLocation();
    var apiUrl =
        'https://eu1.locationiq.com/v1/reverse.php?key=$locationIqApiKey&lat=$latitude&lon=$longitude&format=json';
    NetworkHelper nh = new NetworkHelper(apiUrl);
    var locationData = await nh.getData();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    print(locationData.toString());
    print(placemarks.asMap().values.toList().first);
    print(':-|');
    return locationData;
  }
}
