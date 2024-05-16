import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price_flow_project/features/personalization/screens/bookings_list/bookings_list.dart';
import 'package:price_flow_project/features/personalization/screens/settings/settings.dart';
import 'package:price_flow_project/features/services/screens/services.dart';
import 'package:price_flow_project/utils/constants/sizes.dart';

import 'utils/constants/colors.dart';
import 'utils/constants/image_strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Índice seleccionado del BottomNavigationBar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: TSizes.lg, bottom: TSizes.lg),
          child: Image(
            image: AssetImage(TImages.darkAppLogo),
            height: 128,
            width: 256,
          ),
        ),
      ),
      body: _getBodyWidget(_selectedIndex), // Mostrar el cuerpo dinámico según el índice seleccionado
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: TColors.secondary,
        unselectedIconTheme: const IconThemeData(color: Colors.black),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: TColors.primary,
        onTap: _updateSelectedIndex,
      ),
    );
  }

  void _updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBodyWidget(int index) {
    switch (index) {
      case 0:
        return const ServicesScreen();
      case 1: 
        return const BookingsList();
      case 2:
        return const SettingsScreen();
      default:
        return Container();
    }
  }
}
