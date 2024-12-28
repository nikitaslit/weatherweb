// ignore_for_file: public_member_api_docs, sort_constructors_first
class CurrentWeather {
  final String conditionText;
  final String conditionIcon;
  final double windKph;
  final int humidity;
  final double feelsLikeC;
  final int cloud;

  CurrentWeather({
    required this.conditionText,
    required this.conditionIcon,
    required this.windKph,
    required this.humidity,
    required this.feelsLikeC,
    required this.cloud,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
        conditionText: json['condition']['text'],
        conditionIcon: json['condition']['icon'],
        windKph: json['wind_kph'],
        humidity: json['humidity'],
        feelsLikeC: json['feelslike_c'],
        cloud: json['cloud'],
    );
  }
}
