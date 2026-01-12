import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather.dart';

void main() {
  group('Weather Model - fromJson', () {
    test('should return a valid Weather object when given a realistic Manila JSON response', () {
      // 1. Arrange: Realistic sample response from OpenWeatherMap for Manila
      final Map<String, dynamic> jsonResponse = {
        "coord": {"lon": 120.9822, "lat": 14.5995},
        "weather": [
          {
            "id": 803,
            "main": "Clouds", // This will be mapped to 'description' in your model
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "main": {
          "temp": 31.5,
          "humidity": 62,
          "pressure": 1008,
        },
        "wind": {"speed": 4.12, "deg": 80},
        "name": "Manila",
      };

      // 2. Act
      final weather = Weather.fromJson(jsonResponse);

      // 3. Assert: Matching YOUR model's field names
      expect(weather.city, 'Manila');
      expect(weather.temperature, 31.5);
      expect(weather.description, 'Clouds'); // Your model maps json['weather'][0]['main'] to description
      expect(weather.humidity, 62);
      expect(weather.windSpeed, 4.12);
    });

    test('should handle integer temperature and wind speed safely', () {
      final Map<String, dynamic> jsonWithInt = {
        "name": "Manila",
        "main": {"temp": 31, "humidity": 60},
        "weather": [{"main": "Clear"}],
        "wind": {"speed": 5}
      };

      final weather = Weather.fromJson(jsonWithInt);

      expect(weather.temperature, 31.0);
      expect(weather.windSpeed, 5.0);
    });
  });
}
