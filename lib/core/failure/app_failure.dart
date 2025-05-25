import 'package:advance_currency_convertor/core/constants/text_constants.dart';

class AppFailure {
  final String message;
  AppFailure([this.message = TextConstants.unexpectedOccurred]);

  @override
  String toString() => '${TextConstants.appFailure} $message)';
}
