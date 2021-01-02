class Appointment {
  final String bloodGroup;
  final String donorId;
  final String requesterId;
  final String status;
  final String requestId;
  final Map location;
  final DateTime dateAccepted;
  final DateTime donationDate;
  final String appointmentType;

  Appointment(
      {this.bloodGroup,
      this.requesterId,
      this.location,
      this.status,
      this.requestId,
      this.appointmentType,
      this.dateAccepted,
      this.donationDate,
      this.donorId});
}
