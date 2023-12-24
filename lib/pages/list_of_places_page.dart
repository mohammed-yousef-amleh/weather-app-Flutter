import 'package:flutter/material.dart';
import 'package:weatherapp/cubits/weather/weather_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'city_detail_page.dart';

class ListOfPlacesPage extends StatefulWidget {
  const ListOfPlacesPage({super.key});

  @override
  _ListOfPlacesPageState createState() => _ListOfPlacesPageState();
}

class _ListOfPlacesPageState extends State<ListOfPlacesPage> {
  List<String> cities = [
    "New York", "London", "Tokyo", "Paris", "Hebron", "Madrid", "Amman",
    "Riyadh", "Kuwait", "Beirut", "Tehran", "Doha", "Baghdad",
    "Moscow", "Beijing", "Ottawa", "Berlin", "Canberra", "New Delhi",
    "Brasilia", "Cairo", "Buenos Aires", "Stockholm", "Helsinki"
  ];
  String filter = '';
  Map<String, WeatherState> weatherDataMap = {}; // Store weather data for each city

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Places'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Search City',
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                filter = value;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                if (filter.isEmpty || city.toLowerCase().contains(filter.toLowerCase())) {
                  return ListTile(
                    title: Text(city),
                    subtitle: BlocBuilder<WeatherCubit, WeatherState>(
                      builder: (context, state) {
                        final weatherState = weatherDataMap[city];
                        if (weatherState is WeatherState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Temperature: ${weatherState.weather.temp}°C"),
                              // Other weather details...
                              Image.network('http://openweathermap.org/img/wn/${weatherState.weather.icon}.png'),
                            ],
                          );
                        }
                        return Text('Loading...');
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () {
                        final weatherData = weatherDataMap[city];
                        if (weatherData is WeatherState) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CityDetailPage(cityName: city, weather: weatherData.weather),
                            ),
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    for (var city in cities) {
      context.read<WeatherCubit>().fetchWeather(city);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to the WeatherCubit state changes and update the weather data map
    context.read<WeatherCubit>().stream.listen((state) {
      if (state is WeatherState) {
        setState(() {
          weatherDataMap[state.weather.name] = state;
        });
      }
    });
  }
}
