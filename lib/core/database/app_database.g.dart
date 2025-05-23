// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CurrencyDao? _currencyDaoInstance;

  CurrencyRateDao? _currencyRateDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `currencies` (`code` TEXT NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`code`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `currency_rates` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `base` TEXT NOT NULL, `target` TEXT NOT NULL, `rate` REAL NOT NULL, `date` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CurrencyDao get currencyDao {
    return _currencyDaoInstance ??= _$CurrencyDao(database, changeListener);
  }

  @override
  CurrencyRateDao get currencyRateDao {
    return _currencyRateDaoInstance ??=
        _$CurrencyRateDao(database, changeListener);
  }
}

class _$CurrencyDao extends CurrencyDao {
  _$CurrencyDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _currencyEntityInsertionAdapter = InsertionAdapter(
            database,
            'currencies',
            (CurrencyEntity item) =>
                <String, Object?>{'code': item.code, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CurrencyEntity> _currencyEntityInsertionAdapter;

  @override
  Future<List<CurrencyEntity>> getAllCurrencies() async {
    return _queryAdapter.queryList('SELECT * FROM currencies',
        mapper: (Map<String, Object?> row) => CurrencyEntity(
            code: row['code'] as String, name: row['name'] as String));
  }

  @override
  Future<void> insertCurrencies(List<CurrencyEntity> currencies) async {
    await _currencyEntityInsertionAdapter.insertList(
        currencies, OnConflictStrategy.replace);
  }
}

class _$CurrencyRateDao extends CurrencyRateDao {
  _$CurrencyRateDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _currencyRateEntityInsertionAdapter = InsertionAdapter(
            database,
            'currency_rates',
            (CurrencyRateEntity item) => <String, Object?>{
                  'id': item.id,
                  'base': item.base,
                  'target': item.target,
                  'rate': item.rate,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CurrencyRateEntity>
      _currencyRateEntityInsertionAdapter;

  @override
  Future<List<CurrencyRateEntity>> getRatesByBase(String base) async {
    return _queryAdapter.queryList(
        'SELECT * FROM currency_rates WHERE base = ?1',
        mapper: (Map<String, Object?> row) => CurrencyRateEntity(
            id: row['id'] as int?,
            base: row['base'] as String,
            target: row['target'] as String,
            rate: row['rate'] as double,
            date: row['date'] as String),
        arguments: [base]);
  }

  @override
  Future<void> deleteRatesByBase(String base) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM currency_rates WHERE base = ?1',
        arguments: [base]);
  }

  @override
  Future<void> insertRates(List<CurrencyRateEntity> rates) async {
    await _currencyRateEntityInsertionAdapter.insertList(
        rates, OnConflictStrategy.replace);
  }
}
