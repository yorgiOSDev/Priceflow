import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_flow_project/features/services/screens/widgets/service_detail.dart';
import 'package:price_flow_project/utils/constants/image_strings.dart';

import '../../../../utils/constants/colors.dart';

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final double size;

  const ServiceTile({
    super.key,
    required this.icon,
    required this.label,
    this.size = 30.0, 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> Get.to( ()=> ServiceDetail(serviceName: label) ),
      child: Container(
        height: 96,
        width: 128,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: TColors.secondary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(height: 12,),
            const Image(
              image: AssetImage(TImages.cleaningService),
              height: 40,
              width: 40,
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}