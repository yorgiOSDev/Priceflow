import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_flow_project/features/personalization/screens/profile/profile.dart';

import '../../../../common/widgets/list_tiles/settings_menu_tile.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/services/user_service.dart';
import '../address/address.dart';
import '../bookings_list/bookings_list.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder( // Utiliza LayoutBuilder para calcular el tamaño disponible
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        children: [
                          TSettingsMenuTile(trailing: const Icon(Icons.arrow_right), icon: Icons.person, title: 'Profile', subTitle: 'Edit your personal information', onTap: () => Get.to(() => const ProfileScreen())),
                          TSettingsMenuTile(trailing: const Icon(Icons.arrow_right), icon: Icons.person_pin_circle_rounded, title: 'My Address', subTitle: 'Set the address where you want your services', onTap: () => Get.to(() => const UserAddressScreen())),
                          TSettingsMenuTile(trailing: const Icon(Icons.arrow_right), icon: Icons.calendar_today_rounded, title: 'Bookings', subTitle: 'A list with all the services that you have scheduled', onTap: () => Get.to(() => const BookingsList())),
                          const SizedBox(height: TSizes.spaceBtwSections),
                        ],
                      ),
                    ),
                    Expanded( // Utiliza Expanded para ocupar el espacio restante
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(TSizes.defaultSpace), // Ajusta el padding según sea necesario
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: UserService().logoutUser,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red, width: 1), // Establece el color del borde a rojo
                              ),
                              child: Text(
                                'Logout',
                                style: Theme.of(context).textTheme.headlineSmall!.apply(
                                      color: Colors.red.withOpacity(0.8),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
