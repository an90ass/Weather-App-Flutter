// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';

class MyHomePage extends StatefulWidget {
  TextEditingController search = TextEditingController();

  MyHomePage(this.search, {super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WeatherFactory weatherFactory = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? weather;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
        _fetchWeather();

  }
Future<void> _fetchWeather() async {
    try {
      Weather value = await weatherFactory.currentWeatherByCityName(widget.search.text);
      setState(() {
        weather = value;
        errorMessage = null;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'City not found';
        weather = null;
        Navigator.pop(context, 'City not found');

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(child: _buildUI(),) 
    );
  }

  Widget _buildUI() {
    if (weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.01,
          ),
          _dateInTimeInfo(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.04,
          ),
          _weatherIcon(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
          ),
          _currentTemp(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.001,
          ),
          _extractInfo(),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      weather?.areaName ?? "",
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _dateInTimeInfo() {
    DateTime now = weather!.date!;
    return Column(
      children: [
        Text(DateFormat("h:mm a").format(now), // Corrected time format
            style: const TextStyle(fontSize: 35)),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(DateFormat("EEEE").format(now),
                style: const TextStyle(fontWeight: FontWeight.w700)),
            Text("  ${DateFormat("d.M.y").format(now)}",
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.15,
          width: MediaQuery.sizeOf(context).width * 0.24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.blue.shade400,
            boxShadow: [
              const BoxShadow(
                blurRadius: 7,
                color: Colors.red,
                spreadRadius: 3,
              )
            ],
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${weather!.weatherIcon}.png"),
            ),
          ),
        ),
        Text(
          weather?.weatherDescription ?? "",
          style: const TextStyle(color: Colors.black, fontSize: 30),
        )
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
          color: Colors.black, fontSize: 90, fontWeight: FontWeight.w500),
    );
  }

  Widget _extractInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.90,
      decoration: BoxDecoration(
          color: Colors.blue.shade400,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
                color: Colors.black,
                blurRadius: 7,
                offset: Offset(0, 3),
                spreadRadius: 3)
          ]),
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Max: ${weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "Min: ${weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Wind: ${weather?.windSpeed?.toStringAsFixed(0)} m/s",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "Humidity: ${weather?.humidity?.toStringAsFixed(0)} %",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            )
          ]),
    );
  }
}
