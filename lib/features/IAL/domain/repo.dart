import 'package:dartz/dartz.dart';
import '../data/Model/lookup_data_model.dart';
import '../data/Model/lookup_model.dart';
import '../data/Model/site_model.dart';
abstract class IncidentRepository {
  Future<Either<String, List<LookupModel>>> getIncidentTypes();
  Future<Either<String, List<LookupModel>>> getLocation();
  Future<Either<String, LookupDataModel>> getAllLookupData();
  Future<Either<String, SiteDetailModel>> getSiteDetails(int siteId);
}