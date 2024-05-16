import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TTermsAndConditionCheckbox extends StatelessWidget {
  const TTermsAndConditionCheckbox({super.key, required this.onChanged, required this.value});

  final ValueChanged<bool?> onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: TSizes.lg,
          height: TSizes.lg,
          child: Checkbox(
            value: value, 
            onChanged: onChanged,
            fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return TColors.primary; // Color cuando el checkbox está seleccionado
              }
              return TColors.white; // Color por defecto
            }),
          )
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems, // Modifica esto si es necesario para el espaciado horizontal
        ),
        Expanded( // Añadido el widget Expanded aquí
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: '${TTexts.iAgreeTo} ',
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                    text: TTexts.privacyPolicy,
                    style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? TColors.white : TColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: dark ? TColors.white : TColors.primary,
                    )),
                TextSpan(
                    text: ' ${TTexts.and} ',
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                    text: TTexts.termsOfUse,
                    style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? TColors.white : TColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: dark ? TColors.white : TColors.primary,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

