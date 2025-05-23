class CurrencyRateModel {
  final String base;
  final String date;
  final Map<String, double> rates;
  final bool success;
  final int timestamp;

  CurrencyRateModel({
    required this.base,
    required this.date,
    required this.rates,
    required this.success,
    required this.timestamp,
  });

  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) {
    return CurrencyRateModel(
      base: json['base'],
      date: json['date'],
      rates: Map<String, double>.from(json['rates']),
      success: json['success'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base': base,
      'date': date,
      'rates': rates,
      'success': success,
      'timestamp': timestamp,
    };
  }
}
