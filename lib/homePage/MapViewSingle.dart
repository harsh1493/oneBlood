import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:one_blood/constants.dart';

class MapViewSingle extends StatefulWidget {
  static final String id = 'map_view_single';
  final GeoPoint coordinates;
  MapViewSingle({@required this.coordinates});
  @override
  _MapViewSingleState createState() => _MapViewSingleState();
}

class _MapViewSingleState extends State<MapViewSingle> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(widget.coordinates.latitude ?? 23.252490,
              widget.coordinates.longitude ?? 77.438154),
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
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(
                    widget.coordinates.latitude, widget.coordinates.longitude),
                builder: (ctx) => Container(
                  child: Icon(Icons.location_on),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
