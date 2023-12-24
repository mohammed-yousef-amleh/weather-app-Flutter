import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/cubits/weather/weather_cubit.dart';
import 'package:weatherapp/services/weather_api_services.dart';
import 'package:http/http.dart' as http;
import 'cubits/temp_settings/temp_settings_cubit.dart';
import 'pages/home_page.dart';
import 'repositories/weather_repository.dart';
import 'pages/list_of_places_page.dart';
import 'pages/daily_forecast_page.dart';
import 'pages/hourly_forecast_page.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
          weatherApiServices: WeatherApiServices(httpClient: http.Client())),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherCubit>(
            create: (context) => WeatherCubit(
                weatherRepository: context.read<WeatherRepository>()),
          ),
          BlocProvider<TempSettingsCubit>(
              create: (context) => TempSettingsCubit())
        ],
        child: MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomePageWithDrawer(),
        ),
      ),
    );
  }
}

class HomePageWithDrawer extends StatelessWidget {
  const HomePageWithDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Home Page
              },
            ),
            ListTile(
              leading: Icon(Icons.place),
              title: Text('List of Places'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListOfPlacesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Daily Forecast'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DailyForecastPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Hourly Forecast'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HourlyForecastPage()),
                );
              },
            ),
            // ... [add any additional ListTiles as needed]
          ],
        ),
      ),
      body: HomePage(), // Your existing HomePage widget
    );
  }
}