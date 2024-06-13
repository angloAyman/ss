import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

List<GridColumn> getColumns() {
  List<GridColumn> columns;
  columns = ([

    GridColumn(
      columnName: 'id',
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text('كود'),
      ),
    ),
    GridColumn(
      columnName: 'citizensName',
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text('اسم المواطن'),
      ),
    ),
    GridColumn(
      columnName: 'phoneNumber',
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(' رقم الهاتف'),
      ),
    ),
    GridColumn(
      columnName: 'passportNumber',
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text('رقم الجواز'),
      ),
    ),
    GridColumn(
      columnName: 'nationality',
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text('الجنسية'),
      ),
    ),
    GridColumn(
      columnName: 'genre',
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text('الجنس'),
      ),
    ),
    GridColumn(
      columnName: 'age',
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text('العمر'),
      ),
    ),
    GridColumn(
      columnName: 'education',
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text('التعليم'),
      ),
    ),
    GridColumn(
      columnName: 'maritalStatus',
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text('الحالة الاجتماعية'),
      ),
    ),
    GridColumn(
      columnName: 'address',
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text('العنوان'),
      ),
    ),
    GridColumn(
      columnName: 'notes',
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text('ملاحظات'),
      ),
    ),

  ]);
  return columns;
}