// import 'package:flutter/material.dart';
//
// class SearchDialog extends StatefulWidget {
//   final Function(String, String, String, String, String, String, String, String, String, String, String) onFilter;
//
//   SearchDialog({required this.onFilter});
//
//   @override
//   _SearchDialogState createState() => _SearchDialogState();
// }
//
// class _SearchDialogState extends State<SearchDialog> {
//   final _idController = TextEditingController();
//   final _citizensNameController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _passportNumberController = TextEditingController();
//   final _nationalityController = TextEditingController();
//   final _genreController = TextEditingController();
//   final _ageController = TextEditingController();
//   final _educationController = TextEditingController();
//   final _maritalStatusController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _notesController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Search'),
//       content: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildTextField('ID', _idController),
//             _buildTextField('Citizens Name', _citizensNameController),
//             _buildTextField('Phone Number', _phoneNumberController),
//             _buildTextField('Passport Number', _passportNumberController),
//             _buildTextField('Nationality', _nationalityController),
//             _buildTextField('Genre', _genreController),
//             _buildTextField('Age', _ageController),
//             _buildTextField('Education', _educationController),
//             _buildTextField('Marital Status', _maritalStatusController),
//             _buildTextField('Address', _addressController),
//             _buildTextField('Notes', _notesController),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             widget.onFilter(
//               _idController.text,
//               _citizensNameController.text,
//               _phoneNumberController.text,
//               _passportNumberController.text,
//               _nationalityController.text,
//               _genreController.text,
//               _ageController.text,
//               _educationController.text,
//               _maritalStatusController.text,
//               _addressController.text,
//               _notesController.text,
//             );
//             Navigator.of(context).pop();
//           },
//           child: Text('Filter'),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }
//
//



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
