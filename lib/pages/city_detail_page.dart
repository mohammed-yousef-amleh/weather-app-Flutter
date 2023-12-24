import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/weather.dart';
import '../repositories/weather_repository.dart';

class CityDetailPage extends StatefulWidget {
  final String cityName;

  const CityDetailPage({super.key, required this.cityName, required weather});

  @override
  _CityDetailPageState createState() => _CityDetailPageState();
}

class _CityDetailPageState extends State<CityDetailPage> {
  late Weather weather;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  void fetchWeatherData() async {
    try {
      // Assuming you have a method in WeatherRepository to fetch weather by city name
      weather = await context.read<WeatherRepository>().fetchWeather(widget.cityName);
      setState(() => isLoading = false);
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Details for ${widget.cityName}')),
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('Details for ${widget.cityName}')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Temperature: ${weather.temp}°C', style: TextStyle(fontSize: 18)),
              Text('Condition: ${weather.description}', style: TextStyle(fontSize: 18)),
              // Display more weather details
            ],
          ),
        ),
      );
    }
  }
}
