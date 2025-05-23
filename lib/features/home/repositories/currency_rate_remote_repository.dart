import 'package:advance_currency_convertor/core/constants/network_constant.dart';
import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/failure/app_failure.dart';
import 'package:advance_currency_convertor/core/network/dio_client.dart';
import 'package:advance_currency_convertor/features/home/model/currency_rate_model.dart';
import 'package:advance_currency_convertor/service_locator_dependecies.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class CurrencyRateRemoteRepository {
  Future<Either<AppFailure, CurrencyRateModel>> getExchangeRates({
    required String base,
    required List<String> symbols,
  }) async {
    final symbolString = symbols.join(',');
    final url = '${Apiurls.url}/latest?symbols=$symbolString&base=$base';

    try {
      final response = await sl<DioClient>().get(
        url,
        options: Options(headers: Apiurls.headers),
      );
      final result = CurrencyRateModel.fromJson(response.data);
      return Right(result);
    } on DioException catch (e) {
      return Left(AppFailure(e.message ?? TextConstants.dioError));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
