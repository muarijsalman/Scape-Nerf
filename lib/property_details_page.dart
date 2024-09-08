import 'package:flutter/material.dart';
import 'models/property_model.dart';
import 'package:my_app/video_player.dart';

class PropertyDetailsPage extends StatelessWidget {
  final Property property;

  const PropertyDetailsPage({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackButton(context),
                    const SizedBox(height: 16.0),
                    _buildImageCarousel(),
                    const SizedBox(height: 20.0),
                    _buildPropertyDetails(property.propertyData?.name ?? '',
                        fontSize: 28.0, fontWeight: FontWeight.bold),
                    const SizedBox(height: 8.0),
                    _buildPropertyDetails(property.propertyData?.address ?? '',
                        fontSize: 18.0),
                    const SizedBox(height: 16.0),
                    _buildDescriptionHeading(),
                    const SizedBox(height: 8.0),
                    _buildDescriptionText(
                        property.propertyData?.description ?? ''),
                  ],
                ),
              ),
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 80,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _build3DButton(context, property),
          ],
        ),
      ),
    );
  }

  Widget _build3DButton(context, Property property) {
    return ElevatedButton(
      onPressed: () {
        // Add your 3D view handling logic here
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                  videoUrl: property.propertyData?.video ?? '')),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Text(
          "View in 3D",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    final List<String>? imageUrls = property.propertyData?.imageUrls;
    if (imageUrls != null && imageUrls.isNotEmpty) {
      return Container(
        height: 300.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: PageView.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                imageUrls[index],
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      );
    } else {
      return Container(
        height: 300.0,
        color: Colors.grey.withOpacity(0.5),
        child: const Center(
          child: Text(
            'No Images available',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Widget _buildDescriptionHeading() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Description',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 10), // Add space between heading and image
        Container(
          width: 100, // Adjust width as needed
          height: 100, // Adjust height as needed
          child: Image.asset(
              'assets/images/scapenerf.jpeg'), // Replace 'assets/logo.png' with your logo image path
        ),
      ],
    );
  }

  Widget _buildDescriptionText(String description) {
    //   return Container(
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.grey), // Border color
    //       borderRadius: BorderRadius.circular(10.0), // Border radius
    //       color: Color.fromRGBO(168, 173, 253, 1), // Background color
    //     ),
    //     padding: EdgeInsets.all(16.0),
    //     child: Text(
    //       description,
    //       style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat'),
    //     ),
    //   );
    // }
    return GestureDetector(
      onTap: () {
        // Handle tap on description card
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          color: Color.fromRGBO(168, 173, 253, 1),
        ),
        child: Text(
          description,
          style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat'),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            backgroundColor: Colors.grey,
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyDetails(String value,
      {double fontSize = 16.0, FontWeight? fontWeight}) {
    return Text(
      value,
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
