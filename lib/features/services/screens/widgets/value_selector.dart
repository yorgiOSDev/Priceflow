import 'package:flutter/material.dart';
import 'package:price_flow_project/utils/constants/colors.dart';
import 'package:price_flow_project/utils/theme/custom_themes/slider_theme.dart';

class ValueSelector extends StatefulWidget {
  final Function(int) onValueChanged;

  const ValueSelector({super.key, required this.onValueChanged});

  @override
  _ValueSelectorState createState() => _ValueSelectorState();
}

class _ValueSelectorState extends State<ValueSelector> {
  final double MAX_VALUE = 300;
  final double MIN_VALUE = 10;
  final int STEP = 10;
  double _currentValue = 10;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: TSliderTheme.lightSliderTheme,
      child: Slider(
        value: _currentValue,
        min: MIN_VALUE,
        max: MAX_VALUE,
        label: "${_currentValue.round()} m²",
        onChanged: (double value) {
          setState(() {
            _currentValue = value;
          });
          widget.onValueChanged(_currentValue.round());
        },
      ),
    );
  }
}
