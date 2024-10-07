import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<String>> fetchDropdownData(String fileName) async {
  final response = await http
      .get(Uri.parse('http://192.168.1.3:8000/dropdown_data/$fileName'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => item['name'].toString()).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class ReusableDropdown extends StatelessWidget {
  final String fileName;
  final String hintText;
  final ValueChanged<String?> onChanged;

  ReusableDropdown({
    required this.fileName,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchDropdownData(fileName),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return DropdownSearch<String>(
            items: (f, cs) => snapshot.data!,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 14),
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: onChanged,
            popupProps: PopupProps.menu(
              showSearchBox: true,
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }
}
