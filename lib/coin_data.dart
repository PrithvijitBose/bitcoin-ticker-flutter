import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = ['BTC', 'ETH', 'LTC'];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '1984CE7D-12B8-463B-889C-10CE3908FB0A';

class CoinData {
  Future<Map<String, double>> getCoinData(String selectedCurrency) async {
    Map<String, double> cryptoPrices = {};
    for (String crypto in cryptoList) {
      try {
        String requestURL =
            '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
        http.Response response = await http.get(Uri.parse(requestURL));
        print('Request URL: $requestURL'); // Debug: Print request URL
        print('Response Status: ${response.statusCode}'); // Debug: Print status code
        print('Response Body: ${response.body}'); // Debug: Print response body

        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);
          double lastPrice = decodedData['rate'];
          cryptoPrices[crypto] = lastPrice;
        } else {
          print('Error: ${response.statusCode}');
          throw 'Problem with the get request';
        }
      } catch (e) {
        print('Exception caught: $e');
      }
    }
    return cryptoPrices;
  }
}