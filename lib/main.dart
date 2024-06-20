import 'dart:convert';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:ss/Api/UserAdapter.dart';
import 'package:ss/Api/UserDataTableSource.dart';
import 'package:ss/model/user.dart';
import 'package:ss/widget/GridColumn.dart';
import 'package:ss/widget/add_data_dialog.dart';
import 'package:ss/widget/search_dialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../helper/save_file_mobile.dart'
if (dart.library.html) '../helper/save_file_web.dart' as helper;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register the UserAdapter
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  // Open the Hive box 'userBox' of type User
  await Hive.openBox<User>('userBox');
  // Load initial data from JSON into Hive if the box is empty
  await loadJsonDataIntoHive();


  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //
  // }


  runApp(ProviderScope(child: MyApp()));
}

Future<void> loadJsonDataIntoHive() async {
  final box = Hive.box<User>('userBox');
  try {
    if (box.isEmpty) {
      // Load JSON data from assets
      final String response = await rootBundle.loadString('assets/data.json');
      final List<dynamic> data = json.decode(response);

      // Add each user from JSON to the Hive box
      for (var userJson in data) {
        final user = User.fromJson(userJson);
        box.add(user);
      }
    }
  } catch (e) {
    print('Error loading JSON data: $e');
    // Handle error loading JSON data (e.g., log, show error message)
  }
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        // const Locale('en', ''),
        const Locale('ar',''),  ],
      debugShowCheckedModeBanner: false,
      title: 'Local JSON Grid App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {

  final TextEditingController idController = TextEditingController();
  final TextEditingController citizensNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passportNumberController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  late Box<User> _userBox;
  late UserDataTableSource _data;
  User? _lastSelectedUser;
  List<DataGridRow> _selectedRows = [];
  List<User> _selectedUsers = [];
  bool _isMultipleSelectionEnabled = false;
  GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();



  @override
  void initState() {
    super.initState();
    _userBox = Hive.box<User>('userBox');
    _refreshData();
  }

  @override
  void dispose() {
    idController.dispose();
    citizensNameController.dispose();
    phoneNumberController.dispose();
    passportNumberController.dispose();
    nationalityController.dispose();
    genreController.dispose();
    ageController.dispose();
    educationController.dispose();
    maritalStatusController.dispose();
    addressController.dispose();
    notesController.dispose();
    Hive.box<User>('userBox').close();
    super.dispose();
  }

  // Future<void> _exportDataGridToPdf() async {
  //   try {
  //     // Show loading indicator or progress dialog
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         content: CircularProgressIndicator(),
  //       ),
  //     );
  //
  //     // Generate PDF content
  //     final pw.Document pdf = pw.Document();
  //
  //     // Add title to PDF
  //     pdf.addPage(
  //       pw.Page(
  //         build: (pw.Context context) => pw.Center(
  //           child: pw.Text('DataGrid Report', style: pw.TextStyle(fontSize: 20)),
  //         ),
  //       ),
  //     );
  //
  //     // Add data grid content to PDF
  //     List<User> users = _selectedRows.map((row) {
  //       // Retrieve User object from _userBox based on id (adjust based on your data structure)
  //       String id = row.getCells()[0].value; // Assuming id is the first column
  //       User user = _userBox.get(id); // Retrieve nullable User object
  //       return user;
  //     }).toList();
  //
  //     List<List<String>> data = users.map((user) => [
  //       user.id,
  //       user.citizensName,
  //       user.phoneNumber,
  //       user.passportNumber,
  //       user.nationality,
  //       user.genre,
  //       user.age,
  //       user.education,
  //       user.maritalStatus,
  //       user.address,
  //       user.notes,
  //     ]).toList();
  //
  //     pdf.addPage(
  //       pw.Page(
  //         build: (pw.Context context) => pw.Center(
  //           child: pw.Table.fromTextArray(
  //             data: <List<String>>[
  //               ['ID', 'Name', 'Phone', 'Passport Number', 'Nationality', 'Genre', 'Age', 'Education', 'Marital Status', 'Address', 'Notes'],
  //               ...data,
  //             ],
  //             headers: <String>['ID', 'Name', 'Phone', 'Passport Number', 'Nationality', 'Genre', 'Age', 'Education', 'Marital Status', 'Address', 'Notes'],
  //             cellAlignment: pw.Alignment.centerLeft,
  //           ),
  //         ),
  //       ),
  //     );
  //
  //     // Save PDF file to local storage
  //     final String dir = (await getApplicationDocumentsDirectory()).path;
  //     final String path = '$dir/DataGrid.pdf';
  //     final File file = File(path);
  //     await file.writeAsBytes(await pdf.save());
  //
  //     // Launch PDF file
  //     await Printing.layoutPdf(
  //       onLayout: (PdfPageFormat format) async => pdf.save(),
  //     );
  //
  //     // Show success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('PDF exported successfully')),
  //     );
  //   } catch (e) {
  //     // Show error message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to export PDF: $e')),
  //     );
  //   } finally {
  //     // Close loading indicator or progress dialog
  //     Navigator.pop(context);
  //   }
  // }

  Future<pw.Font> loadFont() async {
    // final font = await PdfGoogleFonts.nunitoExtraLight();

    final fontData = await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf');
    return pw.Font.ttf(fontData);
  }

  // Future<void> _exportDataGridToPdf() async {
  //   try {
  //     // Show loading indicator or progress dialog
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         content: CircularProgressIndicator(),
  //       ),
  //     );
  //
  //     // Load the custom font
  //     final pw.Font customFont = await loadFont();
  //
  //     // Generate PDF content
  //     final pw.Document pdf = pw.Document();
  //
  //     // Add title to PDF
  //     pdf.addPage(
  //       pw.Page(
  //         build: (pw.Context context) {
  //           return pw.Column(
  //             children: [
  //               pw.Container(
  //                 child: pw.Center(
  //                   child: pw.Text('بيانات المواطنين',
  //                     style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold, fontSize: 40,),
  //                     textDirection: pw.TextDirection.rtl   ,
  //                   ),),
  //
  //                   ),
  //                    pw. Text('الكود: ${_lastSelectedUser!.id}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
  //                   pw.   Text('الاسم: ${_lastSelectedUser!.citizensName}' , textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
  //                   pw.  Text('رقم الهاتف: ${_lastSelectedUser!.phoneNumber}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
  //                   pw.  Text('رقم جواز السفر: ${_lastSelectedUser!.passportNumber}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
  //                   pw.  Text('الجنسية: ${_lastSelectedUser!.nationality}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
  //                   pw.  Text('الجنس: ${_lastSelectedUser!.genre}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
  //                   pw. Text('العمر: ${_lastSelectedUser!.age}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
  //                   pw.  Text('الحالة التعليمية: ${_lastSelectedUser!.education}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
  //                   pw.  Text('الحالة الاجتماعية: ${_lastSelectedUser!.maritalStatus}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
  //                   pw.  Text('العنوان: ${_lastSelectedUser!.address}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
  //                   pw.  Text('ملاحظات: ${_lastSelectedUser!.notes}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
  //
  //           ],
  //
  //         );
  //         },
  //       ),
  //     );
  //
  //     // Add data grid content to PDF
  //
  //
  //     List<User> users = [];
  //     for (var row in _selectedRows) {
  //       String id = row.getCells()[0].value ; // Assuming id is the first column
  //       User? user = _userBox.get(id); // Retrieve nullable User object
  //
  //       if (user != null) {
  //         users.add(user);
  //       } else {
  //         // Handle case where user is not found (optional)
  //         print('User with id $id not found');
  //       }
  //     }
  //
  //     List<List<String>> data = users.map((user) => [
  //       user.id,
  //       user.citizensName,
  //       user.phoneNumber,
  //       user.passportNumber,
  //       user.nationality,
  //       user.genre,
  //       user.age,
  //       user.education,
  //       user.maritalStatus,
  //       user.address,
  //       user.notes,
  //     ]).toList();
  //
  //     pdf.addPage(
  //       pw.Page(
  //         build: (pw.Context context) => pw.Center(
  //           child: pw.Table.fromTextArray(
  //             data:
  //             <List<String>>[
  //               ['id', 'citizensName', 'Phone', 'Passport Number', 'Nationality', 'Genre', 'Age', 'Education', 'Marital Status', 'Address', 'Notes'],
  //               ...data,
  //             ],
  //             headers: <String>['id', 'citizensName', 'Phone', 'Passport Number', 'Nationality', 'Genre', 'Age', 'Education', 'Marital Status', 'Address', 'Notes'],
  //             cellAlignment: pw.Alignment.centerLeft,
  //             cellStyle: pw.TextStyle(font: customFont),
  //             headerStyle: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold),
  //
  //
  //
  //           ),
  //         ),
  //       ),
  //     );
  //
  //
  //
  //
  //     // Save PDF file to local storage
  //     final String dir = (await getApplicationDocumentsDirectory()).path;
  //     final String path = '$dir/DataGrid.pdf';
  //     final File file = File(path);
  //     await file.writeAsBytes(await pdf.save());
  //
  //     // Launch PDF file
  //     await Printing.layoutPdf(
  //       onLayout: (PdfPageFormat format) async => pdf.save(),
  //     );
  //     // Show success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('PDF exported successfully')),
  //     );
  //   } catch (e) {
  //     // Show error message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to export PDF: $e')),
  //     );
  //   } finally {
  //     // Close loading indicator or progress dialog
  //     Navigator.pop(context);
  //   }
  // }
  Future<void> _exportSelectedDataGridToPdf() async {
    try {
      // Show loading indicator or progress dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: CircularProgressIndicator(),
        ),
      );

      // Load the custom font
      final pw.Font customFont = await loadFont();

      // Generate PDF content
      final pw.Document pdf = pw.Document();

      // Add title to PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                    pw.Container(
                         child: pw.Center(
                          child: pw.Text('بيانات المواطنين',
                          style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold, fontSize: 40,),
                          textDirection: pw.TextDirection.rtl   ,
                          ),),
                              ),
                  pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end ,
                         children: [
                         pw. Text('الكود: ${_lastSelectedUser!.id}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
                      pw.   Text('الاسم: ${_lastSelectedUser!.citizensName}' , textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
                      pw.  Text('رقم الهاتف: ${_lastSelectedUser!.phoneNumber}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
                      pw.  Text('رقم جواز السفر: ${_lastSelectedUser!.passportNumber}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
                      pw.  Text('الجنسية: ${_lastSelectedUser!.nationality}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
                      pw.  Text('الجنس: ${_lastSelectedUser!.genre}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
                      pw. Text('العمر: ${_lastSelectedUser!.age}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
                      pw.  Text('الحالة التعليمية: ${_lastSelectedUser!.education}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
                      pw.  Text('الحالة الاجتماعية: ${_lastSelectedUser!.maritalStatus}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
                      pw.  Text('العنوان: ${_lastSelectedUser!.address}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),
                      pw.  Text('ملاحظات: ${_lastSelectedUser!.notes}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold,),),

                    ]
                ),

              ],

            );
          },
        ),
      );

      // Save PDF file to local storage
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String path = '$dir/DataGrid.pdf';
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());

      // Launch PDF file
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF exported successfully')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export PDF: $e')),
      );
    } finally {
      // Close loading indicator or progress dialog
      Navigator.pop(context);
    }
  }

  Future<void> _exportDataGridToExcel() async {
    final Workbook workbook = _key.currentState!.exportToExcelWorkbook();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
  }

  Future<void> _exportSelectedDataGridToExcel() async {
    final Workbook workbook = _key.currentState!.exportToExcelWorkbook(rows:_selectedRows,);

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SearchDialog(
          idSearchController: idController,
          citizensNameSearchController: citizensNameController,
          phoneNumberSearchController: phoneNumberController,
          passportNumberSearchController: passportNumberController,
          nationalitySearchController: nationalityController,
          genreSearchController: genreController,
          ageSearchController: ageController,
          educationSearchController: educationController,
          maritalStatusSearchController: maritalStatusController,
          addressSearchController: addressController,
          notesSearchController: notesController,
          onFilter: () {
            _filterData();
            _clearControllers();
          },
        );
      },
    );
  }

  Future<void> _filterData() async {
    List<User> users = _userBox.values.where((user) {
      bool matches = true;
      if (idController.text.isNotEmpty)
        matches &= user.id.contains(idController.text);
      if (citizensNameController.text.isNotEmpty)
        matches &= user.citizensName.contains(citizensNameController.text);
      if (phoneNumberController.text.isNotEmpty)
        matches &= user.phoneNumber.contains(phoneNumberController.text);
      if (passportNumberController.text.isNotEmpty)
        matches &= user.passportNumber.contains(passportNumberController.text);
      if (nationalityController.text.isNotEmpty)
        matches &= user.nationality.contains(nationalityController.text);
      if (genreController.text.isNotEmpty)
        matches &= user.genre.contains(genreController.text);
      if (ageController.text.isNotEmpty)
        matches &= user.age.contains(ageController.text);
      if (educationController.text.isNotEmpty)
        matches &= user.education.contains(educationController.text);
      if (maritalStatusController.text.isNotEmpty)
        matches &= user.maritalStatus.contains(maritalStatusController.text);
      if (addressController.text.isNotEmpty)
        matches &= user.address.contains(addressController.text);
      if (notesController.text.isNotEmpty)
        matches &= user.notes.contains(notesController.text);
      return matches;
    }).toSet().toList();

    setState(() {
      //UserDataTableSource(users),
      //   _data = UserDataTableSource(filteredUsers);
      // _data = UserDataTableSource(users);
      _data.updateDataSource(users);
    });
  }

  void _openAddDataDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddDataDialog(
          idAddDataController: idController,
          citizensNameAddDataController: citizensNameController,
          phoneNumberAddDataController: phoneNumberController,
          passportNumberAddDataController: passportNumberController,
          nationalityAddDataController: nationalityController,
          genreAddDataController: genreController,
          ageAddDataController: ageController,
          educationAddDataController: educationController,
          maritalStatusAddDataController: maritalStatusController,
          addressAddDataController: addressController,
          notesAddDataController: notesController,
          onSave: _addData,
        );
      },
    );
  }

  Future<void> _addData() async {
    // Check if any text controller is empty and replace it with "no data"
    String newId = idController.text.isEmpty
        ? 'لم يتم ادخال بيانات'
        : idController.text;
    if (idController.text.isEmpty) idController.text = 'لم يتم ادخال بيانات';
    if (citizensNameController.text.isEmpty)
      citizensNameController.text = 'لم يتم ادخال بيانات';
    if (phoneNumberController.text.isEmpty)
      phoneNumberController.text = 'لم يتم ادخال بيانات';
    String newpassportNumber = passportNumberController.text.isEmpty
        ? 'لم يتم ادخال بيانات'
        : passportNumberController.text;
    if (passportNumberController.text.isEmpty)
      passportNumberController.text = 'لم يتم ادخال بيانات';
    if (nationalityController.text.isEmpty)
      nationalityController.text = 'لم يتم ادخال بيانات';
    if (genreController.text.isEmpty)
      genreController.text = 'لم يتم ادخال بيانات';
    if (ageController.text.isEmpty) ageController.text = 'لم يتم ادخال بيانات';
    if (educationController.text.isEmpty)
      educationController.text = 'لم يتم ادخال بيانات';
    if (maritalStatusController.text.isEmpty)
      maritalStatusController.text = 'لم يتم ادخال بيانات';
    if (addressController.text.isEmpty)
      addressController.text = 'لم يتم ادخال بيانات';
    if (notesController.text.isEmpty)
      notesController.text = 'لم يتم ادخال بيانات';


    //bool userExists = _userBox.values.any((user) => user.id == newId,);
    bool userExists2 = _userBox.values.any((user) =>
    user.passportNumber == newpassportNumber);
    if (!userExists2) {
      // Create a new User object from the input fields\
      User newUser = User(
        id: newId,
        citizensName: citizensNameController.text.isEmpty
            ? 'لم يتم ادخال بيانات'
            : citizensNameController.text,
        phoneNumber: phoneNumberController.text.isEmpty
            ? 'لم يتم ادخال بيانات'
            : phoneNumberController.text,
        passportNumber: newpassportNumber,
        nationality: nationalityController.text.isEmpty
            ? 'لم يتم ادخال بيانات'
            : nationalityController.text,
        genre: genreController.text.isEmpty
            ? 'لم يتم ادخال بيانات'
            : genreController.text,
        age: ageController.text.isEmpty ? 'لم يتم ادخال بيانات' : ageController
            .text,
        education: educationController.text.isEmpty
            ? 'لم يتم ادخال بيانات'
            : educationController.text,
        maritalStatus: maritalStatusController.text.isEmpty
            ? 'لم يتم ادخال بيانات'
            : maritalStatusController.text,
        address: addressController.text.isEmpty
            ? 'لم يتم ادخال بيانات'
            : addressController.text,
        notes: notesController.text.isEmpty
            ? 'لم يتم ادخال بيانات'
            : notesController.text,
      );

      await _userBox.add(newUser);
      _clearControllers();
      _refreshData();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' تم الاضافة بنجاح')),);
    }
    else {
      // Show a message that the user already exists
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('مواطن صاحب رقم الجواز $newpassportNumber موجود بالفعل ')),
      );
    }
  }


  void _clearControllers() {
    idController.clear();
    citizensNameController.clear();
    phoneNumberController.clear();
    passportNumberController.clear();
    nationalityController.clear();
    genreController.clear();
    ageController.clear();
    educationController.clear();
    maritalStatusController.clear();
    addressController.clear();
    notesController.clear();
  }

  Future<void> _refreshData() async {
    List<User> userList = _userBox.values.toList();
    // Since Hive is being used, no need to manually load data
    setState(() {
      // _data = UserDataTableSource(_userBox.values.toList());
      _data = UserDataTableSource(userList);
      _selectedRows.clear();
      _selectedUsers.clear();
      _lastSelectedUser = null;
      _clearControllers();
// Initial data load
    });
  }

  void _deleteSelectedUsers() {
    if (_lastSelectedUser != null) {
      _userBox.delete(_lastSelectedUser!.key);
      //   setState(() {
      //     _selectedUser = null;
      //     _refreshData();
      //   });
      // }

      // for (var row  in _selectedRows) {
      //   var user = row.getCells().first.value as User;
      //   _userBox.delete(user.key);
    }
    setState(() {
      _selectedRows.clear();
      _selectedUsers.clear();
      _lastSelectedUser = null;
      _refreshData();
    });

  }

  void _editUser(User user) async {
    idController.text = user.id;
    citizensNameController.text = user.citizensName;
    phoneNumberController.text = user.phoneNumber;
    passportNumberController.text = user.passportNumber;
    nationalityController.text = user.nationality;
    genreController.text = user.genre;
    ageController.text = user.age;
    educationController.text = user.education;
    maritalStatusController.text = user.maritalStatus;
    addressController.text = user.address;
    notesController.text = user.notes;

    showDialog(
      context: context,
      builder: (context) {
        return AddDataDialog(
          idAddDataController: idController,
          citizensNameAddDataController: citizensNameController,
          phoneNumberAddDataController: phoneNumberController,
          passportNumberAddDataController: passportNumberController,
          nationalityAddDataController: nationalityController,
          genreAddDataController: genreController,
          ageAddDataController: ageController,
          educationAddDataController: educationController,
          maritalStatusAddDataController: maritalStatusController,
          addressAddDataController: addressController,
          notesAddDataController: notesController,
          onSave: ()  {
            User editedUser = User(
              id: idController.text,
              citizensName: citizensNameController.text,
              phoneNumber: phoneNumberController.text,
              passportNumber: passportNumberController.text,
              nationality: nationalityController.text,
              genre: genreController.text,
              age: ageController.text,
              education: educationController.text,
              maritalStatus: maritalStatusController.text,
              address: addressController.text,
              notes: notesController.text,
            );

            int index = _userBox.values.toList().indexOf(user);
            _userBox.putAt(index, editedUser);
            _updateJsonFile();
            _refreshData();
            _clearControllers();
            _lastSelectedUser = null;
            //  _lastSelectedUser = User(id: "", citizensName: "", phoneNumber: "", passportNumber: '', nationality: "", genre: "", age: '', education: "", maritalStatus: "", address: "", notes: "");

            //  Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _updateJsonFile() async {
    // Retrieve all users from the Hive box
    List<User> users = _userBox.values.toList();
    // Convert users to JSON format
    List<Map<String, dynamic>> userList = users.map((user) => user.toJson())
        .toList();

    String jsonString = jsonEncode(userList);
    File jsonFile = File('assets/data.json');
    await jsonFile.writeAsString(jsonString);
  }

  void _toggleSelectionMode() {
    setState(() {
      _isMultipleSelectionEnabled = !_isMultipleSelectionEnabled;
      _selectedRows.clear();
      _selectedUsers.clear();
      _lastSelectedUser = null;
    });
  }

//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('بيانات المواطنين السودانين'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: _openSearchDialog,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ValueListenableBuilder(
//               valueListenable: _userBox.listenable(),
//               builder: (context, Box<User> box, _) {
//                 final List<User> users = box.values.toList();
//                 _data = UserDataTableSource(users as Box<User>);
//
//                 return SfDataGrid(
//                   source: _data,
//                   columnWidthMode: ColumnWidthMode.fill,
//                   selectionMode: SelectionMode.single,
//                   onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
//                     if (addedRows.isNotEmpty) {
//                       final index = _data.rows.indexOf(addedRows.first);
//                       _selectedUser = users[index];
//                     } else {
//                       _selectedUser = null;
//                     }
//                   },
//                   columns: getColumns(),
//                 );
//               },
//             ),
//           ),
//           ButtonBar(
//             children: [
//               ElevatedButton(
//                 onPressed: _openAddDataDialog,
//                 child: Text('إضافة'),
//               ),
//               ElevatedButton(
//                 onPressed: _selectedUser != null ? () => _editUser(_selectedUser!) : null,
//                 child: Text('تعديل'),
//               ),
//               ElevatedButton(
//                 onPressed: _selectedUser != null ? _deleteSelectedUser : null,
//                 child: Text('مسح'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('بيانات المواطنين السودانين'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _openSearchDialog,

            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _openAddDataDialog,
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _lastSelectedUser != null ? () => _editUser(_lastSelectedUser!) : null,
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _refreshData,
            ),
            //IconButton لتشغيل multibe selection
            IconButton(
              icon: Icon(_isMultipleSelectionEnabled ? Icons.check_box : Icons.check_box_outline_blank),
              onPressed: _toggleSelectionMode,
            ),
            IconButton(
              icon: Icon(Icons.file_open_outlined),
              onPressed: _exportDataGridToExcel,
            ),
            IconButton(
              icon: Icon(Icons.file_open_sharp),
              onPressed: _exportSelectedDataGridToExcel,
            ),

            // IconButton(
            //   icon: Icon(Icons.picture_as_pdf),
            //   onPressed: () async {
            //     PdfDocument document = _key.currentState!.exportToPdfDocument();
            //     final List<int> bytes = document.saveSync();
            //     await helper.saveAndLaunchFile(bytes, 'DataGrid.pdf');

              // },
            // ),
            // ElevatedButton(
            //     child: Text('Export To Pdf'),
            //     onPressed: () {
            //
            //     }),

            // MaterialButton(
            //     color: Colors.blue,
            //     onPressed: () {
            //       this._dataGridController.selectedRow = null;},
            //     child: const Center(
            //         child: Text(
            //           'clean SelectionMode ',
            //           style: TextStyle(color: Colors.white),
            //         ))),


          ],
        ),

        //   body: _data != null
        //       ? Column(
        //     children: [
        //       Expanded(
        //         child: SfDataGrid(
        //           source: _data,
        //           selectionMode: SelectionMode.multiple,
        //           columnResizeMode: ColumnResizeMode.onResize,
        //           columnWidthMode: ColumnWidthMode.fill,
        //           allowFiltering: true,
        //           onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
        //             if (addedRows.isNotEmpty) {
        //               final int selectedIndex = _data.rows.indexOf(addedRows.first);
        //               final User selectedUser = _data.user[selectedIndex];
        //               setState(() {
        //                 _selectedRows = addedRows;
        //                 _lastSelectedUser = selectedUser;
        //               });
        //             } else {
        //               setState(() {
        //                 _selectedRows.clear();
        //                 _lastSelectedUser = null;
        //               });
        //             }
        //           },
        //           columns: [
        //             GridColumn(columnName: 'id', label: Text('ID')),
        //             GridColumn(columnName: 'citizensName', label: Text('اسم المواطن')),
        //             GridColumn(columnName: 'phoneNumber', label: Text('رقم الهاتف')),
        //             GridColumn(columnName: 'passportNumber', label: Text('رقم الجواز')),
        //             GridColumn(columnName: 'nationality', label: Text('الجنسية')),
        //             GridColumn(columnName: 'genre', label: Text('النوع')),
        //             GridColumn(columnName: 'age', label: Text('العمر')),
        //             GridColumn(columnName: 'education', label: Text('التعليم')),
        //             GridColumn(columnName: 'maritalStatus', label: Text('الحالة الاجتماعية')),
        //             GridColumn(columnName: 'address', label: Text('العنوان')),
        //             GridColumn(columnName: 'notes', label: Text('ملاحظات')),
        //           ],
        //         ),
        //       ),
        //       if (_lastSelectedUser != null)
        //       Card(
        //                     margin: EdgeInsets.all(16),
        //                     child: Padding(
        //                       padding: const EdgeInsets.all(16.0),
        //                       child: Column(
        //                         children: [
        //                           Text(
        //                             'بيانات المواطن',
        //                             style: TextStyle(
        //                               fontSize: 20,
        //                               fontWeight: FontWeight.bold,
        //                             ),
        //                           ),
        //                           SizedBox(height: 8),
        //                           GridView(
        //                             shrinkWrap: true,
        //                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //                               crossAxisCount: 3,
        //                               childAspectRatio: 20,
        //                               crossAxisSpacing: 2,
        //                               mainAxisSpacing: 10,
        //                             ),
        //                             children: [
        //                               Text('الكود: ${_lastSelectedUser!.id}'),
        //                               Text('الاسم: ${_lastSelectedUser!.citizensName}'),
        //                               Text('رقم الهاتف: ${_lastSelectedUser!
        //                                   .phoneNumber}'),
        //                               Text('رقم جواز السفر: ${_lastSelectedUser!
        //                                   .passportNumber}'),
        //                               Text('الجنسية: ${_lastSelectedUser!.nationality}'),
        //                               Text('الجنس: ${_lastSelectedUser!.genre}'),
        //                               Text('العمر: ${_lastSelectedUser!.age}'),
        //                               Text('الحالة التعليمية: ${_lastSelectedUser!
        //                                   .education}'),
        //                               Text('الحالة الاجتماعية: ${_lastSelectedUser!
        //                                   .maritalStatus}'),
        //                               Text('العنوان: ${_lastSelectedUser!.address}'),
        //                               Text('ملاحظات: ${_lastSelectedUser!.notes}'),
        //                             ],
        //                           ),
        //                           SizedBox(height: 16),
        //                           ElevatedButton.icon(
        //                             onPressed: () {
        //                               _deleteSelectedUsers();
        //                               _clearControllers();
        //                               //_refreshData();
        //                             },
        //                             icon: Icon(Icons.delete),
        //                             label: Text('حذف المواطن'),
        //                             style: ElevatedButton.styleFrom(
        //                               backgroundColor: Colors.red,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //     ],
        //   )
        //       : Center(child: CircularProgressIndicator()),
        // );
// ####################################################################
//   second code
//   ######################################################################
        body:
        Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _userBox.listenable(),
                  builder: (context, Box<User> box, _) {
                    // List<User> users = box.values.toList();
                     // _data = UserDataTableSource(users);
                    return
                      SfDataGrid(
                        key: _key,
                        source:
                        _data,
                        // UserDataTableSource(users),
                        columnResizeMode: ColumnResizeMode.onResize,
                        columnWidthMode: ColumnWidthMode.fill,
                        allowFiltering: true,
                        selectionMode: _isMultipleSelectionEnabled ? SelectionMode.multiple : SelectionMode.single,
                        // selectionMode: SelectionMode.multiple,
                        columns: getColumns(),

                        onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                          setState(() {
                            _selectedRows.addAll(addedRows);
                            _selectedRows.removeWhere((row) => removedRows.contains(row));
                            _selectedUsers.clear();
                            for (var row in _selectedRows) {
                              var user = _userBox.values.firstWhere((u) => u.id == row.getCells()[0].value);
                              _selectedUsers.add(user);
                              _lastSelectedUser = user;
                            }
                          });
                        },




                        // onSelectionChanged: (List<DataGridRow> addedRows,List<DataGridRow> removedRows) {
                        //   setState(() {
                        //     _selectedRows.addAll(addedRows);
                        //     _selectedRows.removeWhere((row) => removedRows.contains(row));
                        //     if (_selectedRows.isNotEmpty) {
                        //       _lastSelectedUser = _selectedRows.last.getCells().first.value as User;
                        //     }
                        //   });
                        // },

                        //     onSelectionChanged:
                        //         (List<DataGridRow> addedRows,List<DataGridRow> removedRows) {
                        //       setState(() {
                        //         _selectedUsers.clear();
                        //         for (var row in addedRows) {
                        //           var user = users.firstWhere((u) =>
                        //           u.id == row.getCells()[0].value);
                        //           _selectedUsers.add(user);
                        //           _lastSelectedUser = user;
                        //         }
                        //       });
                        // },
                        // if (addedRows.isNotEmpty) {
                        //   setState(() {
                        //     _lastselectedUser = users.firstWhere((user) => user.id == addedRows.first.getCells().first.value);
                        //     _selectedUser.clear();
                        //     _selectedUser.addAll(addedRows.map((row) => row.getCells()[0].value as User));
                        //   });

                      );
                  },
                ),
              ),
              if (_lastSelectedUser != null)
              //لو مش عايزين كارت العريف يظهر مع التحدبد الجماعي
              //if (_lastSelectedUser != null && _isMultipleSelectionEnabled == false )
                Card(
                  margin: EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'بيانات المواطن',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        GridView(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 20,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 10,
                          ),
                          children: [
                            Text('الكود: ${_lastSelectedUser!.id}'),
                            Text('الاسم: ${_lastSelectedUser!.citizensName}'),
                            Text('رقم الهاتف: ${_lastSelectedUser!
                                .phoneNumber}'),
                            Text('رقم جواز السفر: ${_lastSelectedUser!
                                .passportNumber}'),
                            Text('الجنسية: ${_lastSelectedUser!.nationality}'),
                            Text('الجنس: ${_lastSelectedUser!.genre}'),
                            Text('العمر: ${_lastSelectedUser!.age}'),
                            Text('الحالة التعليمية: ${_lastSelectedUser!
                                .education}'),
                            Text('الحالة الاجتماعية: ${_lastSelectedUser!
                                .maritalStatus}'),
                            Text('العنوان: ${_lastSelectedUser!.address}'),
                            Text('ملاحظات: ${_lastSelectedUser!.notes}'),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _deleteSelectedUsers();
                                  _clearControllers();
                                  //_refreshData();
                                },
                                icon: Icon(Icons.delete),
                                label: Text('حذف المواطن'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _exportSelectedDataGridToPdf();

                                  //_refreshData();
                                },
                                icon: Icon(Icons.print),
                                label: Text('طباعة تقرير ببيانات المواطن '),
                                style: ElevatedButton.styleFrom(
                                  //  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
            ]
        )
    );
  }
}

