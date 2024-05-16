import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:price_flow_project/features/authentication/services/user_service.dart';
import 'package:price_flow_project/home_page.dart';
import 'package:price_flow_project/utils/constants/colors.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../password.configuration/forget_password.dart';
import '../../signup/sign_up.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TLoginFormState createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Agregar una variable para controlar la visibilidad de la contraseña.
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    // Inicializar la visibilidad de la contraseña como false (oculta).
    _passwordVisible = false;
    _emailController.text = "jorge@pf.com";
    _passwordController.text = "password";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      await UserService().loginUser(_emailController.text, _passwordController.text);
      Get.off(() => const HomePage()); // Usar Get.off para evitar volver a la pantalla de login al presionar atrás
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showErrorDialog(context, e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwInputFields,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: !_passwordVisible, // Controla aquí si la contraseña es visible o no
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
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: true, 
                      onChanged: (value) {},
                      fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return TColors.primary; // Color cuando el checkbox está seleccionado
                        }
                        return TColors.grey; // Color por defecto
                      }),
                    ),
                    const Text(TTexts.rememberMe)
                  ],
                ),
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(TTexts.forgetPassword, style: TextStyle(color: TColors.primary),),
                )
              ],
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), 
                backgroundColor: TColors.primary,
                side: BorderSide.none
              ),
              child: const Text(TTexts.signIn),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: TColors.primary,
                    width: 2.0,
                  ),
                ),
                onPressed: () => Get.to(() => const SignUpScreen()),
                child: const Text(TTexts.createAccount, style: TextStyle(color: TColors.primary),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
