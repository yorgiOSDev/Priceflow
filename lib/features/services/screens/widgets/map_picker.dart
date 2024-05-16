import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapPicker extends StatefulWidget {
  final Function(double, double, String) onLocationSelected;

  const MapPicker({
    Key? key,
    required this.onLocationSelected
  }) : super(key: key);

  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  GoogleMapController? _controller;
  LatLng _currentCenter = const LatLng(37.77483, -122.41942); // Valor inicial, será actualizado a la ubicación actual del usuario
  double _currentZoom = 15.0; // Zoom fijo

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          onCameraMove: _onCameraMove,
          onCameraIdle: _getAddressFromLatLng,
          initialCameraPosition: CameraPosition(
            target: _currentCenter,
            zoom: _currentZoom,
          ),
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
        ),
        const Icon(Icons.location_pin, size: 50, color: Colors.red),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _locateMe();
  }

  void _locateMe() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _currentCenter = LatLng(position.latitude, position.longitude);
    _controller!.animateCamera(CameraUpdate.newLatLngZoom(_currentCenter, _currentZoom));
  }

  void _onCameraMove(CameraPosition position) {
    _currentCenter = position.target;
    _currentZoom = position.zoom;
  }

  void _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentCenter.latitude, _currentCenter.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String formattedAddress = '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
        widget.onLocationSelected(_currentCenter.latitude, _currentCenter.longitude, formattedAddress);
      }
    } catch (e) {
      print('Error al obtener la dirección: $e');
    }
  }
}
