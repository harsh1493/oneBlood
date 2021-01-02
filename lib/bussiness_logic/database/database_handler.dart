import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:one_blood/bussiness_logic/models/appointments.dart';
import 'package:one_blood/bussiness_logic/models/posts.dart';
import 'package:one_blood/bussiness_logic/models/request.dart';
import 'package:one_blood/bussiness_logic/models/user.dart' as User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/utility/utility.dart';

class DatabaseHandler extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  DatabaseHandler() {
    //getUserDetail();
  }

  User.User user;
  List<Request> requests;

  Stream<User.User> get currentUser {
    var user = _firestore
        .collection('users')
        .doc(_auth.currentUser.uid)
        .snapshots()
        .map(
          (DocumentSnapshot userData) => User.User.fromJson(userData.data()),
        );
    print(user.first.toString());
    return user;
  }

  Stream<List<Request>> get allRequests {
    return _firestore.collection('requests').snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((request) => Request(
                city: request.data()['city'],
                requestId: request.data()['requestId'],
                address: request.data()['address'],
                bloodGroup: request.data()['bloodGroup'],
                coordinates: request.data()['coordinates'],
                date: timeStamptoDateTime(request.data()['date']),
                datePosted: timeStamptoDateTime(request.data()['datePosted']),
                patientName: request.data()['patientName'],
                relation: request.data()['relation'],
                requesterId: request.data()['requesterId'],
                status: request.data()['status'],
                units: request.data()['units'],
                requesterName: request.data()['requesterName'],
                acceptedBy: request.data()['acceptedBy'],
                rejecters: request.data()['rejecters']))
            .toList());
  }

  Stream<List<User.User>> get allUsers {
    return _firestore.collection('users').snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((userData) => User.User.fromJson(userData.data()))
            .toList());
  }

  Future<Map<String, dynamic>> fetchUser(String uid) async {
    var fuser = await _firestore.collection('users').doc(uid).get();
    Map user = fuser.data();
    return user;
  }

  Future<Map<String, dynamic>> fetchRequest(String requestId) async {
    var request = await _firestore.collection('requests').doc(requestId).get();
    Map _request = request.data();
    return _request;
  }

  void modifyUser(Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser.uid)
        .set(data, SetOptions(merge: true));

    print('user data Updated');
  }

  Future<void> deleteRequest(String requestId) async {
    await _firestore.collection('requests').doc(requestId).delete();
  }

  Future<void> modifyRequest(
      Map<String, dynamic> data, String requestId) async {
    if (data.keys.contains('rejecters')) {
      await _firestore.collection('requests').doc(requestId).update({
        'rejecters': FieldValue.arrayUnion([data['rejecters']])
      });
    } else {
      await _firestore
          .collection('requests')
          .doc(requestId)
          .set(data, SetOptions(merge: true));
    }

    print('request data Updated');
  }

  Future<void> addUser(User.User user) async {
    var _userData = {
      'location': user.location,
      'uid': user.uid,
      'wannaDonate': user.wannaDonate,
      'userName': user.userName,
      'gender': user.gender,
      'phoneNumber': user.phoneNumber,
      'email': user.email,
      'address': user.address,
      'coordinates': user.coordinates,
      'bloodGroup': user.bloodGroup,
      'covid': user.covid,
      'weight': user.weight,
      'dob': Timestamp.fromDate(user.dob),
      'city': user.city,
      'imageUrl': user.imageUrl,
    };

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser.uid)
          .set(_userData);
      print('user added');
    } catch (e) {
      print(e);
    }
  }

  Future<void> addRequest(Request request) async {
    var _request = {
      'accepterId': null,
      'rejecters': [],
      'requestId': request.requestId,
      'patientName': request.patientName,
      'accepterId': request.accepterId,
      'relation': request.relation,
      'address': request.address,
      'coordinates': request.coordinates,
      'bloodGroup': request.bloodGroup,
      'city': request.city,
      'date': request.date,
      'datePosted': Timestamp.fromDate(DateTime.now()),
      'requesterId': request.requesterId,
      'status': 'pending',
      'units': request.units,
      'requesterName': _auth.currentUser.displayName,
      'acceptedBy': null
    };

    try {
      String reqId;
      var doc =
          await _firestore.collection('requests').add(_request).then((value) {
        reqId = value.id;
        print(value.id);
      });
      await _firestore
          .collection('requests')
          .doc(reqId)
          .set({'requestId': reqId}, SetOptions(merge: true));

      print('user added');
    } catch (e) {
      print('user not added');
      print(e);
    }
  }

  Future<void> addPost(Post post) async {
    var _post = {
      'postId': post.postId,
      'userId': post.userId,
      'userName': post.userName,
      'dp': post.dp,
      'postMediaUrl': post.postMediaUrl,
      'description': post.description,
      'datePosted': post.datePosted,
      'likes': 0
    };
    try {
      var doc = await _firestore.collection('posts').add(_post);
      print('postAdded');
    } catch (e) {
      print('post not added');
      print(e);
    }
  }

  Stream<List<Post>> get allPost {
    try {
      return _firestore.collection('posts').snapshots().map(
          (QuerySnapshot querySnapshot) => querySnapshot.docs
              .map((postData) => Post(
                  postId: postData.data()['postId'],
                  userId: postData.data()['userId'],
                  postMediaUrl: postData.data()['postMediaUrl'],
                  description: postData.data()['description'],
                  datePosted:
                      timeStamptoDateTime(postData.data()['datePosted']),
                  userName: postData.data()['userName'],
                  dp: postData.data()['dp'],
                  likes: postData.data()['likes']))
              .toList());
    } catch (e) {
      print(e);
    }
  }

  Future<void> addComment(Comment comment, String postId) async {
    var _comment = {
      'userId': comment.userId,
      'userName': comment.userName,
      'dp': comment.dp,
      'datePosted': comment.datePosted,
      'content': comment.content,
      'likes': comment.likes
    };
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(_comment);
      print('success');
    } catch (e) {
      print('comment failed');
    }
  }

  Stream<List<Comment>> allComments(String postId) {
    try {
      return _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('datePosted', descending: true)
          .snapshots()
          .map((QuerySnapshot querySnapshot) => querySnapshot.docs
              .map((commentData) => Comment(
                  userId: commentData.data()['userId'],
                  userName: commentData.data()['userName'],
                  datePosted:
                      timeStamptoDateTime(commentData.data()['datePosted']),
                  content: commentData.data()['content'],
                  dp: commentData.data()['dp'],
                  likes: commentData.data()['likes']))
              .toList());
    } catch (e) {
      print(e);
    }
  }

  Future<int> commentCount(String posttId) async {
    var doc = await _firestore
        .collection('posts')
        .doc(posttId)
        .collection('comments')
        .get();
    print(doc.size);
    return doc.size;
  }

  Future<void> like(String postId) async {
    print('liked');
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({'likes': FieldValue.increment(1)});
    } catch (e) {
      print('Exception h: $e');
    }
  }

  Future<void> disLike(String postId) async {
    print('liked');
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({'likes': FieldValue.increment(-1)});
    } catch (e) {
      print('Exception h: $e');
    }
  }

  Future<void> addApointment(Appointment appointment) async {
    await _firestore
        .collection('users')
        .doc(AuthServices().user.uid)
        .collection('appointments')
        .add({
      'bloodGroup': appointment.bloodGroup,
      'donorId': appointment.donorId,
      'requesterId': appointment.requesterId,
      'location': appointment.location,
      'requestId': appointment.requestId,
      'dateAccepted': appointment.dateAccepted,
      'donationDate': appointment.donationDate,
      'status': appointment.status,
      'appointmentType': 'donation'
    });
    print(appointment.requesterId);
    await _firestore
        .collection('users')
        .doc(appointment.requesterId)
        .collection('appointments')
        .add({
      'bloodGroup': appointment.bloodGroup,
      'donorId': appointment.donorId,
      'requesterId': appointment.requesterId,
      'location': appointment.location,
      'requestId': appointment.requestId,
      'dateAccepted': appointment.dateAccepted,
      'donationDate': appointment.donationDate,
      'status': appointment.status,
      'appointmentType': 'request'
    });
  }

  Stream<List<Appointment>> allAppointments(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .orderBy('donationDate', descending: true)
          .snapshots()
          .map((QuerySnapshot querySnapshot) => querySnapshot.docs
              .map((appointmentData) => Appointment(
                  bloodGroup: appointmentData.data()['bloodGroup'],
                  requesterId: appointmentData.data()['requesterId'],
                  requestId: appointmentData.data()['requestId'],
                  donationDate: timeStamptoDateTime(
                      appointmentData.data()['donationDate']),
                  location: appointmentData.data()['location'],
                  donorId: appointmentData.data()['donorId'],
                  status: appointmentData.data()['status'],
                  dateAccepted: timeStamptoDateTime(
                      appointmentData.data()['dateAccepted']),
                  appointmentType: appointmentData.data()[' appointmentType']))
              .toList());
    } catch (e) {
      print(e);
    }
  }
}
