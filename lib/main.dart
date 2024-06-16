import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ss/Api/UserAdapter.dart';
import 'package:ss/Api/UserDataSource.dart';
import 'package:ss/Api/user_data_table_source.dart';
import 'package:ss/model/user.dart';
import 'package:ss/widget/GridColumn.dart';
import 'package:ss/widget/add_data_dialog.dart';
import 'package:ss/widget/search_dialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('userBox');
  await loadJsonDataIntoHive();
  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //
  // }

  // await Hive.openBox<User>('userBox');

  runApp(ProviderScope(child: MyApp()));
}
Future<void> loadJsonDataIntoHive() async {
  final box = Hive.box<User>('userBox');
  if (box.isEmpty) {
    final String response = await rootBundle.loadString('assets/data.json');
    final List<dynamic> data = json.decode(response);
    for (var userJson in data) {
      final user = User.fromJson(userJson);
      box.add(user);
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

 // late UserDataTableSource _data;
  late UserDataTableSource _data;
  late Box<User> _userBox;
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    _userBox = Hive.box<User>('userBox');
     Hive.initFlutter().then((_) async {
      Hive.registerAdapter(UserAdapter());
      setState(() {});
    });

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
          onFilter:(){
            _filterData();
            _refreshData();
          } ,
        );

      },
    );
  }

  Future<void> _filterData() async {
    setState(() {
      _data.filter(
        idController.text,
        citizensNameController.text,
        phoneNumberController.text,
        passportNumberController.text,
        nationalityController.text,
        genreController.text,
        ageController.text,
        educationController.text,
        maritalStatusController.text,
        addressController.text,
        notesController.text,
      );
    });


    _clearControllers();
    _refreshData();
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
    if (idController.text.isEmpty) idController.text = 'no data';
    if (citizensNameController.text.isEmpty) citizensNameController.text = 'no data';
    if (phoneNumberController.text.isEmpty) phoneNumberController.text = 'no data';
    if (passportNumberController.text.isEmpty) passportNumberController.text = 'no data';
    if (nationalityController.text.isEmpty) nationalityController.text = 'no data';
    if (genreController.text.isEmpty) genreController.text = 'no data';
    if (ageController.text.isEmpty) ageController.text = 'no data';
    if (educationController.text.isEmpty) educationController.text = 'no data';
    if (maritalStatusController.text.isEmpty) maritalStatusController.text = 'no data';
    if (addressController.text.isEmpty) addressController.text = 'no data';
    if (notesController.text.isEmpty) notesController.text = 'no data';

    // Create a new User object from the input fields
    User newUser = User(
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

    // Add the new user to Hive
    await _userBox.add(newUser);
    _clearControllers();
    _refreshData();
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
    // Since Hive is being used, no need to manually load data
    setState(() {
      _refreshData();
      // _selectedUser = null;
// Initial data load
    });
  }


  void _deleteSelectedUser() {
    if (_selectedUser != null) {
      _userBox.delete(_selectedUser!.key);
      setState(() {
        _selectedUser = null;
        _refreshData();
      });
    }
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
          onSave: () async {
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
            await _userBox.putAt(index, editedUser);
            _updateJsonFile();
            _refreshData();
            _clearControllers();
            _selectedUser = null;

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
    List<Map<String, dynamic>> userList = users.map((user) => user.toJson()).toList();

    String jsonString = jsonEncode(userList);
    File jsonFile = File('assets/data.json');
    await jsonFile.writeAsString(jsonString);
  }

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
            onPressed:
            // _deleteUser
                (){
              _editUser(_selectedUser!);
            } ,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),

        ],
      ),
      body:
      ValueListenableBuilder(
        valueListenable: _userBox.listenable(),
        builder: (context, Box<User> box, _) {
          List<User> users = box.values.toList();
          return Column(
            children: [
              Expanded(
                child: SfDataGrid(
                  source: UserDataSource(users),
                  allowFiltering: true,
                  columns:getColumns(),
                  onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                    if (addedRows.isNotEmpty) {
                      setState(() {
                        _selectedUser = users.firstWhere((user) => user.id == addedRows.first.getCells().first.value);
                      });
                    }
                  },
                  selectionMode: SelectionMode.multiple,
                ),
              ),
              if (_selectedUser != null)
                Card(
                  margin: EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Selected User Details',
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
                            Text('ID: ${_selectedUser!.id}'),
                            Text('Name: ${_selectedUser!.citizensName}'),
                            Text('Phone: ${_selectedUser!.phoneNumber}'),
                            Text('Passport: ${_selectedUser!.passportNumber}'),
                            Text('Nationality: ${_selectedUser!.nationality}'),
                            Text('Genre: ${_selectedUser!.genre}'),
                            Text('Age: ${_selectedUser!.age}'),
                            Text('Education: ${_selectedUser!.education}'),
                            Text('Marital Status: ${_selectedUser!.maritalStatus}'),
                            Text('Address: ${_selectedUser!.address}'),
                            Text('Notes: ${_selectedUser!.notes}'),
                          ],
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            _deleteSelectedUser();
                          },
                          icon: Icon(Icons.delete),
                          label: Text('Delete User'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
