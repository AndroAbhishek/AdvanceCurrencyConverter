part of 'service_locator_dependecies.dart';

final sl = GetIt.instance;

Future<void> initDependecies() async {
  await _initDatabase();
  _initDioClient();
  _initRepositories();
}

Future<void> _initDatabase() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('currency_db.db').build();

  sl.registerSingleton<AppDatabase>(database);
}

void _initDioClient() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
}

void _initRepositories() {
  sl.registerLazySingleton<CurrencyListingRemoteRepository>(
    () => CurrencyListingRemoteRepository(),
  );

  sl.registerLazySingleton<CurrencyRateRemoteRepository>(
    () => CurrencyRateRemoteRepository(),
  );
}
