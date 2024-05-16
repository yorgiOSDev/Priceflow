import 'package:flutter/material.dart';
import 'package:price_flow_project/utils/constants/colors.dart';

class TimePickerHorizontal extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onSelectTime;

  const TimePickerHorizontal({super.key, required this.onSelectTime, required this.initialTime});

  @override
  // ignore: library_private_types_in_public_api
  _TimePickerHorizontalState createState() => _TimePickerHorizontalState();
}

class _TimePickerHorizontalState extends State<TimePickerHorizontal> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }
  // Genera una lista de horarios cada 30 minutos para las 24 horas
  final List<TimeOfDay> times = [
    for (int hour = 0; hour < 24; hour++)
      for (int minute = 0; minute < 60; minute += 30)
        TimeOfDay(hour: hour, minute: minute)
  ];

  List<Widget> _buildTimeWidgets() {
    List<Widget> list = [];
    for (var time in times) {
      bool isSelected = _selectedTime.hour == time.hour && _selectedTime.minute == time.minute;
      list.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedTime = time;
              widget.onSelectTime(time);
            });
          },
          child: Container(
            width: 72, // Aumentar el ancho para mejor visualización
            decoration: BoxDecoration(
              color: isSelected ? TColors.primary : TColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  time.format(context),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _buildTimeWidgets(),
          ),
        ),
      ],
    );
  }
}
