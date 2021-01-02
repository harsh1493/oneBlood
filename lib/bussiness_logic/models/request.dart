import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final Map address;
  final String bloodGroup;
  final String patientName;
  final String relation;
  final String requestId;
  final String requesterId;
  final String status;
  final DateTime date;
  final DateTime datePosted;
  final double units;
  final GeoPoint coordinates;
  final String city;
  final String requesterName;
  final String acceptedBy;
  final String accepterId;
  final List<dynamic> rejecters;
  Request(
      {this.acceptedBy,
      this.accepterId,
      this.rejecters,
      this.address,
      this.requesterName,
      this.city,
      this.bloodGroup,
      this.coordinates,
      this.date,
      this.datePosted,
      this.patientName,
      this.relation,
      this.requestId,
      this.requesterId,
      this.status,
      this.units});
}
