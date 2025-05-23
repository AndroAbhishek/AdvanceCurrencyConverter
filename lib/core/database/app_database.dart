import 'dart:async';

import 'package:advance_currency_convertor/core/database/dao/currency_dao.dart';
import 'package:advance_currency_convertor/core/database/dao/currency_rate_dao.dart';
import 'package:advance_currency_convertor/core/database/entities/currency_entity.dart';
import 'package:advance_currency_convertor/core/database/entities/currency_rate_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'app_database.g.dart';

@Database(version: 1, entities: [CurrencyEntity, CurrencyRateEntity])
abstract class AppDatabase extends FloorDatabase {
  CurrencyDao get currencyDao;
  CurrencyRateDao get currencyRateDao;
}
