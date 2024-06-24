import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sh/const.dart';
import 'package:weather/weather.dart';
import 'package:sh/header.dart';
import 'package:timezone/timezone.dart' as tz;

class SuhuPage extends StatefulWidget {
  const SuhuPage({super.key});

  @override
  State<SuhuPage> createState() => _SuhuPageState();
}

class _SuhuPageState extends State<SuhuPage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  late Future<Weather?> _weatherFuture;
  String _selectedCity = "Samarinda";
  final List<String> _cities = ["Balikpapan", "Samarinda", "Bogor", "Jakarta"];
  final Map<String, String> _cityTimeZones = {
    "Balikpapan": "Asia/Makassar",
    "Samarinda": "Asia/Makassar",
    "Bogor": "Asia/Jakarta",
    "Jakarta": "Asia/Jakarta",
  };

  @override
  void initState() {
    super.initState();
    _weatherFuture = _fetchWeather(_selectedCity);
  }

  Future<Weather?> _fetchWeather(String city) async {
    return await _wf.currentWeatherByCityName(city);
  }

  void _onCityChanged(String newCity) {
    setState(() {
      _selectedCity = newCity;
      _weatherFuture = _fetchWeather(newCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(
        title: "Suhu",
        onMenuPressed: () {},
        cities: _cities,
        selectedCity: _selectedCity,
        onCityChanged: _onCityChanged,
      ),
      body: FutureBuilder<Weather?>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching weather data'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No weather data available'),
            );
          } else {
            Weather? weather = snapshot.data;
            return SingleChildScrollView(
              child: _buildUI(weather),
            );
          }
        },
      ),
    );
  }

  Widget _buildUI(Weather? weather) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(weather),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          _dateTimeInfo(weather!),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          _weatherIcon(weather),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _currentTemp(weather),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _extraInfo(weather),
        ],
      ),
    );
  }

  Widget _locationHeader(Weather? weather) {
    return Text(
      weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _dateTimeInfo(Weather weather) {
    DateTime now = weather.date!;
    String timeZone = _cityTimeZones[_selectedCity]!;
    tz.TZDateTime localTime = tz.TZDateTime.from(now, tz.getLocation(timeZone));
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(localTime),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(localTime),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "  ${DateFormat("d.M.y").format(localTime)}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon(Weather? weather) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp(Weather? weather) {
    return Text(
      "${weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _extraInfo(Weather? weather) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              "${weather?.windSpeed?.toStringAsFixed(1)} m/s",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const Text(
              "Wind",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "${weather?.humidity?.toStringAsFixed(0)}%",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const Text(
              "Humidity",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "${weather?.tempFeelsLike?.celsius?.toStringAsFixed(0)}° C",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const Text(
              "Feels Like",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

