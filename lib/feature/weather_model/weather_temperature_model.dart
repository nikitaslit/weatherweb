class WeatherModel {
  final double tempC; // Температура в Цельсиях

  WeatherModel({required this.tempC});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      tempC: json['temp_c'], // Текущая температура
    );
  }
}
