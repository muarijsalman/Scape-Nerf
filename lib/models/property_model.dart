class Property {
  String? key;
  PropertyData? propertyData;

  Property({this.key, this.propertyData});
}

class PropertyData {
  String? name;
  String? address;
  String? video;
  String? description;
  List<String>? imageUrls;

  PropertyData(
      {this.name, this.address, this.imageUrls, this.video, this.description});

  // Deserialize JSON data
  PropertyData.fromJson(Map<dynamic, dynamic> json) {
    name = json["name"];
    address = json["address"];
    video = json["video"];
    description = json["description"];
    Map<dynamic, dynamic>? imageUrlsMap = json["images"];
    if (imageUrlsMap != null) {
      imageUrls = List<String>.from(imageUrlsMap.values);
    } else {
      imageUrls = [];
    }
  }
}
