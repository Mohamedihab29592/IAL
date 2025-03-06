import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../domain/repo.dart';
import '../Model/lookup_data_model.dart';
import '../Model/lookup_model.dart';
import '../Model/site_model.dart';
import '../data_source/local_data_source.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentLocalDataSource localDataSource;

  IncidentRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<String, List<LookupModel>>> getIncidentTypes() async {
    return await localDataSource.getIncidentTypes();
  }

  @override
  Future<Either<String, List<LookupModel>>> getLocation() async {
    return await localDataSource.getLocation();
  }

  @override
  Future<Either<String, LookupDataModel>> getAllLookupData() async {
    final result = await localDataSource.getAllLookupData();
    if (kDebugMode) {
      print(result);
    }
    return result;
  }

  @override
  Future<Either<String, SiteDetailModel>> getSiteDetails(int siteId)
  async {
    return await localDataSource.getSiteDetails(siteId);
  }
}
