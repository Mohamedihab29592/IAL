
import '../../features/IAL/data/data_source/local_data_source.dart';
import '../../features/IAL/data/repo/irg_repo_imp.dart';
import '../../features/IAL/domain/repo.dart';
import 'data_base_helper.dart';
import 'package:get_it/get_it.dart';


final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Database
  sl.registerLazySingleton(() => DatabaseHelper.instance);
  // Data sources
  sl.registerLazySingleton(
        () => IncidentLocalDataSource(dbHelper: sl()),
  );

  // Repositories
  sl.registerLazySingleton<IncidentRepository>(
        () => IncidentRepositoryImpl(localDataSource: sl()),
  );

}

class GetLocationsByType {
}