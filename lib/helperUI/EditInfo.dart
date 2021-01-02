import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';

final _auth = AuthServices().getAuth();
void edit(context, Widget editWidget) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(20, 27, 40, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: editWidget,
          ),
        );
      });
}

//bottom sheet widget to update name
class EditNameWidget extends StatefulWidget {
  @override
  _EditNameWidgetState createState() => _EditNameWidgetState();
}

class _EditNameWidgetState extends State<EditNameWidget> {
  final _name = TextEditingController();
  bool isUpdated = false;

  @override
  void initState() {
    // TODO: implement initState

    _name.text = _auth.currentUser.displayName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.black45,
      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter your name',
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          TextFormField(
            style: TextStyle(color: Colors.grey),
            controller: _name,
            autofocus: true,
            //initialValue: _auth.currentUser.displayName,
            onChanged: (value) {
              print(value);
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                child: Text('Save', style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    AuthServices()
                        .setUserProfile(userName: _name.text, photoUrl: null);
                    DatabaseHandler().modifyUser({'userName': _name.text});

                    Navigator.pop(context);
                    //Navigator.pop(context);
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

//bottom sheet widget to update profile picture
class EditDpWidget extends StatefulWidget {
  @override
  _EditDpWidgetState createState() => _EditDpWidgetState();
}

class _EditDpWidgetState extends State<EditDpWidget> {
  String imageUrl;

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;
    image = await _picker.getImage(source: ImageSource.gallery);
    var file = File(image.path);
    if (image != null) {
      var snapshot = await _storage.ref().child(image.path).putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        print(imageUrl);
      });
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
      setState(() {
        imageUrl = downloadUrl;
        print(imageUrl);
      });
    } else {
      print('No path received');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile photo',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Column(
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      print('delete');
                      print(_auth.currentUser.uid);
                      await AuthServices().setUserProfile(
                          userName: null,
                          photoUrl:
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTHXi6kWCo1P3qJAuOnEAs6jWS1Dg1BqRkk8Q&usqp=CAU');
                      await DatabaseHandler().modifyUser({
                        'imageUrl':
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTHXi6kWCo1P3qJAuOnEAs6jWS1Dg1BqRkk8Q&usqp=CAU'
                      });
                      print(_auth.currentUser.photoURL);
                      Navigator.pop(context);
                      setState(() {});
                    },
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' Remove \n   photo',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      print('galary');
                      await uploadImage();
                      await AuthServices()
                          .setUserProfile(userName: null, photoUrl: imageUrl);
                      await DatabaseHandler()
                          .modifyUser({'imageUrl': imageUrl});
                      Navigator.pop(context);
                      setState(() {});
                    },
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.photo_library,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Galary \n',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      print('Camera');
                      await uploadCameraImage();
                      await AuthServices()
                          .setUserProfile(userName: null, photoUrl: imageUrl);
                      await DatabaseHandler()
                          .modifyUser({'imageUrl': imageUrl});
                      Navigator.pop(context);
                      setState(() {});
                    },
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' Camera \n',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
