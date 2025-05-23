import 'package:advance_currency_convertor/core/constants/network_constant.dart';
import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/failure/app_failure.dart';
import 'package:advance_currency_convertor/core/network/dio_client.dart';
import 'package:advance_currency_convertor/features/currency_list/model/currency_list_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../service_locator_dependecies.dart';

class CurrencyListingRemoteRepository {
  Future<Either<AppFailure, CurrencyListModel>> getCurrencyListing() async {
    try {
      final response = await sl<DioClient>().get(
        '${Apiurls.url}/symbols',
        options: Options(headers: Apiurls.headers),
      );
      var getCurrencyList = CurrencyListModel.fromJson(response.data);
      return Right(getCurrencyList);
    } on DioException catch (e) {
      return Left(AppFailure(e.message ?? TextConstants.dioError));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
