class SiteDetailModel {
  final int id;
  final String siteName;
  final String? latitude;
  final String? longitude;
  final String? address;

  SiteDetailModel({
    required this.id,
    required this.siteName,
    this.latitude,
    this.longitude,
    this.address,
  });

  factory SiteDetailModel.fromJson(Map<String, dynamic> json) {
    return SiteDetailModel(
      id: json['id'],
      siteName: json['site_name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'site_name': siteName,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}