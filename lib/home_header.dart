import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<String> cities;
  final String selectedCity;
  final ValueChanged<String> onCityChanged;

  const HomeHeader({
    Key? key,
    required this.title,
    required this.cities,
    required this.selectedCity,
    required this.onCityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        DropdownButton<String>(
          value: selectedCity,
          icon: const Icon(Icons.arrow_downward),
          onChanged: (String? newCity) {
            if (newCity != null) {
              onCityChanged(newCity);
            }
          },
          items: cities.map<DropdownMenuItem<String>>((String city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(city),
            );
          }).toList(),
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Handle notifications button press
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
