import 'package:flutter/material.dart';
import 'package:price_flow_project/utils/constants/colors.dart';

class PropertyContainer extends StatelessWidget {
  final IconData icon;
  final String label;
  final double size;
  final bool isSelected;  // Nuevo parámetro para manejar la selección

  const PropertyContainer({
    super.key,
    required this.icon,
    required this.label,
    required this.size,
    this.isSelected = false,  // Por defecto, no está seleccionado
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? TColors.primary : TColors.secondary,  // Cambia el color si está seleccionado
        // border: Border.all(color: isSelected ? TColors.primary : Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: size, color: isSelected ? Colors.white : Colors.black,),
          const SizedBox(height: 4,),
          Text(label, style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          )),
        ],
      ),
    );
  }
}
