import 'package:hive/hive.dart';
import 'package:ss/model/user.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 0; // Unique identifier for this adapter

  @override
  User read(BinaryReader reader) {
    return User(
      id: reader.readString(),
      citizensName: reader.readString(),
      phoneNumber: reader.readString(),
      passportNumber: reader.readString(),
      nationality: reader.readString(),
      genre: reader.readString(),
      age: reader.readString(),
      education: reader.readString(),
      maritalStatus: reader.readString(),
      address: reader.readString(),
      notes: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.citizensName);
    writer.writeString(obj.phoneNumber);
    writer.writeString(obj.passportNumber);
    writer.writeString(obj.nationality);
    writer.writeString(obj.genre);
    writer.writeString(obj.age);
    writer.writeString(obj.education);
    writer.writeString(obj.maritalStatus);
    writer.writeString(obj.address);
    writer.writeString(obj.notes);
  }
}
