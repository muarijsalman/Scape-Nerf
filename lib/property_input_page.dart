import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PropertyInputPage extends StatefulWidget {
  const PropertyInputPage({super.key});

  @override
  State<PropertyInputPage> createState() => _PropertyInputPageState();
}

class _PropertyInputPageState extends State<PropertyInputPage> {

  DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _submitProperty() {
    String name = _nameController.text.toString();
    String address = _addressController.text.toString();

    Map<String, dynamic> data = {
      "name": name,
      "address": address
    };

    dbRef.child("Properties").push().set(data).then((value){
      _nameController.clear();
      _addressController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Property Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Property Address'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitProperty,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}