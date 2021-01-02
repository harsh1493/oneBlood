import 'package:one_blood/utility/utility.dart';

class Post {
  final String postId;
  final String userId;
  final String postMediaUrl;
  final String description;
  final DateTime datePosted;
  final int likes;
  final String dp;
  final String userName;

  Post(
      {this.postId,
      this.description,
      this.userName,
      this.datePosted,
      this.likes,
      this.dp,
      this.postMediaUrl,
      this.userId});

  Post.fromJson(Map<String, dynamic> postData)
      : userId = postData['userId'],
        postId = postData['postId'],
        postMediaUrl = postData['postMediaUrl'],
        description = postData['description'],
        datePosted = postData['datePosted'],
        userName = postData['userName'],
        dp = postData['dp'],
        likes = postData['likes'];
}

class Comment {
  final String content;
  final String userName;
  final String dp;
  final String userId;
  final DateTime datePosted;
  final int likes;
  Comment(
      {this.userId,
      this.likes,
      this.datePosted,
      this.content,
      this.userName,
      this.dp});
}
