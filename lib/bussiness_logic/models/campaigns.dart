import 'package:one_blood/bussiness_logic/models/user.dart';

class Campaign {
  final Map location;
  final String organizer;
  final String description;
  final DateTime date;
  final List<User> volunteers;
  Campaign(
      {this.location,
      this.date,
      this.description,
      this.organizer,
      this.volunteers});
}
