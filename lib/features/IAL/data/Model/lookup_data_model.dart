import 'location_model.dart';
import 'lookup_model.dart';

class LookupDataModel {
  final List<LookupModel> incidentTypes;
  final List<LookupModel> location;
  final List<LookupModel> areaOwner;
  final List<LookupModel> inc_location;

  LookupDataModel({
    required this.incidentTypes,
    required this.location,
    required this.areaOwner,
    required this.inc_location,
  });

  factory LookupDataModel.fromJson(Map<String, dynamic> json) {
    return LookupDataModel(
      incidentTypes: (json['incident_types'] as List)
          .map((item) => LookupModel.fromJson(item))
          .toList(),
      location: (json['siteId'] as List)
          .map((item) => LookupModel.fromJson(item))
          .toList(),
      areaOwner: (json['area_owner'] as List)
          .map((item) => LocationModel.fromJson(item))
          .toList(),

      inc_location: (json['incident_location'] as List)
          .map((item) => LookupModel.fromJson(item))
          .toList(),

    );
  }


}
