import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'features/authentication/screens/login/login.dart';
import 'features/authentication/services/user_service.dart';
import 'home_page.dart';
import 'utils/constants/colors.dart';
import 'utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // App permissions
  await _requestLocationPermission();

  runApp(const MainApp());
}

Future<void> _requestLocationPermission() async {
  LocationPermission permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  } else if (permission == LocationPermission.deniedForever) {
  } else if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {

  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final UserService userService = UserService();
    final String? refreshToken = await userService.getRefreshToken();
    if (refreshToken == null) {
      return const LoginScreen(); // No hay refreshToken, por lo tanto, ir a login
    }
    // Intenta hacer refresh del login
    final bool loginSuccess = await userService.refreshLoginUser(refreshToken);
    if (loginSuccess) {
      return const HomePage(); // Login refresh exitoso, ir a home
    } else {
      print('Aqui hay un error');
      return const LoginScreen(); // Login refresh fallido, ir a login
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(), // Usa el método _getInitialScreen aquí
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Mientras espera, muestra un indicador de carga
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
                )
              )
            )
          );
        }

        // Una vez que el future se resuelve, muestra la pantalla adecuada
        final Widget homeScreen = snapshot.data ?? const LoginScreen(); // Fallback a LoginScreen por si acaso

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light, // Selecciona el tema claro
          theme: TAppTheme.lightTheme, // Tema claro personalizado
          darkTheme: TAppTheme.darkTheme, // Tema oscuro personalizado
          home: homeScreen, // Muestra la pantalla adecuada basada en el estado del token
        );
      },
    );
  }
}
