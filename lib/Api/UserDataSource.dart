import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ss/model/user.dart';

// UserDataSource class definition
// class UserDataSource extends DataGridSource {
//   List<DataGridRow> _usersDataGridRows = [];
//
//   UserDataSource(List<User> users) {
//     _usersDataGridRows = users.map<DataGridRow>((user) {
//       return DataGridRow(cells: [
//         DataGridCell<String>(columnName: 'id', value: user.id),
//         DataGridCell<String>(columnName: 'citizensName', value: user.citizensName),
//         DataGridCell<String>(columnName: 'phoneNumber', value: user.phoneNumber),
//         DataGridCell<String>(columnName: 'passportNumber', value: user.passportNumber),
//         DataGridCell<String>(columnName: 'nationality', value: user.nationality),
//         DataGridCell<String>(columnName: 'genre', value: user.genre),
//         DataGridCell<String>(columnName: 'age', value: user.age),
//         DataGridCell<String>(columnName: 'education', value: user.education),
//         DataGridCell<String>(columnName: 'maritalStatus', value: user.maritalStatus),
//         DataGridCell<String>(columnName: 'address', value: user.address),
//         DataGridCell<String>(columnName: 'notes', value: user.notes),
//       ]);
//     }).toList();
//   }
//
//   @override
//   List<DataGridRow> get rows => _usersDataGridRows;
//
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(cells: row.getCells().map<Widget>((cell) {
//       return Container(
//         alignment: Alignment.centerLeft,
//         padding: EdgeInsets.all(8.0),
//         child: Text(cell.value.toString()),
//       );
//     }).toList());
//   }
// }
// extension on User {
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'citizensName': citizensName,
//       'phoneNumber': phoneNumber,
//       'passportNumber': passportNumber,
//       'nationality': nationality,
//       'genre': genre,
//       'age': age,
//       'education': education,
//       'maritalStatus': maritalStatus,
//       'address': address,
//       'notes': notes,
//     };
//   }
// }

class UserDataTableSource extends DataGridSource {
  List<User> users = [];
  List<DataGridRow> dataGridRows = [];
  List<User> filteredUsers = [];
  List<DataGridRow> _usersDataGridRows = [];


  UserDataSource(List<User> users) {
    _usersDataGridRows = users.map<DataGridRow>((user) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: user.id),
        DataGridCell<String>(columnName: 'citizensName', value: user.citizensName),
        DataGridCell<String>(columnName: 'phoneNumber', value: user.phoneNumber),
        DataGridCell<String>(columnName: 'passportNumber', value: user.passportNumber),
        DataGridCell<String>(columnName: 'nationality', value: user.nationality),
        DataGridCell<String>(columnName: 'genre', value: user.genre),
        DataGridCell<String>(columnName: 'age', value: user.age),
        DataGridCell<String>(columnName: 'education', value: user.education),
        DataGridCell<String>(columnName: 'maritalStatus', value: user.maritalStatus),
        DataGridCell<String>(columnName: 'address', value: user.address),
        DataGridCell<String>(columnName: 'notes', value: user.notes),
      ]);
    }).toList();
  }



  // UserDataTableSource(List<User> users) {
  //   this.users = users;
  //   filteredUsers.addAll(users); // Initialize filteredUsers with all users
  //   buildDataGridRows();
  // }


   UserDataTableSource(Box<User> userBox) {
     users = userBox.values.toList();
     filteredUsers.addAll(users); // Initialize filteredUsers with all users
     buildDataGridRows();
   }

  void buildDataGridRows() {
    dataGridRows = filteredUsers.map<DataGridRow>((user) {
      return
        DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: user.id),
        DataGridCell<String>(columnName: 'citizensName', value: user.citizensName),
        DataGridCell<String>(columnName: 'phoneNumber', value: user.phoneNumber),
        DataGridCell<String>(columnName: 'passportNumber', value: user.passportNumber),
        DataGridCell<String>(columnName: 'nationality', value: user.nationality),
        DataGridCell<String>(columnName: 'genre', value: user.genre),
        DataGridCell<String>(columnName: 'age', value: user.age),
        DataGridCell<String>(columnName: 'education', value: user.education),
        DataGridCell<String>(columnName: 'maritalStatus', value: user.maritalStatus),
        DataGridCell<String>(columnName: 'address', value: user.address),
        DataGridCell<String>(columnName: 'notes', value: user.notes),
      ]);
    }).toList();
  }

  void filter(
    String id ,
    String citizensName ,
    String phoneNumber,
    String passportNumber ,
    String nationality,
    String genre ,
    String age ,
    String education ,
    String maritalStatus ,
    String address ,
    String notes ,
  ) {
    filteredUsers = users.where((user) {
      return user.id.toLowerCase().contains(id.toLowerCase()) &&
          user.citizensName.toLowerCase().contains(citizensName.toLowerCase()) &&
          user.phoneNumber.toLowerCase().contains(phoneNumber.toLowerCase()) &&
          user.passportNumber.toLowerCase().contains(passportNumber.toLowerCase()) &&
          user.nationality.toLowerCase().contains(nationality.toLowerCase()) &&
          user.genre.toLowerCase().contains(genre.toLowerCase()) &&
          user.age.toLowerCase().contains(age.toLowerCase()) &&
          user.education.toLowerCase().contains(education.toLowerCase()) &&
          user.maritalStatus.toLowerCase().contains(maritalStatus.toLowerCase()) &&
          user.address.toLowerCase().contains(address.toLowerCase()) &&
          user.notes.toLowerCase().contains(notes.toLowerCase());
    }).toList();
    buildDataGridRows();
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _usersDataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }

  // void updateDataSource(List<User> newUsers) {
  //   users = newUsers;
  //   filter(newUsers); // Reapply the filter on the updated dataset
  //   notifyListeners();
  // }
}


