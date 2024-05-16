import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price_flow_project/utils/constants/colors.dart';

class DatePickerHorizontal extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onSelectDate;

  const DatePickerHorizontal({super.key, required this.onSelectDate, required this.initialDate});

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerHorizontalState createState() => _DatePickerHorizontalState();
}

class _DatePickerHorizontalState extends State<DatePickerHorizontal> {
  late DateTime _selectedDate;
  final int daysToShow = 30;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  List<Widget> _buildDateWidgets() {
    List<Widget> list = [];
    for (int i = 0; i < daysToShow; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      list.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
              widget.onSelectDate(date);  // Llama al callback con la nueva fecha
            });
          },
          child: Container(
            width: 72,
            decoration: BoxDecoration(
              color: _selectedDate.day == date.day &&
                      _selectedDate.month == date.month &&
                      _selectedDate.year == date.year
                  ? TColors.primary
                  : TColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${date.day}".padLeft(2, '0'),
                  style: TextStyle(
                    color: _selectedDate.day == date.day &&
                      _selectedDate.month == date.month &&
                      _selectedDate.year == date.year
                     ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat('EEE').format(date),
                  style: TextStyle(
                    color: _selectedDate.day == date.day &&
                      _selectedDate.month == date.month &&
                      _selectedDate.year == date.year
                     ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 72,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _buildDateWidgets(),
          ),
        ),
      ],
    );
  }
}