import 'package:equatable/equatable.dart';

class HourlyForecast {
  final DateTime time;
  final double temperature;

  HourlyForecast({required this.time, required this.temperature});

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.parse(json['time']), // Adjust if your API uses a different format
      temperature: json['temperature'].toDouble(), // Or however your API provides this
    );
  }
}
