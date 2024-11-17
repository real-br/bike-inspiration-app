import 'package:bike_inspiration_app/widgets/dropdown_search.dart';
import 'package:bike_inspiration_app/widgets/custom_text_field.dart';
import 'package:bike_inspiration_app/widgets/clickable_list_dialog_button.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'upload_image.dart';

class BikeComponentScreen extends StatefulWidget {
  final String imagePath;

  BikeComponentScreen({required this.imagePath});

  @override
  _BikeComponentScreenState createState() => _BikeComponentScreenState();
}

class _BikeComponentScreenState extends State<BikeComponentScreen> {
  final TextEditingController _yearController = TextEditingController();
  String? _selectedBikeType;
  String? _selectedPriceRange;
  List<String> _inputFields = ["frame", "groupset", "wheels"];
  List<String> _availableComponents = [
    "cassette",
    "chain",
    "crank",
    "handlebar",
    "pedals",
    "saddle",
    "stem",
    "tires"
  ];
  final ScrollController _scrollController = ScrollController();

  final Map<String, TextEditingController> _controllers = {};

  final Map<String, String> _selectedDropdownValues = {};

  final List<String> _bikeTypes = [
    'Road',
    'MTB',
    'Gravel',
    'Triathlon',
    'E-Road',
    'E-MTB',
  ];
  final List<String> _priceRanges = [
    '\$0 - \$3k',
    '\$3k - \$5k',
    '\$5k - \$10k',
    '\$10k+',
  ];

  final Map<String, String> dropdownFilenameLink = {
    "cassette": "cassettes",
    "chain": "chains",
    "crank": "cranks",
    "frame": "frames",
    "groupset": "groupsets",
    "handlebar": "handlebars",
    "pedals": "pedals",
    "saddle": "saddles",
    "stem": "stems",
    "tires": "tires",
    "wheels": "wheels"
  };

  final Map<String, String> dropdownHintTextLink = {
    "cassette": "Cassette Brand",
    "chain": "Chain Brand",
    "crank": "Crank Brand",
    "frame": "Frame Brand",
    "groupset": "Groupset Brand",
    "handlebar": "Handlebar Brand",
    "pedals": "Pedals Brand",
    "saddle": "Saddle Brand",
    "stem": "Stem Brand",
    "tires": "Tire Brand",
    "wheels": "Wheels Brand"
  };

  final Map<String, String> textFieldHintTextLink = {
    "cassette": "Cassette Name",
    "chain": "Chain Name",
    "crank": "Crank Name",
    "frame": "Frame Name",
    "groupset": "Groupset Name",
    "handlebar": "Handlebar Name",
    "pedals": "Pedals Name",
    "saddle": "Saddle Name",
    "stem": "Stem Name",
    "tires": "Tire Name",
    "wheels": "Wheels Name"
  };

  @override
  void initState() {
    super.initState();
    for (var field in _inputFields) {
      _controllers[field] = TextEditingController();
      _selectedDropdownValues[field] = '';
    }
  }

  @override
  void dispose() {
    // Dispose controllers when done
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _removeField(String field) {
    setState(() {
      _inputFields.remove(field);
      _availableComponents.add(field);
      _controllers.remove(field);
      _selectedDropdownValues.remove(field);
    });
  }

  Future<void> _uploadBikeInfo() async {
    final String bikeId = Uuid().v4();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    String imageUrl;
    try {
      File image = File(widget.imagePath);
      if (image != null) {
        imageUrl = await uploadImageToImgur(image);
      } else {
        throw Exception('No image selected');
      }
    } catch (e) {
      if (!mounted) return;
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image')),
      );
      return;
    }

    final Map<String, dynamic> data = {
      "id": bikeId,
      "type": _selectedBikeType,
      "year": _yearController.text,
      "pricerange": _selectedPriceRange,
      "inputfields": _inputFields,
      "image_url": imageUrl,
    };

    for (String field in _inputFields) {
      String? dropdownValue = _selectedDropdownValues[field];
      String? textValue = _controllers[field]?.text;

      if (dropdownValue != null && dropdownValue.isNotEmpty) {
        if (textValue != null && textValue.isNotEmpty) {
          data[field] = "$dropdownValue $textValue";
        }
      }
    }

    final String jsonData = json.encode(data);

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/uploadInfo/'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bike info uploaded successfully!')),
        );
      } else {
        print('Failed to upload bike info');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload bike info')),
        );
      }
    } catch (e) {
      print('Error uploading bike info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  final DateTime firstDate = DateTime.utc(1980, 1, 1);
  final DateTime lastDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new bike'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Bike Type",
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 15),
                          ),
                          value: _selectedBikeType,
                          items: _bikeTypes.map((String bikeType) {
                            return DropdownMenuItem<String>(
                              value: bikeType,
                              child: Text(bikeType.toString().toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedBikeType = newValue;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Price Range",
                            labelStyle: TextStyle(fontSize: 15),
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedPriceRange,
                          items: _priceRanges.map((String priceRange) {
                            return DropdownMenuItem<String>(
                              value: priceRange,
                              child: Text(priceRange.toString().toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPriceRange = newValue;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Year",
                            hintStyle: TextStyle(fontSize: 15),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the year';
                            } else if (int.parse(value) < 1980 ||
                                int.parse(value) > DateTime.now().year) {
                              return 'Input a realistic year';
                            }
                            return null;
                          },
                          controller: _yearController,
                        ),
                        SizedBox(height: 10),
                        for (var field in _inputFields) buildRowForField(field),
                        Row(children: [
                          _availableComponents.isNotEmpty
                              ? ClickableListDialog(
                                  items: _availableComponents
                                      .toSet()
                                      .difference(_inputFields.toSet())
                                      .toList(),
                                  onItemSelected: (value) {
                                    setState(() {
                                      _inputFields.add(value);
                                      _availableComponents.remove(value);
                                      _controllers[value] =
                                          TextEditingController();
                                      _selectedDropdownValues[value] = '';
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    });
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    });
                                  })
                              : Container(),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _uploadBikeInfo();
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.send),
      ),
    );
  }

  Widget buildRowForField(String field) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ReusableDropdown(
                fileName: dropdownFilenameLink[field] ?? '',
                hintText: dropdownHintTextLink[field] ?? '',
                onChanged: (value) {
                  setState(() {
                    _selectedDropdownValues[field] = value!;
                  });
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: CustomTextField(
                controller: _controllers[field]!,
                hintText: textFieldHintTextLink[field] ?? '',
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _removeField(field);
              },
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
