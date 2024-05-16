import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price_flow_project/features/services/services/services_service.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class BookingsList extends StatefulWidget {
  const BookingsList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookingsListState createState() => _BookingsListState();
}

class _BookingsListState extends State<BookingsList> {
  List<dynamic> listOfBookServices = [];
  bool isLoading = true; // Agregar una variable para controlar el estado de carga

  @override
  void initState() {
    super.initState();
    loadBookedServices();
  }

  void loadBookedServices() async {
    var services = await ServicesService().getListOfBookedServices();
    setState(() {
      listOfBookServices = services;
      isLoading = false; // Actualizar el estado de carga cuando los datos estén listos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings List', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: isLoading
        ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
          )
        )
        : ListView.builder(
            itemCount: listOfBookServices.length,
            itemBuilder: (context, index) {
              final booking = listOfBookServices[index];
              final bookingDatas = booking['included'][0]['attributes'];
              final bookingAttributes = booking['data']['attributes'];
              return Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Container(
                  decoration: BoxDecoration(
                    color: TColors.softGrey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _infoCard('Service Type', bookingDatas['service_type']),
                      // _infoCard('Property Type', bookingDatas['property_type']),
                      _infoCard('Property Size', bookingDatas['property_size'], isSize: true),
                      _infoCard('Booking Date', _formatDate(bookingDatas['booking_date'])),
                      _infoCard('Address', bookingDatas['address'], isAddress: true),
                      _infoCard('Service Name', bookingDatas['service_name']),
                      _infoCard('State', bookingAttributes['state']),
                      _infoCard('Total', bookingAttributes['display_total'].toString(), isPrice: true),
                    ]
                  ),
                ),
              );
            },
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

  String _formatDate(String? date) {
    if (date == null) return 'now';
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final dateTime = DateTime.parse(date);
    return dateFormat.format(dateTime);
  }
}
