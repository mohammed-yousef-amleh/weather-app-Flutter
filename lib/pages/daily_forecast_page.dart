import 'package:flutter/material.dart';
import 'package:weatherapp/cubits/weather/weather_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyForecastPage extends StatelessWidget {
  const DailyForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example content - modify as needed
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Forecast'),
      ),
      body: Center(
        child: Text('Content for Daily Forecast'),
      ),
    );
  }
}
