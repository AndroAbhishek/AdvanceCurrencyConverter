import 'package:floor/floor.dart';

@Entity(tableName: 'currencies')
class CurrencyEntity {
  @primaryKey
  final String code;

  final String name;

  CurrencyEntity({required this.code, required this.name});
}
