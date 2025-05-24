import 'package:advance_currency_convertor/features/currency_list/db/entities/currency_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class CurrencyDao {
  @Query('SELECT * FROM currencies')
  Future<List<CurrencyEntity>> getAllCurrencies();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCurrencies(List<CurrencyEntity> currencies);
}
