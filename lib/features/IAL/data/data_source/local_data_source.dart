import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/data_base_helper.dart';
import '../Model/location_model.dart';
import '../Model/lookup_data_model.dart';
import '../Model/lookup_model.dart';
import '../Model/site_model.dart';

class IncidentLocalDataSource {
  final DatabaseHelper dbHelper;

  IncidentLocalDataSource({required this.dbHelper});

  Future<Either<String, List<LookupModel>>> getIncidentTypes() async {
    try {
      final result = await dbHelper.getIncidentTypes();
      return Right(result.map((item) => LookupModel.fromJson(item)).toList());
    } catch (e) {
      return Left('Error fetching incident types: $e');
    }
  }

  Future<Either<String, List<LocationModel>>> getLocation() async {
    try {
      final result = await dbHelper.getLocation();
      return Right(result.map((item) => LocationModel.fromJson(item)).toList());
    } catch (e) {
      return Left('Error fetching locations: $e');
    }
  }

  Future<Either<String, LookupDataModel>> getAllLookupData() async {
    try {
      final incidentTypes = await dbHelper.getIncidentTypes();
      final location = await dbHelper.getLocation();
      final incLocation = await dbHelper.getIncLocation();
      final areaOwner = await dbHelper.getAreaOwner();

      return Right(
        LookupDataModel(
          incidentTypes: incidentTypes.map((item) => LookupModel.fromJson(item)).toList(),
          location: location.map((item) => LookupModel.fromJson(item)).toList(),
          areaOwner: areaOwner.map((item) => LookupModel.fromJson(item)).toList(),
          inc_location: incLocation.map((item) => LookupModel.fromJson(item)).toList(),
        ),
      );
    } catch (e) {
      return Left('Error fetching lookup data: $e');
    }
  }

  Future<Either<String, SiteDetailModel>> getSiteDetails(int siteId) async {
    try {
      final result = await dbHelper.getSiteDetails(siteId);

      if (result == null) {
        return const Left('Site not found');
      }

      return Right(SiteDetailModel.fromJson(result));
    } catch (e) {
      if (kDebugMode) {
        print('Error in getSiteDetails: $e');
      }
      return Left('Error fetching site details: $e');
    }
  }
}