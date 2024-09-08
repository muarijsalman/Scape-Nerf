// property_card.dart
import 'package:flutter/material.dart';
import 'models/property_model.dart';
import 'property_details_page.dart';

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard(this.property, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _navigateToPropertyDetails(context);
      },
      child: Card(
        elevation: 5.0,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),

          child: Stack(
            children: [
              _buildImageCarousel(),
              _buildPropertyInfo(),
            ],
          ),
        ),
    );
  }

  void _navigateToPropertyDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PropertyDetailsPage(property: property),
      ),
    );
  }

  Widget _buildPropertyInfo() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              property.propertyData?.name ?? '',
              style: cardTitleStyle,
            ),
            const SizedBox(height: 4.0),
            Text(
              property.propertyData?.address ?? '',
              style: cardSubtitleStyle,
            ),
          ],
        ),
      ),
    );
  }

  // Method to build a carousel of property images
  Widget _buildImageCarousel() {
    final String? firstImageUrl = property.propertyData?.imageUrls?.first;
    if (firstImageUrl != null){
      return Image.network(
        firstImageUrl,
        width: double.infinity,
        height: 300.0,
        fit: BoxFit.cover,
      );
    } else{
      return Container();
    }
  }

  final TextStyle cardTitleStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  final TextStyle cardSubtitleStyle = const TextStyle(
    fontSize: 14.0,
    color: Colors.white70,
  );
}
