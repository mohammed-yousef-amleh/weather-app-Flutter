import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/hourly_forecast.dart';
import 'package:weatherapp/repositories/weather_repository.dart';
import 'package:weatherapp/services/weather_api_services.dart';

import '../models/direct_geocoding.dart';

class HourlyForecastPage extends StatefulWidget {
  const HourlyForecastPage({Key? key}) : super(key: key);

  @override
  _HourlyForecastPageState createState() => _HourlyForecastPageState();
}

class _HourlyForecastPageState extends State<HourlyForecastPage> {
  final TextEditingController _cityController = TextEditingController();
  List<HourlyForecast> _hourlyForecastData = [];

  void _fetchHourlyForecast(String city) async {
    try {
      // Replace with the actual initialization of WeatherApiServices
      final weatherApiServices = WeatherApiServices(httpClient: http.Client());

      // Create an instance of WeatherRepository
      final weatherRepository = WeatherRepository(weatherApiServices: weatherApiServices);

      // Get the coordinates (latitude and longitude) for the city using geocoding service
      final DirectGeocoding directGeocoding = await weatherApiServices.getDirectGeocoding(city);

      if (directGeocoding == null) {
        throw Exception('Failed to get coordinates for $city');
      }

      // Use the obtained coordinates to fetch the hourly forecast
      final List<HourlyForecast> hourlyForecast = await weatherRepository.fetchHourlyForecast(
        directGeocoding.lat, // Pass the latitude
        directGeocoding.lon, // Pass the longitude
      );

      setState(() {
        _hourlyForecastData = hourlyForecast;
      });
    } catch (e) {
      // Handle errors
      print('Error fetching Hourly Forecast: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hourly Forecast')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    style: TextStyle(fontSize: 18.0), // Set the font size
                    decoration: InputDecoration(
                      labelText: 'City name',
                      hintText: 'Write a city name',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final cityName = _cityController.text;
                    _fetchHourlyForecast(cityName);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _hourlyForecastData.length,
              itemBuilder: (context, index) {
                final hourlyData = _hourlyForecastData[index];
                return ListTile(
                  title: Text('${hourlyData.time}'),
                  subtitle: Text('Temperature: ${hourlyData.temperature}°C'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}