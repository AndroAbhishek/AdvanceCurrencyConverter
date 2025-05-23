import 'package:floor/floor.dart';

@Entity(tableName: 'currency_rates')
class CurrencyRateEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String base;
  final String target;
  final double rate;
  final String date;

  CurrencyRateEntity({
    this.id,
    required this.base,
    required this.target,
    required this.rate,
    required this.date,
  });
}
