import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:price_flow_project/features/services/services/services_service.dart';
import 'package:price_flow_project/home_page.dart';
import 'package:price_flow_project/utils/constants/sizes.dart';

import '../../../../utils/constants/colors.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingConfirmationScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details', style: Theme.of(context).textTheme.headlineMedium,),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Container(
                  padding: const EdgeInsets.all(TSizes.lg),
                  decoration: BoxDecoration(
                    color: TColors.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${bookingData['included'][0]['attributes']['service_type']!.toString().capitalize!} service",
                          style: Theme.of(context).textTheme.titleLarge),
                          Text(bookingData['data']['attributes']['display_total'].toString(),
                              style: Theme.of(context).textTheme.headlineMedium),
                        ],
                      ),

                      const Divider(),

                      const SizedBox(height: TSizes.spaceBtwItems,),

                      _cardRow(context, Icons.home_filled, "Property size", "${bookingData['included'][0]['attributes']['property_size']} m²"),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      _cardRow(context, Icons.cleaning_services, "Dirtiness level", bookingData['included'][0]['attributes']['service_name']),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      _cardRow(context, Icons.calendar_today, "Booking Date", _formatDate(bookingData['included'][0]['attributes']['booking_date'])),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      _cardRowTwo(context, Icons.location_on, bookingData['included'][0]['attributes']['address'], "")
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.lg),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: TColors.primary,
                disabledBackgroundColor: TColors.primary
              ),
              onPressed: () {
                final id = (bookingData['data']['attributes']['id']).toString();
                ServicesService().confirmBookService(id);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirmation"),
                      content: const Text("The service was successfully confirmated."),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            // Cerrar el alerta y navegar a HomePage
                            Navigator.of(context).pop();
                            Get.offAll(() => const HomePage());
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Confirm service'),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoCard(String title, dynamic value, {bool isPrice = false, bool isAddress = false, bool isSize = false}) {
    return Card(
      elevation: 0.0,
      borderOnForeground: false,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: TColors.darkerGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                isSize ? "${value.toString()} m²" : value.toString(),
                overflow: isAddress ? TextOverflow.ellipsis : null,
                maxLines: isAddress ? 50 : 1,
                style: TextStyle(
                  fontSize: isPrice ? 24 : 18,
                  color: TColors.darkerGrey,
                  fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _cardRow(context, icon, header, value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Colors.black),
                const SizedBox(width: 8),
                Text(header, style: Theme.of(context).textTheme.titleMedium)
              ],
            ),
            Text(value, style: Theme.of(context).textTheme.bodyLarge)
          ],
        ),
      ],
    );
  }

  _cardRowTwo(context, icon, header, value){
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black),
        const SizedBox(width: 8),
        Expanded(child: Text(header, style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis, maxLines: 3,)
        )
      ],
    );
  }

  String _formatDate(String? date) {
    if (date == null) return 'now';
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm'); // Formato deseado
    final dateTime = DateTime.parse(date);
    return dateFormat.format(dateTime);
  }
}
