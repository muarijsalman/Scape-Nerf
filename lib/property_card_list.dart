import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/search_bar.dart';
import 'models/property_model.dart';
import 'property_card.dart';

class PropertyCardList extends StatefulWidget {
  final String searchQuery;

  const PropertyCardList({super.key, required this.searchQuery});

  @override
  State<PropertyCardList> createState() => _PropertyCardListState();
}

class _PropertyCardListState extends State<PropertyCardList> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  late List<Property> allProperties;
  late Future<List<Property>> propertiesFuture;
  late String mutableSearchQuery;

  @override
  void initState() {
    super.initState();
    allProperties = [];
    mutableSearchQuery = widget.searchQuery;
    propertiesFuture = retrievePropertyData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchBar(
          onTextChanged: (value) {
            setState(() {
              mutableSearchQuery = value;
            });
          },
        ),
        const SizedBox(height: 16.0,),
        Expanded(
          child: FutureBuilder<List<Property>>(
            future: propertiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No properties found.'),
                );
              } else {
                final List<Property> filteredProperties = snapshot.data!
                    .where((property) {
                  final String propertyInfo = '${property.propertyData?.name} ${property.propertyData?.address}';
                  return propertyInfo.toLowerCase().contains(mutableSearchQuery.toLowerCase());
                })
                    .toList();

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredProperties.length,
                  itemBuilder: (context, index) {
                    return PropertyCard(filteredProperties[index]);
                  },
                );
              }
            },
          ),
        )
      ],
    );
  }

  Future<List<Property>> retrievePropertyData() async {
    final Completer<List<Property>> completer = Completer();

    dbRef.child("Properties").onChildAdded.listen((data) {
      PropertyData propertyData = PropertyData.fromJson(data.snapshot.value as Map);
      Property property = Property(key: data.snapshot.key, propertyData: propertyData);

      allProperties.add(property);
      if (!completer.isCompleted) {
        completer.complete(allProperties);
      }
      setState(() {});
    });

    return completer.future;
  }
}
