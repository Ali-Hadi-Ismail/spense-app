import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, double>> getExchangeRates() async {
  final url =
      'http://api.exchangeratesapi.io/v1/latest?access_key=daad3921bed5cf5be8ca05a79ef0393c';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    if (data.containsKey('rates')) {
      Map<String, double> rates = {};
      data['rates'].forEach((key, value) {
        rates[key] = (value is int) ? value.toDouble() : value;
      });
      return rates;
    } else {
      throw Exception("Failed to load exchange rates: 'rates' key not found");
    }
  } else {
    throw Exception("Failed to load exchange rates: ${response.statusCode}");
  }
}

Future<List<String>> getCurrencyCodes() async {
  // Fetch exchange rates
  final rates = await getExchangeRates();

  // Extract currency codes from the map keys
  List<String> currencyCodes = rates.keys.toList();

  return currencyCodes;
}

Future<double> getCurrencyRate(String code, double amount) async {
  // Fetch exchange rates
  final rates = await getExchangeRates();

  double rate = rates[code]!;

  return amount / rate;
}
