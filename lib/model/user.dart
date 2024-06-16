import 'package:hive/hive.dart';

// part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late  String citizensName;
  @HiveField(2)
  late String phoneNumber;
  @HiveField(3)
  late  String passportNumber;
  @HiveField(4)
  late String nationality;
  @HiveField(5)
  late String genre;
  @HiveField(6)
  late String age;
  @HiveField(7)
  late String education;
  @HiveField(8)
  late String maritalStatus;
  @HiveField(9)
  late String address;
  @HiveField(10)
  late String notes;


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

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? "لم يتم ادخال بيانات",
      citizensName: json['CitizensName'] as String? ?? 'لم يتم ادخال بيانات',
      phoneNumber: json['phoneNumber'] as String? ?? 'لم يتم ادخال بيانات',
      passportNumber: json['passportNumber'] as String? ?? 'لم يتم ادخال بيانات',
      nationality: json['nationality'] as String? ?? 'لم يتم ادخال بيانات',
      genre: json['genre'] as String? ?? 'لم يتم ادخال بيانات',
      age: json['age'] as String? ?? 'لم يتم ادخال بيانات',
      education: json['education'] as String? ?? 'لم يتم ادخال بيانات',
      maritalStatus: json['maritalStatus'] as String? ?? 'لم يتم ادخال بيانات',
      address: json['address'] as String? ?? 'لم يتم ادخال بيانات',
      notes: json['notes'] as String? ?? 'لم يتم ادخال بيانات',
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
    };
  }
}
