import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/models/posts.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/helperUI/fb_reaction_box.dart';
import 'package:one_blood/helperUI/ui_components.dart';
import 'package:one_blood/homePage/donor_list.dart';
import 'package:one_blood/utility/image_state_handler.dart';
import 'package:one_blood/utility/utility.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  static String id = 'notification_ui';
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    List<Post> posts = Provider.of<List<Post>>(context);
    print('ssssssssssssssssssss' + posts.length.toString());
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(bottom: 100),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Notifications',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.pink,
                  fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: Container(
            color: Colors.black12,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        'EXPLORE LATEST FEED',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.add_circle_rounded,
                        color: Colors.pink,
                      ),
                      GestureDetector(
                          onTap: () => buildShowModalBottomSheet(context),
                          child: Text('  Post Update'))
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Feed(
                        post: posts[index],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Feed extends StatefulWidget {
  final Post post;
  Feed({@required this.post});
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  int commentCount;

  void getCommentCount() async {
    var c = await DatabaseHandler().commentCount(widget.post.postId);
    setState(() {
      commentCount = c;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // setState(() async {
    //   commentCount = await DatabaseHandler().commentCount(widget.post.postId);
    // });
    getCommentCount();
    super.initState();
  }

  void setCommentCount() {
    setState(() {
      commentCount += 1;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getCommentCount();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //getCommentCount();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  CircleAvatar(
                    backgroundImage: widget.post.dp == null
                        ? AssetImage(
                            'assets/user_avatars/user1.png',
                          )
                        : NetworkImage(widget.post.dp),
                    radius: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.post.userName ?? 'Goli Beta ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: Colors.blue,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.access_time_sharp,
                            size: 10,
                            color: Colors.grey,
                          ),
                          Text(
                            toTime(widget.post.datePosted),
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.location_on,
                            size: 15,
                            color: Colors.grey,
                          ),
                          Text(
                            ' Mumbai',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      )
                    ],
                  ),
                ]),
              ),
              Image(
                image: NetworkImage(widget.post.postMediaUrl ??
                    'https://media1.s-nbcnews.com/i/newscms/2019_24/2895091/190613-donating-blood-cs-406p_c7ece08578922a72c9c7e853226a4fec.jpg'),
                width: double.infinity,
                height: 250,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 5,
              ),
              line(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 25,
                          ),
                          child: Image(
                            image:
                                AssetImage('assets/reaction_emoji/love2.png'),
                            width: 26,
                            height: 26,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 5),
                          ),
                          width: 29,
                          height: 29,
                        ),
                        Image(
                          image:
                              AssetImage('assets/reaction_emoji/like_alt.png'),
                          width: 28,
                          height: 28,
                        )
                      ],
                    ),
                    Text(
                      ' ' + widget.post.likes.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Text(
                      '${commentCount.toString() ?? ''} Comments    |    316 Shares',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    )
                  ],
                ),
              ),
              line(),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  widget.post.description ??
                      'Its a long established fact that a reader will be distracted by the readable content of the page when looking at its layout.The point of using Lorem Ipsum.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              )
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 346),
              child: FbReactionBox(
                postId: widget.post.postId,
              )),
          Positioned(
            top: 397,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  InkWell(
                    onTap: () {
                      print('hello');
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return FbReactionBox();
                      // }));
                      buildShowModalBottomSheet3(
                          context, widget.post.postId, setCommentCount);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 2.0),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Icon(Icons.mode_comment_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future buildShowModalBottomSheet(BuildContext context) {
  final ScrollController controller = new ScrollController();
  final ScrollController controller2 = new ScrollController();
  final TextEditingController postText = new TextEditingController();

  return showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.97,
      expand: true,
      builder: (context, scrollController) {
        return AddPost();
      },
    ),
  );
}

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController postText = new TextEditingController();

  var imageUrl;

  void setImageUrl(String url) {
    setState(() {
      imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Create Post',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: InkWell(
              onTap: () async {
                Post post = Post(
                  userId: AuthServices().user.uid,
                  userName: AuthServices().user.displayName,
                  dp: AuthServices().user.photoURL,
                  postMediaUrl: imageUrl,
                  datePosted: DateTime.now(),
                  description: postText.text,
                );
                await DatabaseHandler().addPost(post);
                Navigator.pop(context);
              },
              child: Text(
                'POST   ',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          line(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Flexible(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/user_avatars/user1.png'),
                    radius: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Harsh Shrivastava',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  CupertinoIcons.globe,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(' Public'),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          imageUrl == null
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: postText,
                      maxLines: null,
                      maxLengthEnforced: true,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          hintText: "What's on your mind?",
                          hintStyle: TextStyle(fontSize: 20),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextField(
                    controller: postText,
                    maxLines: null,
                    maxLengthEnforced: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: "Write a description for the image",
                        hintStyle: TextStyle(fontSize: 15),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
          imageUrl != null
              ? Stack(
                  children: [
                    Image(
                      image: NetworkImage(imageUrl),
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            color: Colors.black45,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                imageUrl = null;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(2),
                              color: Colors.black45,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : SizedBox(
                  width: 0,
                  height: 0,
                ),
          Spacer(),
          line(),
          InkWell(
            onTap: () => buildShowModalBottomSheet2(context, setImageUrl),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Expanded(
                child: Row(
                  children: [
                    Text(
                      'Add to your post',
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Icon(
                      Icons.video_call,
                      color: Colors.blue,
                      size: 30,
                    ),
                    Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                    Icon(
                      Icons.photo_library_rounded,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.emoji_emotions,
                      color: Colors.orange,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future buildShowModalBottomSheet2(BuildContext context, Function setImageUrl) {
  return showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 1,
      expand: true,
      builder: (context, scrollController) {
        return AddMediaSheet(
          setImageUrl: setImageUrl,
        );
      },
    ),
  );
}

class AddMediaSheet extends StatefulWidget {
  final Function setImageUrl;
  AddMediaSheet({this.setImageUrl});
  @override
  _AddMediaSheetState createState() => _AddMediaSheetState();
}

class _AddMediaSheetState extends State<AddMediaSheet> {
  var imageUrl = "";
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      expand: true,
      builder: (BuildContext context, ScrollController controller2) {
        return Scaffold(
          body: Container(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.video_call,
                    color: Colors.blue,
                    size: 30,
                  ),
                  title: Text('Create Room'),
                ),
                InkWell(
                  onTap: () {
                    setState(() async {
                      imageUrl = await uploadCameraImage();
                    });
                    widget.setImageUrl(imageUrl);
                    print(imageUrl);
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                    title: Text('Camera'),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    print('saale');
                    setState(() async {
                      imageUrl = await uploadImage();
                      widget.setImageUrl(imageUrl);
                    });
                    print(imageUrl);
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.photo_library_rounded,
                      color: Colors.yellow,
                    ),
                    title: Text('Photo/Video'),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.tag,
                    color: Colors.blue,
                  ),
                  title: Text('Tag Friends'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.emoji_emotions,
                    color: Colors.orange,
                  ),
                  title: Text('Feelings/Activity'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  title: Text('Check In'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

Future buildShowModalBottomSheet3(
    BuildContext context, String postId, Function setCommentCount) {
  final ScrollController controller = new ScrollController();
  final ScrollController controller2 = new ScrollController();

  return showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.95,
      expand: true,
      builder: (context, scrollController) {
        return AddComment(
          postId: postId,
          setCommentCount: setCommentCount,
        );
      },
    ),
  );
}

class AddComment extends StatefulWidget {
  final String postId;
  final Function setCommentCount;
  AddComment({this.postId, this.setCommentCount});

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final TextEditingController _comment = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50))),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 25,
                    ),
                    child: Image(
                      image: AssetImage('assets/reaction_emoji/love2.png'),
                      width: 26,
                      height: 26,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white, width: 5),
                    ),
                    width: 29,
                    height: 29,
                  ),
                  Image(
                    image: AssetImage('assets/reaction_emoji/like_alt.png'),
                    width: 28,
                    height: 28,
                  )
                ],
              ),
              StreamBuilder(
                  stream: DatabaseHandler().allComments(widget.postId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Comment>> comments) {
                    return Text(
                      '  ' + comments.data.length.toString(),
                      style: TextStyle(fontSize: 18),
                    );
                  }),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
          actions: [
            InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.thumb_up_alt_outlined))
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  child: Row(
                    children: [
                      Text('Most Relevant '),
                      Icon(Icons.keyboard_arrow_down_rounded)
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 15,
                child: StreamBuilder(
                  stream: DatabaseHandler().allComments(widget.postId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Comment>> comments) {
                    print(comments.data.length);
                    //setCommentCount(comments.data.length);

                    return ListView.builder(
                        itemCount: comments.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CommentBox(
                            comment: comments.data[index],
                          );
                        });
                  },
                ),
              ),
              line(),
              Flexible(
                  flex: 3,
                  child: Container(
                    height: 55,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(150, 245, 250, 1),
                        borderRadius: BorderRadius.circular(20)),
                    child: TextFormField(
                      controller: _comment,
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (value) {
                        print(value);
                      },
                      onFieldSubmitted: (value) {
                        final comment = Comment(
                            content: value,
                            userId: AuthServices().user.uid,
                            userName: AuthServices().user.displayName,
                            dp: AuthServices().user.photoURL,
                            datePosted: DateTime.now());
                        DatabaseHandler().addComment(comment, widget.postId);
                        _comment.clear();
                        widget.setCommentCount();
                      },
                      decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefix: Container(
                            margin: EdgeInsets.only(
                              right: 20,
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 30,
                            ),
                          ),
                          suffix: Container(
                            margin: EdgeInsets.only(
                              right: 20,
                            ),
                            child: Icon(
                              Icons.emoji_emotions_outlined,
                              size: 30,
                            ),
                          )),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentBox extends StatelessWidget {
  final Comment comment;
  CommentBox({@required this.comment});
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/user_avatars/user2.png'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 200,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(150, 245, 250, 1),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName ?? 'hello g',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(comment.content ?? 'hello g'),
                  ],
                )),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  toTime(comment.datePosted),
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () => print('Like'),
                  child: Text(
                    ' Like',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () => print('Reply'),
                  child: Text(
                    ' Reply',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));
  }
}
