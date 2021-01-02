import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:one_blood/bussiness_logic/models/request.dart';
import 'package:one_blood/bussiness_logic/models/user.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/constants.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  static final String id = 'map_view';
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    List<Request> requestList = Provider.of<List<Request>>(context)
        .where((request) =>
            request.requesterId != AuthServices().user.uid &&
            !request.rejecters.contains(AuthServices().user.uid))
        .toList();

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(user.coordinates.latitude ?? 23.252490,
              user.coordinates.longitude ?? 77.438154),
          zoom: 12.0,
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/harsh1493/cki36ba9f53or19libwhad8sa/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaGFyc2gxNDkzIiwiYSI6ImNraTMzcXNtZTNxNmgyc2t6cWMyNzJkMzMifQ.DGUnNYDz5s0V5gcWQg62CQ",
              additionalOptions: {
                'accessToken': mapBoxAccessToken,
                'id': 'mapbox.mapbox-streets-v7'
              }),
          new MarkerLayerOptions(
            markers: requestList
                .map((e) => Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                          e.coordinates.latitude, e.coordinates.longitude),
                      builder: (ctx) => Container(
                        child: Icon(Icons.location_on),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
