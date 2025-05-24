import 'package:advance_currency_convertor/core/database/app_database.dart';
import 'package:advance_currency_convertor/core/network/dio_client.dart';
import 'package:advance_currency_convertor/features/currency/repositories/icurrency_repository.dart';
import 'package:advance_currency_convertor/features/currency_list/repositories/currency_listing_remote_repository.dart';
import 'package:advance_currency_convertor/features/currency/db/currency_db_service.dart';
import 'package:advance_currency_convertor/features/currency/db/dao/currency_rate_dao.dart';
import 'package:advance_currency_convertor/features/currency/repositories/currency_api_service.dart';
import 'package:advance_currency_convertor/features/currency/repositories/currency_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'service_locator.dart';
