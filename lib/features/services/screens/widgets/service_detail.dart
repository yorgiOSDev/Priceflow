import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:price_flow_project/features/services/screens/widgets/img_slider.dart';
import 'package:price_flow_project/features/services/screens/widgets/map_picker.dart';
import 'package:price_flow_project/features/services/screens/widgets/value_selector.dart';
import 'package:price_flow_project/features/services/services/services_service.dart';
import 'package:price_flow_project/utils/constants/colors.dart';

import 'package:price_flow_project/utils/constants/sizes.dart';

import 'booking_confirmation.dart';
import 'date_picker.dart';
import 'time_picker.dart';

class ServiceDetail extends StatefulWidget {
  final String serviceName;

  const ServiceDetail({super.key, required this.serviceName});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  String selectedDateTimeText = 'Now';
  String dateButtonText = 'Now';
  int? selectedPropertyIndex;
  int selectedPropertySize = 10;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String _locationText = "Current location";
  int? selectedImageId;
  double? selectedLatitude;
  double? selectedLongitude;
  String selectedAddress = "Current location";
  bool _isLoading = false;
  double? tempLatitude;
  double? tempLongitude;
  String tempAddress = "Current location";

  // Listas de íconos y etiquetas para las propiedades
  final List<IconData> propertyIcons = [
    Icons.home_filled, // Ícono para casa
    Icons.business_rounded, // Ícono para oficina
    Icons.apartment, // Ícono para apartamento
    Icons.more_horiz_rounded // Ícono para otros
  ];

  final List<String> propertyLabels = ["House", "Office", "Flat", "Other"];

  IconData getIconForIndex(int index) {
    return propertyIcons[index];
  }

  String getLabelForIndex(int index) {
    return propertyLabels[index];
  }

  String getSelectedPropertyType() {
    if (selectedPropertyIndex != null) {
      return propertyLabels[selectedPropertyIndex!];
    }
    return "House";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              widget.serviceName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: TSizes.md, right: TSizes.md, bottom: TSizes.lg),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: const EdgeInsets.only(bottom: 8, top: 16),
                          child:  Text("Where and when", style: Theme.of(context).textTheme.titleMedium)),
                      Container(
                        decoration: BoxDecoration(
                            color: TColors.secondary,
                            borderRadius: BorderRadius.circular(8)),
                          height: 70,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(
                                0),
                            alignment: Alignment.centerLeft,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          onPressed: () {
                            showMapSheet(context);
                          },
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              const Icon(Icons.location_on, size: 24),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(_locationText, style: const TextStyle(fontWeight: FontWeight.w600))
                              ),
                            
                              const SizedBox(width: 4),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: TextButton(
                                    onPressed: () {
                                      showActionSheet(context);
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time_filled, size: 18, color: Colors.black),
                                        const SizedBox(width: 4),
                                        Text(dateButtonText,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600
                                          ),),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                                      ],
                                    )
                                ),
                              ),
                              const SizedBox(width: 8)
                            ],
                          ),
                        ),
                      ),
                            
                      const SizedBox(height: TSizes.spaceBtwSections,),
                            
                      // Padding(padding: const EdgeInsets.only(bottom: 8),
                      //   child:  Text("Property", style: Theme.of(context).textTheme.titleMedium),),
                      // GridView.count(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   crossAxisCount: 4,
                      //   crossAxisSpacing: 20,
                      //   mainAxisSpacing: 20,
                      //   children: List.generate(4, (index) {
                      //     return GestureDetector(
                      //       onTap: () {
                      //         setState(() {
                      //           selectedPropertyIndex =
                      //               index;
                      //         });
                      //       },
                      //       child: PropertyContainer(
                      //         icon: getIconForIndex(
                      //             index),
                      //         label: getLabelForIndex(
                      //             index),
                      //         size: 32,
                      //         isSelected: selectedPropertyIndex ==
                      //             index,
                      //       ),
                      //     );
                      //   }),
                      // ),
                      // // const SizedBox(height: TSizes.spaceBtwInputFields,),
                            
                      Padding(padding: const EdgeInsets.only(bottom: 8),
                          child:  Text("Dirtiness level", style: Theme.of(context).textTheme.titleMedium)),
                      ImagesSlider(
                        onSelectImage: (int id) {
                          setState(() {
                            selectedImageId = id;
                          });
                        },
                      ),
                            
                      const SizedBox(height: TSizes.spaceBtwInputFields,),
                            
                      Padding(padding: const EdgeInsets.only(bottom: 8),
                          child:  Text("Size m²", style: Theme.of(context).textTheme.titleMedium)),
                      ValueSelector(onValueChanged: (int newSize) {
                        setState(() {
                          selectedPropertySize =
                              newSize;
                        });
                      }),
                            
                      ///Location and Date selector
                            
                      const SizedBox(
                        height: TSizes.spaceBtwSections,
                      ),
                            
                      /// Book Service
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: TColors.primary,
                      side: BorderSide.none,
                      disabledBackgroundColor: TColors.primary
                  ),         
                  onPressed:  _isLoading ? null : () { // Deshabilita el botón si _isLoading es true
                    _bookService();
                  },
                  child: const Text('Book Service'),
                )
              ],
            ),
          )
      ),
        _isLoading ? Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
            )
          ),
        ) : const SizedBox.shrink(),
      ],
    );
  }

  void showActionSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      showDragHandle: false,
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 18, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("When do you want the service?", style: Theme.of(context).textTheme.headlineSmall)
                      ],
                    ),
                  ),

                  const Divider(),

                  Padding(padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                    child:  Text("Date", style: Theme.of(context).textTheme.titleMedium),),

                  Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DatePickerHorizontal(
                      onSelectDate: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                      initialDate: selectedDate ?? DateTime.now(),
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections,),

                  Padding(padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child:  Text("Time", style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TimePickerHorizontal(
                    onSelectTime: (time) {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    initialTime: selectedTime ?? TimeOfDay.now(),
                  ),),

                  const SizedBox(height: TSizes.spaceBtwSections,),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(right: TSizes.md, left: TSizes.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedDate = null; // Restablece la fecha seleccionada a null
                                selectedTime = null; // Restablece la hora seleccionada a null
                                selectedDateTimeText = "Now"; // Actualiza el texto que se muestra en el botón principal
                                dateButtonText = "Now"; // Restablece el texto del botón para que diga "Now"
                              });
                              Navigator.pop(context); // Cierra el modal
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.access_time_filled, color: Colors.black),
                                SizedBox(width: 4),
                                Text("Right now",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600
                                  ),),
                              ],
                            )
                          ),
                        ),
                        const SizedBox(
                          width: TSizes.spaceBtwItems,
                        ),
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                              color: TColors.primary,
                              border: Border.all(color: TColors.primary),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child:  TextButton(
                              onPressed: () {
                                if (selectedDate != null && selectedTime != null) {
                                  DateTime fullDateTime = DateTime(
                                      selectedDate!.year,
                                      selectedDate!.month,
                                      selectedDate!.day,
                                      selectedTime!.hour,
                                      selectedTime!.minute);
                                  String formattedDateTime =
                                  DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(fullDateTime);
                                  setState(() {
                                    selectedDateTimeText = formattedDateTime;
                                    dateButtonText =  DateFormat('dd MMM').format(fullDateTime);
                                  });
                                } else {
                                  setState(() {
                                    selectedDateTimeText =
                                    ""; // Asegúrate de que es un string vacío si no hay selección
                                    dateButtonText = "Now";
                                  });
                                }
                                Navigator.pop(context); // Cierra el modal
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.calendar_month, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text("On selected date",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                    ),),
                                ],
                              )
                          ),
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
        );
      },
    );
  }

  void showMapSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      showDragHandle: true,
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(child: MapPicker(
                  onLocationSelected: (latitude, longitude, address) {
                    // Aquí solo actualizamos las variables temporales
                    tempLatitude = latitude;
                    tempLongitude = longitude;
                    tempAddress = address;
                  },
                )),
                Padding(
                  padding: const EdgeInsets.only(right: TSizes.md, top: TSizes.md, left: TSizes.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(8)),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedLatitude = null;
                                selectedLongitude = null;
                                selectedAddress = "Current location";
                                _locationText = "Current location";
                              });
                              Navigator.pop(context);
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.black),
                                SizedBox(width: 4),
                                Text("Use Current Location",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600
                                  ),),
                              ],
                            )
                        ),
                      ),

                      const SizedBox(
                        width: TSizes.spaceBtwItems,
                      ),

                      Expanded(child: Container(
                        decoration: BoxDecoration(
                            color: TColors.primary,
                            border: Border.all(color: TColors.primary),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child:  TextButton(
                            onPressed: () {
                              if (tempLatitude != null && tempLongitude != null && tempAddress != "Current location") {
                                setState(() {
                                  selectedLatitude = tempLatitude;
                                  selectedLongitude = tempLongitude;
                                  selectedAddress = tempAddress;
                                  _locationText = tempAddress;
                                });
                              }
                              Navigator.pop(context);
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.map, color: Colors.white),
                                SizedBox(width: 4),
                                Text("Use map location",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                  ),),
                              ],
                            )
                        ),
                      ),),

                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _bookService() async {
    setState(() {
      _isLoading = true;
    });
    String propertyType = getSelectedPropertyType();
    if (selectedLatitude == null || selectedLongitude == null) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      selectedLatitude = position.latitude;
      selectedLongitude = position.longitude;
      selectedAddress = await _getAddressFromCoordinates(
          selectedLatitude!, selectedLongitude!);
    }

    try {
      var bookingData = await ServicesService().bookService(
        propertyType,
        selectedPropertySize,
        selectedDateTimeText,
        selectedImageId ?? 1, // Asumiendo un ID por defecto de 1
        selectedLatitude!,
        selectedLongitude!,
        selectedAddress,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationScreen(bookingData: bookingData),
        ),
      );
    } catch (e) {
      throw e;
    } finally {
      setState(() {
        _isLoading = false; // Ocultar el loader
      });
    }
  }

  Future<String> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
      }
    } catch (e) {
      throw e;
    }
    return "Address not found";
  }
}
