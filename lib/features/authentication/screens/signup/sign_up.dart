import 'package:flutter/material.dart';

import '../../../../common/widgets/login.signup/form_divider.dart';
import '../../../../common/widgets/login.signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Title
              Text(
                TTexts.signUpTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///Form
              const TSignUpForm(),

              ///Divider
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              const TFormDivider(dividerText: TTexts.orSignUpWith),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              ///Social Buttons
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
