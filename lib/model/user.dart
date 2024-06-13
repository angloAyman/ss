import 'package:hive/hive.dart';
// part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late final String id;
  @HiveField(1)
  late final String citizensName;
  @HiveField(2)
  late final String phoneNumber;
  @HiveField(3)
  late final String passportNumber;
  @HiveField(4)
  late final String nationality;
  @HiveField(5)
  late final String genre;
  @HiveField(6)
  late final String age;
  @HiveField(7)
  late final String education;
  @HiveField(8)
  late final String maritalStatus;
  @HiveField(9)
  late final String address;
  @HiveField(10)
  late final String notes;

  bool isSelected; // Add isSelected property

// class User {
//   final String id;
//   final String citizensName;
//   final String phoneNumber;
//   final String passportNumber;
//   final String nationality;
//   final String genre;
//   final String age;
//   final String education;
//   final String maritalStatus;
//   final String address;
//   final String notes;

  User({
    required this.id,
    required this.citizensName,
    required this.phoneNumber,
    required this.passportNumber,
    required this.nationality,
    required this.genre,
    required this.age,
    required this.education,
    required this.maritalStatus,
    required this.address,
    required this.notes,
    this.isSelected = false, // Initialize isSelected to false

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      citizensName: json['citizensName'],
      phoneNumber: json['phoneNumber'],
      passportNumber: json['passportNumber'],
      nationality: json['nationality'],
      genre: json['genre'],
      age: json['age'],
      education: json['education'],
      maritalStatus: json['maritalStatus'],
      address: json['address'],
      notes: json['notes'],
      // isSelected:json['isSelected'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'citizensName': citizensName,
      'phoneNumber': phoneNumber,
      'passportNumber': passportNumber,
      'nationality': nationality,
      'genre': genre,
      'age': age,
      'education': education,
      'maritalStatus': maritalStatus,
      'address': address,
      'notes': notes,
      // 'isSelected':isSelected,
    };
  }
}
