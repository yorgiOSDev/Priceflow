import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../authentication/services/user_service.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({
    super.key,
    required this.address,
    required this.selectedAddress, required this.onEdit, required this.onDelete,
  });

   final Address address;
  final bool selectedAddress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      child: Stack(
        children: [
          if (selectedAddress)
            Positioned(
              right: 5,
              top: 0,
              child: Icon(Iconsax.tick_circle, color: dark ? TColors.light : TColors.dark.withOpacity(0.8)),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Positioned(
                right: 0,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.edit),
                      onPressed: onEdit, // Utiliza la función callback aquí
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.trash),
                      onPressed: onDelete, // Utiliza la función callback aquí
                    ),
                  ],
                ),
              ),
              Text(
                '${address.firstName} ${address.lastName}',
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: TSizes.sm / 2),
              Text(address.phoneNumber, overflow: TextOverflow.ellipsis, maxLines: 1),
              const SizedBox(height: TSizes.sm / 2),
              Text(
                '${address.address1}, ${address.city}, ${address.zipCode}, ${address.stateName}, ${address.countryName}',
                softWrap: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
