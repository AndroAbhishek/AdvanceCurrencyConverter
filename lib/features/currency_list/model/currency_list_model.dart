class CurrencyListModel {
  final bool success;
  final Map<String, String> symbols;

  CurrencyListModel({required this.success, required this.symbols});

  factory CurrencyListModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> symbolsJson = json['symbols'] ?? {};
    Map<String, String> symbolsMap = {};

    symbolsJson.forEach((key, value) {
      // Safely handle nested objects or nulls
      if (value is String) {
        symbolsMap[key] = value;
      } else if (value is Map && value.containsKey('name')) {
        symbolsMap[key] = value['name'].toString();
      } else {
        symbolsMap[key] = value?.toString() ?? '';
      }
    });

    return CurrencyListModel(
      success: json['success'] ?? false,
      symbols: symbolsMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'symbols': symbols};
  }
}
