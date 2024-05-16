import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:price_flow_project/features/authentication/screens/login/login.dart';
import 'package:price_flow_project/features/authentication/services/user_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import 'terms_and_condition_checkbox.dart';

class TSignUpForm extends StatefulWidget {
  const TSignUpForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TSignUpFormState createState() => _TSignUpFormState();
}

class _TSignUpFormState extends State<TSignUpForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              /// First Name
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                      labelText: TTexts.firstName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
              const SizedBox(
                width: TSizes.spaceBtwInputFields,
              ),

              /// Last Name
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                      labelText: TTexts.lastName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          /// Email
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
                labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),

          /// Phone Number
          TextFormField(
            controller: _phoneNoController,
            decoration: const InputDecoration(
                labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),

          /// Password
          TextFormField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: TTexts.password,
                // Agregar un botón para alternar la visibilidad de la contraseña
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible ? Iconsax.eye : Iconsax.eye_slash),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          /// Password Confirm
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_confirmPasswordVisible,
            decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: TTexts.password,
                // Agregar un botón para alternar la visibilidad de la contraseña
                suffixIcon: IconButton(
                  icon: Icon(_confirmPasswordVisible ? Iconsax.eye : Iconsax.eye_slash),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
              ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          /// Terms and Conditions
          TTermsAndConditionCheckbox(
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value!;
              });
            },
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50), 
              backgroundColor: TColors.primary,
              side: BorderSide.none,
              disabledBackgroundColor: TColors.primary.withOpacity(0.7)
            ),
            onPressed: _acceptedTerms
              ? () async {
                if (_passwordController.text == _confirmPasswordController.text) {
                  try {
                    await UserService().createUser(
                      _emailController.text,
                      _passwordController.text,
                      _confirmPasswordController.text,
                      _firstNameController.text,
                      _lastNameController.text,
                      _phoneNoController.text,
                    );
                    // Si todo es exitoso, navegar a la siguiente pantalla
                    Get.to(() => const LoginScreen());
                  } catch (e) {
                    // Muestra un diálogo de error personalizado
                    _showErrorDialog(
                      e.toString().replaceFirst('Exception: ', '')
                    );
                  }
                } else {
                  // Informar que las contraseñas no coinciden con un diálogo de error personalizado
                  _showErrorDialog('Passwords do not match');
                }
              }
            : null,
            child: const Text(TTexts.createAccount),
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
