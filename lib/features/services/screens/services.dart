import 'package:flutter/material.dart';
import 'package:price_flow_project/utils/constants/sizes.dart';
import '../../../utils/constants/colors.dart';
import 'widgets/service_tile.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: TColors.secondary,
                borderRadius: BorderRadius.circular(8)
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search for services",
                prefixIcon: Icon(Icons.search, color: Colors.black,),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                prefixIconColor: Colors.black,
                contentPadding: EdgeInsets.symmetric(vertical: TSizes.md)
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          Text(
              'All Services',
              style: Theme.of(context).textTheme.headlineSmall
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          const ServiceTile(icon: Icons.cleaning_services, label: 'Cleaning')
        ],
      ),
    );
  }
}


