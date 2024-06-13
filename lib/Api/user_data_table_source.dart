// // import 'package:flutter/material.dart';
// // import 'package:ss/model/user.dart';
// //
// // class UserDataTableSource extends DataTableSource {
// //   final List<User> originalUsers;
// //   List<User> filteredUsers;
// //   final Function(int) deleteUser;
// //
// //
// //   UserDataTableSource(this.originalUsers, this.deleteUser) : filteredUsers = List.from(originalUsers);
// //
// //
// //
// //   void filter(String id, String citizensName, String phoneNumber, String passportNumber, String nationality, String genre, String age, String education, String maritalStatus, String address, String notes) {
// //     filteredUsers = originalUsers.where((user) {
// //       return user.id.contains(id) &&
// //           user.citizensName.contains(citizensName) &&
// //           user.phoneNumber.contains(phoneNumber) &&
// //           user.passportNumber.contains(passportNumber) &&
// //           user.nationality.contains(nationality) &&
// //           user.genre.contains(genre) &&
// //           user.age.contains(age) &&
// //           user.education.contains(education) &&
// //           user.maritalStatus.contains(maritalStatus) &&
// //           user.address.contains(address) &&
// //           user.notes.contains(notes);
// //     }).toList();
// //     notifyListeners();
// //   }
// //
// //   @override
// //   DataRow? getRow(int index) {
// //     if (index >= filteredUsers.length) return null;
// //     final user = filteredUsers[index];
// //     return DataRow.byIndex(
// //       index: index,
// //       cells: [
// //         DataCell(Text(user.id)),
// //         DataCell(Text(user.citizensName)),
// //         DataCell(Text(user.phoneNumber)),
// //         DataCell(Text(user.passportNumber)),
// //         DataCell(Text(user.nationality)),
// //         DataCell(Text(user.genre)),
// //         DataCell(Text(user.age)),
// //         DataCell(Text(user.education)),
// //         DataCell(Text(user.maritalStatus)),
// //         DataCell(Text(user.address)),
// //         DataCell(Text(user.notes)),
// //       ],
// //     );
// //   }
// //
// //   @override
// //   bool get isRowCountApproximate => false;
// //
// //   @override
// //   int get rowCount => filteredUsers.length;
// //
// //   @override
// //   int get selectedRowCount => 0;
// // }
// //
// //
// // // ######################################
// // // second code
// // // #######################################
// // import 'package:flutter/material.dart';
// // import 'package:ss/model/user.dart';
// //
// // class UserDataTableSource extends DataTableSource {
// //   final List<User> originalUsers;
// //   List<User> filteredUsers;
// //   final Function(User) onRowTap; // Callback function for row tap
// //
// //
// //   UserDataTableSource(this.originalUsers, this.onRowTap)
// //       : filteredUsers = List.from(originalUsers);
// //
// //
// //   void filter(String id, String citizensName, String phoneNumber, String passportNumber, String nationality, String genre, String age, String education, String maritalStatus, String address, String notes) {
// //     filteredUsers = originalUsers.where((user) {
// //       return user.id.contains(id) &&
// //           user.citizensName.contains(citizensName) &&
// //           user.phoneNumber.contains(phoneNumber) &&
// //           user.passportNumber.contains(passportNumber) &&
// //           user.nationality.contains(nationality) &&
// //           user.genre.contains(genre) &&
// //           user.age.contains(age) &&
// //           user.education.contains(education) &&
// //           user.maritalStatus.contains(maritalStatus) &&
// //           user.address.contains(address) &&
// //           user.notes.contains(notes);
// //     }).toList();
// //     notifyListeners();
// //   }
// //
// //
// //   void _selectRow(int index) {
// //     final user = filteredUsers[index];
// //     user.isSelected = !user.isSelected;
// //     notifyListeners();
// //   }
// //
// //   @override
// //   DataRow? getRow(int index) {
// //     if (index >= filteredUsers.length) return null;
// //     final user = filteredUsers[index];
// //     return DataRow.byIndex(
// //       index: index,
// //       color: user.isSelected
// //           ? MaterialStateColor.resolveWith((states) {
// //         return Colors.blue.withOpacity(0.3); // Change color for selected row
// //       })
// //           : null, // Use default color for unselected rows
// //       cells: [
// //         DataCell(Text(user.id)),
// //         DataCell(Text(user.citizensName)),
// //         DataCell(Text(user.phoneNumber)),
// //         DataCell(Text(user.passportNumber)),
// //         DataCell(Text(user.nationality)),
// //         DataCell(Text(user.genre)),
// //         DataCell(Text(user.age)),
// //         DataCell(Text(user.education)),
// //         DataCell(Text(user.maritalStatus)),
// //         DataCell(Text(user.address)),
// //         DataCell(Text(user.notes)),
// //         DataCell(
// //           Checkbox(
// //             value: user.isSelected,
// //             onChanged: (_) => _selectRow(index),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   @override
// //   bool get isRowCountApproximate => false;
// //
// //   @override
// //   int get rowCount => filteredUsers.length;
// //
// //   @override
// //   int get selectedRowCount => filteredUsers.where((user) => user.isSelected).length;
// // }
// //#########################################################
//
// // import 'package:flutter/material.dart';
// // import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// // import 'package:hive/hive.dart';
// // import 'package:ss/model/user.dart';
// //
// // class UserDataTableSource extends DataGridSource  {
// //   late List<User> users;
// //   late List<DataGridRow> dataGridRows;
// //   late List<User> filteredUsers;
// //
// //
// //   UserDataTableSource(Box<User> userBox) {
// //     users = userBox.values.toList();
// //     filteredUsers = List.from(users); // Initialize filteredUsers with all users
// //     buildDataGridRows();
// //   }
// //
// //   void buildDataGridRows() {
// //    // dataGridRows = users.map<DataGridRow>((user) {
// //       dataGridRows = filteredUsers.map<DataGridRow>((user) {
// //
// //       return DataGridRow(cells: [
// //         DataGridCell<String>(columnName: 'id', value: user.id),
// //         DataGridCell<String>(
// //             columnName: 'citizensName', value: user.citizensName),
// //         DataGridCell<String>(
// //             columnName: 'phoneNumber', value: user.phoneNumber),
// //         DataGridCell<String>(
// //             columnName: 'passportNumber', value: user.passportNumber),
// //         DataGridCell<String>(
// //             columnName: 'nationality', value: user.nationality),
// //         DataGridCell<String>(columnName: 'genre', value: user.genre),
// //         DataGridCell<String>(columnName: 'age', value: user.age),
// //         DataGridCell<String>(columnName: 'education', value: user.education),
// //         DataGridCell<String>(
// //             columnName: 'maritalStatus', value: user.maritalStatus),
// //         DataGridCell<String>(columnName: 'address', value: user.address),
// //         DataGridCell<String>(columnName: 'notes', value: user.notes),
// //       ]);
// //     }).toList();
// //   }
// //
// //   void filter({
// //   required String id ,
// //     required String citizensName ,
// //     required  String phoneNumber ,
// //     required  String passportNumber,
// //     required String nationality ,
// //     required String genre ,
// //     required String age ,
// //     required String education ,
// //     required String maritalStatus ,
// //     required String address ,
// //     required  String notes,
// //   }
// //    ) {
// //     filteredUsers = users.where((user) {
// //       return user.id.toLowerCase().contains(id.toLowerCase()) &&
// //           user.citizensName.toLowerCase().contains(citizensName.toLowerCase()) &&
// //           user.phoneNumber.toLowerCase().contains(phoneNumber.toLowerCase()) &&
// //           user.passportNumber.toLowerCase().contains(passportNumber.toLowerCase()) &&
// //           user.nationality.toLowerCase().contains(nationality.toLowerCase()) &&
// //           user.genre.toLowerCase().contains(genre.toLowerCase()) &&
// //           user.age.toLowerCase().contains(age.toLowerCase()) &&
// //           user.education.toLowerCase().contains(education.toLowerCase()) &&
// //           user.maritalStatus.toLowerCase().contains(maritalStatus.toLowerCase()) &&
// //           user.address.toLowerCase().contains(address.toLowerCase()) &&
// //           user.notes.toLowerCase().contains(notes.toLowerCase());
// //     }).toList();
// //
// //     buildDataGridRows();
// //     notifyListeners();
// //   }
// //
// //   void updateDataSource(List<User> newUsers, {
// //     String id = '',
// //     String citizensName = '',
// //     String phoneNumber = '',
// //     String passportNumber = '',
// //     String nationality = '',
// //     String genre = '',
// //     String age = '',
// //     String education = '',
// //     String maritalStatus = '',
// //     String address = '',
// //     String notes = '',
// //   }) {
// //     users = newUsers;
// //     filter(
// //       id: id,
// //       citizensName: citizensName,
// //       phoneNumber: phoneNumber,
// //       passportNumber: passportNumber,
// //       nationality: nationality,
// //       genre: genre,
// //       age: age,
// //       education: education,
// //       maritalStatus: maritalStatus,
// //       address: address,
// //       notes: notes,
// //     );
// //
// //     notifyListeners();
// //   }
// //
// //   @override
// //   List<DataGridRow> get rows => dataGridRows;
// //
// //   @override
// //   DataGridRowAdapter buildRow(DataGridRow row) {
// //     return DataGridRowAdapter(cells: row.getCells().map<Widget>((dataGridCell) {
// //       return Container(
// //         alignment: Alignment.center,
// //         padding: EdgeInsets.all(8.0),
// //         child: Text(dataGridCell.value.toString()),
// //       );
// //     }).toList());
// //   }
// // }
//   //
//   // void updateDataSource(List<User> newUsers) {
//   //   users = newUsers;
//   //   filter(); // Reapply the filter on the updated dataset
//   //
//   //  // buildDataGridRows();
//   //   notifyListeners();
//   // }
// //######################################################3
// //
// // import 'package:flutter/material.dart';
// // import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// // import 'package:hive/hive.dart';
// // import 'package:ss/model/user.dart';
// //
// // class UserDataTableSource extends DataGridSource {
// //   List<User> users = [];
// //   List<DataGridRow> dataGridRows = [];
// //   List<User> filteredUsers = [];
// //
// //   UserDataTableSource(Box<User> userBox) {
// //     users = userBox.values.toList();
// //     filteredUsers.addAll(users); // Initialize filteredUsers with all users
// //     buildDataGridRows();
// //   }
// //
// //   void buildDataGridRows() {
// //     // dataGridRows = users.map<DataGridRow>((user) {
// //     dataGridRows = filteredUsers.map<DataGridRow>((user) {
// //
// //       return DataGridRow(cells: [
// //         DataGridCell<String>(columnName: 'id', value: user.id),
// //         DataGridCell<String>(
// //             columnName: 'citizensName', value: user.citizensName),
// //         DataGridCell<String>(
// //             columnName: 'phoneNumber', value: user.phoneNumber),
// //         DataGridCell<String>(
// //             columnName: 'passportNumber', value: user.passportNumber),
// //         DataGridCell<String>(
// //             columnName: 'nationality', value: user.nationality),
// //         DataGridCell<String>(columnName: 'genre', value: user.genre),
// //         DataGridCell<String>(columnName: 'age', value: user.age),
// //         DataGridCell<String>(columnName: 'education', value: user.education),
// //         DataGridCell<String>(
// //             columnName: 'maritalStatus', value: user.maritalStatus),
// //         DataGridCell<String>(columnName: 'address', value: user.address),
// //         DataGridCell<String>(columnName: 'notes', value: user.notes),
// //       ]);
// //     }).toList();
// //   }
// //
// //   void filter({
// //     String id = '',
// //     String citizensName = '',
// //     String phoneNumber = '',
// //     String passportNumber = '',
// //     String nationality = '',
// //     String genre = '',
// //     String age = '',
// //     String education = '',
// //     String maritalStatus = '',
// //     String address = '',
// //     String notes = '',
// //   }) {
// //     filteredUsers = users.where((user) {
// //       return user.id.toLowerCase().contains(id.toLowerCase()) &&
// //           user.citizensName.toLowerCase().contains(citizensName.toLowerCase()) &&
// //           user.phoneNumber.toLowerCase().contains(phoneNumber.toLowerCase()) &&
// //           user.passportNumber.toLowerCase().contains(passportNumber.toLowerCase()) &&
// //           user.nationality.toLowerCase().contains(nationality.toLowerCase()) &&
// //           user.genre.toLowerCase().contains(genre.toLowerCase()) &&
// //           user.age.toLowerCase().contains(age.toLowerCase()) &&
// //           user.education.toLowerCase().contains(education.toLowerCase()) &&
// //           user.maritalStatus.toLowerCase().contains(maritalStatus.toLowerCase()) &&
// //           user.address.toLowerCase().contains(address.toLowerCase()) &&
// //           user.notes.toLowerCase().contains(notes.toLowerCase());
// //     }).toList();
// //
// //     buildDataGridRows();
// //     notifyListeners();
// //   }
// //
// //   @override
// //   List<DataGridRow> get rows => dataGridRows;
// //
// //   @override
// //   DataGridRowAdapter buildRow(DataGridRow row) {
// //     return DataGridRowAdapter(cells: row.getCells().map<Widget>((dataGridCell) {
// //       return Container(
// //         alignment: Alignment.center,
// //         padding: EdgeInsets.all(8.0),
// //         child: Text(dataGridCell.value.toString()),
// //       );
// //     }).toList());
// //   }
// //
// //
// //   void updateDataSource(List<User> newUsers) {
// //     users = newUsers;
// //     filter(); // Reapply the filter on the updated dataset
// //
// //     // buildDataGridRows();
// //     notifyListeners();
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:ss/model/user.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//
// class UserDataTableSource extends DataGridSource {
//   List<DataGridRow> _usersDataGridRows = [];
//
// //  List<DataGridRow> _users = [];
//
//   UserDataTableSource(List<User> users) {
//     _usersDataGridRows  = users
//         .map<DataGridRow>((user) => DataGridRow(cells: [
//       DataGridCell<String>(columnName: 'ID', value: user.id),
//       DataGridCell<String>(columnName: 'Citizens Name', value: user.citizensName),
//       DataGridCell<String>(columnName: 'Phone Number', value: user.phoneNumber),
//       DataGridCell<String>(columnName: 'Passport Number', value: user.passportNumber),
//       DataGridCell<String>(columnName: 'Nationality', value: user.nationality),
//       DataGridCell<String>(columnName: 'Genre', value: user.genre),
//       DataGridCell<String>(columnName: 'Age', value: user.age),
//       DataGridCell<String>(columnName: 'Education', value: user.education),
//       DataGridCell<String>(columnName: 'Marital Status', value: user.maritalStatus),
//       DataGridCell<String>(columnName: 'Address', value: user.address),
//       DataGridCell<String>(columnName: 'Notes', value: user.notes),
//     ]))
//         .toList();
//   }
//
//   @override
//   List<DataGridRow> get rows => _usersDataGridRows ;
//
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

import 'package:flutter/material.dart';
import 'package:ss/model/user.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserDataSource extends DataGridSource {
  List<DataGridRow> _userDataGridRows = [];
  List<User> _users = [];


 // void filter({
//     String id = '',
//     String citizensName = '',
//     String phoneNumber = '',
//     String passportNumber = '',
//     String nationality = '',
//     String genre = '',
//     String age = '',
//     String education = '',
//     String maritalStatus = '',
//     String address = '',
//     String notes = '',
//   }) {
//     filteredUsers = users.where((user) {
//       return user.id.toLowerCase().contains(id.toLowerCase()) &&
//           user.citizensName.toLowerCase().contains(citizensName.toLowerCase()) &&
//           user.phoneNumber.toLowerCase().contains(phoneNumber.toLowerCase()) &&
//           user.passportNumber.toLowerCase().contains(passportNumber.toLowerCase()) &&
//           user.nationality.toLowerCase().contains(nationality.toLowerCase()) &&
//           user.genre.toLowerCase().contains(genre.toLowerCase()) &&
//           user.age.toLowerCase().contains(age.toLowerCase()) &&
//           user.education.toLowerCase().contains(education.toLowerCase()) &&
//           user.maritalStatus.toLowerCase().contains(maritalStatus.toLowerCase()) &&
//           user.address.toLowerCase().contains(address.toLowerCase()) &&
//           user.notes.toLowerCase().contains(notes.toLowerCase());
//     }).toList();
//
//     buildDataGridRows();
//     notifyListeners();
//   }



  UserDataSource(List<User> users) {
    _users = users;
    _userDataGridRows = users.map<DataGridRow>((user) {
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
        // DataGridCell<Widget>(columnName: 'actions', value: Container()),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _userDataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'actions') {
          return cell.value;
        }
        return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8.0),
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}

extension on User {
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