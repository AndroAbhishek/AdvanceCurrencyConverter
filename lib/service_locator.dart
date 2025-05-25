part of 'service_locator_dependencies.dart';

final sl = GetIt.instance;

Future<void> initDependecies() async {
  await _initSharedPreferences();
  await _initDatabase();
  _initDioClient();
  _initRepositories();
}

Future<void> _initSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
}

Future<void> _initDatabase() async {
  final database =
      await $FloorAppDatabase.databaseBuilder(TextConstants.dbVersion).build();

  sl.registerSingleton<AppDatabase>(database);

  sl.registerLazySingleton<CurrencyDBService>(() => CurrencyDBService());
}

void _initDioClient() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
}

void _initRepositories() {
  sl.registerLazySingleton<CurrencyListingRemoteRepository>(
    () => CurrencyListingRemoteRepository(),
  );

  sl.registerLazySingleton<ICurrencyRateRepository>(
    () => CurrencyRateRepository(),
  );

  sl.registerLazySingleton<CurrencyApiService>(() => CurrencyApiService());

  sl.registerLazySingleton<CurrencyRateDao>(
    () => sl<AppDatabase>().currencyRateDao,
  );
}
