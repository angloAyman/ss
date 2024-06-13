import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  final TextEditingController idSearchController;
  final TextEditingController citizensNameSearchController;
  final TextEditingController phoneNumberSearchController;
  final TextEditingController passportNumberSearchController;
  final TextEditingController nationalitySearchController;
  final TextEditingController genreSearchController;
  final TextEditingController ageSearchController;
  final TextEditingController educationSearchController;
  final TextEditingController maritalStatusSearchController;
  final TextEditingController addressSearchController;
  final TextEditingController notesSearchController;
  final VoidCallback onFilter;

  SearchDialog({
    required this.idSearchController,
    required this.citizensNameSearchController,
    required this.phoneNumberSearchController,
    required this.passportNumberSearchController,
    required this.nationalitySearchController,
    required this.genreSearchController,
    required this.ageSearchController,
    required this.educationSearchController,
    required this.maritalStatusSearchController,
    required this.addressSearchController,
    required this.notesSearchController,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Search Filters'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: idSearchController, decoration: InputDecoration(labelText: 'ID')),
            TextField(controller: citizensNameSearchController, decoration: InputDecoration(labelText: 'Citizen\'s Name')),
            TextField(controller: phoneNumberSearchController, decoration: InputDecoration(labelText: 'Phone Number')),
            TextField(controller: passportNumberSearchController, decoration: InputDecoration(labelText: 'Passport Number')),
            TextField(controller: nationalitySearchController, decoration: InputDecoration(labelText: 'Nationality')),
            TextField(controller: genreSearchController, decoration: InputDecoration(labelText: 'Genre')),
            TextField(controller: ageSearchController, decoration: InputDecoration(labelText: 'Age')),
            TextField(controller: educationSearchController, decoration: InputDecoration(labelText: 'Education')),
            TextField(controller: maritalStatusSearchController, decoration: InputDecoration(labelText: 'Marital Status')),
            TextField(controller: addressSearchController, decoration: InputDecoration(labelText: 'Address')),
            TextField(controller: notesSearchController, decoration: InputDecoration(labelText: 'Notes')),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onFilter();
          },
          child: Text('Apply'),
        ),
      ],
    );
  }
}
