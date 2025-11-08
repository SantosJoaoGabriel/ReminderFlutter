import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String apiKey = '2e8b8b7ba3394527bf3221433252710';

  // Exemplo - obtendo forecast de condição por cidade e data
  Future<String> getWeatherDescription({required String city, required DateTime date}) async {
    // Formata a data (WeatherAPI espera yyyy-MM-dd)
    final dateStr = "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}";
    final url =
      'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&dt=$dateStr&lang=pt';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // Forecast para aquele dia
      final condition = json['forecast']['forecastday'][0]['day']['condition']['text'];
      return condition; // Exemplo: "Parcialmente nublado"
    } else {
      throw Exception('Erro ao consultar clima');
    }
  }
}