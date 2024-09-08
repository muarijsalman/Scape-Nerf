import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddAddressForm extends StatefulWidget {
  const AddAddressForm({super.key});

  @override
  State<AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  final TextEditingController _flatNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Address'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromRGBO(143, 148, 251, 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeader(),
              _buildRoundedTextField(
                'Flat Number/House Number',
                _flatNumberController,
              ),
              _buildRoundedTextField('Street', _streetController),
              _buildRoundedTextField('Area', _areaController, isArea: true),
              _buildRoundedTextField('City', _cityController),
              _buildRoundedTextField('Sector', _sectorController),
              _buildRoundedTextField('Postal code', _postalCodeController,
                  borderBottom: true),
              _buildRoundedTextField(
                'Description',
                _descriptionController,
                maxLines: 5, // Set maximum lines for the description field
              ),
              _buildSubmitButton(context),
              const SizedBox(
                height: 5,
              ),
              if (_selectedImages.isNotEmpty) const SizedBox(height: 10),
              const Text('Selected Images:'),
              const SizedBox(height: 5),
              Container(
                height: 100, // Adjust the height as needed
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _selectedImages.asMap().entries.map((entry) {
                      int index = entry.key;
                      File image = entry.value;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImages.removeAt(index);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 80,
                          width: 80,
                          child: Image.file(image, fit: BoxFit.cover),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        'Add Property Details',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRoundedTextField(
    String hintText,
    TextEditingController controller, {
    double fontSize = 18,
    bool bold = false,
    bool borderBottom = false,
    bool isArea = false,
    int maxLines = 1, // Added maxLines parameter
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isArea
              ? Colors.transparent
              : const Color.fromRGBO(143, 148, 251, 1),
          width: isArea ? 0 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLength: 50,
        // Set character limit
        maxLines: maxLines,
        // Set maximum lines
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
        decoration: InputDecoration(
          counterText: '', // Hide character counter
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImages,
            child: const Text('Select Images'),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Tooltip(
              message:
                  'Video must be a stable recording with adequate coverage of areas for best results.',
              child: ElevatedButton.icon(
                onPressed: _pickVideo,
                icon: Icon(Icons.video_library),
                label: Text('Select Video (Max 15 seconds)'),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromRGBO(143, 148, 251, 1),
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              // Perform validation and submit logic
              if (_validateFields()) {
                _submitData();
              } else {
                // Show an error message if validation fails
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            child: Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _submitting
                      ? const CircularProgressIndicator()
                      : Text(
                          'Submit',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _validateFields() {
    return _flatNumberController.text.isNotEmpty &&
        _streetController.text.isNotEmpty &&
        _areaController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _sectorController.text.isNotEmpty &&
        _postalCodeController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty;
  }

  void _submitData() async {
    setState(() {
      _submitting = true;
    });
    if (_validateFields() && _selectedImages.isNotEmpty) {
      String flatNumber = _flatNumberController.text;
      String street = _streetController.text;
      String city = _cityController.text;
      String sector = _sectorController.text;
      String description = _descriptionController.text;

      String address = '$street, $sector, $city';

      // Upload images to Firebase Storage
      Map<dynamic, dynamic> imageUrls = await _uploadImages(); // Modified call

      Map<String, dynamic> propertyData = {
        "name": flatNumber,
        "address": address,
        "description": description,
        "images": imageUrls,
      };

      dbRef.child("Properties").push().set(propertyData).then((value) {
        _flatNumberController.clear();
        _areaController.clear();
        _postalCodeController.clear();
        _streetController.clear();
        _cityController.clear();
        _sectorController.clear();
        _descriptionController.clear();
        _selectedImages.clear();
      });

      if (_selectedVideo != null) {
        await _sendVideo();
      }
      setState(() {
        _submitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property added successfully')),
      );
    } else {
      setState(() {
        _submitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please fill in all fields and select at least one image'),
        ),
      );
    }
  }

  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    try {
      final pickedImages = await ImagePicker().pickMultiImage();
      if (pickedImages != null) {
        setState(() {
          _selectedImages =
              pickedImages.map((image) => File(image.path)).toList();
        });
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

// Function to upload selected images to Firebase Storage
  Future<Map<dynamic, dynamic>> _uploadImages() async {
    Map<dynamic, dynamic> uploadedImageUrls = {};
    for (int i = 0; i < _selectedImages.length; i++) {
      File imageFile = _selectedImages[i];
      String extension = imageFile.path.split('.').last;
      String imageName =
          'image${DateTime.now().millisecondsSinceEpoch}.$extension'; // Use a unique identifier

      // Upload the file with the generated image name
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$imageName');
      await ref.putFile(imageFile);
      String downloadURL = await ref.getDownloadURL();

      // Add the download URL to the map with the image key (image1, image2, ...)
      uploadedImageUrls["image$i"] = downloadURL;
    }
    return uploadedImageUrls;
  }

  Future<void> _pickVideo() async {
    final pickedVideo = await ImagePicker().pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 15));
    if (pickedVideo != null) {
      setState(() {
        _selectedVideo = File(pickedVideo.path);
      });
    }
  }

  File? _selectedVideo;

  Future<void> _sendVideo() async {
    if (_selectedVideo != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse("http://172.208.115.234:8080/upload_video/"));
      request.files.add(
        await http.MultipartFile.fromPath('video_file', _selectedVideo!.path,
            contentType: MediaType("multipart", "form-data")),
      );
      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Your video has been successfully uploaded')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to upload video. Status code: ${response.statusCode}')),
        );
        print('Failed to upload video. Status code: ${response.statusCode}');
        print(response);
      }
    }
  }
}
