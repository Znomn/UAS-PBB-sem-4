import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuPressed;
  final List<String>? cities;
  final String? selectedCity;
  final ValueChanged<String>? onCityChanged;

  const CustomHeader({
    Key? key,
    required this.title,
    required this.onMenuPressed,
    this.cities,
    this.selectedCity,
    this.onCityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: onMenuPressed,
      ),
      actions: [
        if (cities != null && selectedCity != null && onCityChanged != null)
          PopupMenuButton<String>(
            icon: const Icon(Icons.location_city),
            onSelected: (value) {
              onCityChanged!(value);
            },
            itemBuilder: (BuildContext context) {
              return cities!.map((String city) {
                return PopupMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList();
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
