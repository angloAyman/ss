import 'package:flutter/material.dart';

class AddDataDialog extends StatelessWidget {
  final TextEditingController idAddDataController;
  final TextEditingController citizensNameAddDataController;
  final TextEditingController phoneNumberAddDataController;
  final TextEditingController passportNumberAddDataController;
  final TextEditingController nationalityAddDataController;
  final TextEditingController genreAddDataController;
  final TextEditingController ageAddDataController;
  final TextEditingController educationAddDataController;
  final TextEditingController maritalStatusAddDataController;
  final TextEditingController addressAddDataController;
  final TextEditingController notesAddDataController;
  final VoidCallback onSave;

  AddDataDialog({
    required this.idAddDataController,
    required this.citizensNameAddDataController,
    required this.phoneNumberAddDataController,
    required this.passportNumberAddDataController,
    required this.nationalityAddDataController,
    required this.genreAddDataController,
    required this.ageAddDataController,
    required this.educationAddDataController,
    required this.maritalStatusAddDataController,
    required this.addressAddDataController,
    required this.notesAddDataController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Data'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: idAddDataController, decoration: InputDecoration(labelText: 'ID')),
            TextField(controller: citizensNameAddDataController, decoration: InputDecoration(labelText: 'Citizen\'s Name')),
            TextField(controller: phoneNumberAddDataController, decoration: InputDecoration(labelText: 'Phone Number')),
            TextField(controller: passportNumberAddDataController, decoration: InputDecoration(labelText: 'Passport Number')),
            TextField(controller: nationalityAddDataController, decoration: InputDecoration(labelText: 'Nationality')),
            TextField(controller: genreAddDataController, decoration: InputDecoration(labelText: 'Genre')),
            TextField(controller: ageAddDataController, decoration: InputDecoration(labelText: 'Age')),
            TextField(controller: educationAddDataController, decoration: InputDecoration(labelText: 'Education')),
            TextField(controller: maritalStatusAddDataController, decoration: InputDecoration(labelText: 'Marital Status')),
            TextField(controller: addressAddDataController, decoration: InputDecoration(labelText: 'Address')),
            TextField(controller: notesAddDataController, decoration: InputDecoration(labelText: 'Notes')),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onSave();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
