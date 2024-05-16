import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:price_flow_project/features/personalization/screens/address/address.dart';
import 'package:price_flow_project/features/personalization/screens/settings/settings.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login/login.dart';

class UserService {
  final String _baseUrl = 'https://squirrel.priceflow.c66.me'; // Ajusta la URL
  ///Create User
  Future<void> createUser(
    String email,
    String password,
    String passwordConfirmation,
    String firstName,
    String lastName,
    String phoneNumber,
  ) async {
    final headers = {"Content-Type": "application/json"};
    final requestBody = {
      "user": {
        "email": email,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "confirm_password": passwordConfirmation,
      }
    };
    var request = FlexibleHttpRequest( url: '$_baseUrl/api/v2/storefront/account', method: 'POST', headers: headers, body: requestBody);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        ///Created Account
      } else {
        // Asume que el servidor devuelve un JSON con un campo de mensaje de error
        final Map<String, dynamic> decodedBody = json.decode(response.body);
        final String errorMessage =
            decodedBody['error'] ?? 'Ocurrió un error desconocido.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  ///Refresh Login user
  Future<bool> refreshLoginUser(String refreshtoken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final headers = {"Content-Type": "application/json"};
    final requestBody = {
      "grant_type": "refresh_token",
      "refresh_token": refreshtoken,
    };
    var request = FlexibleHttpRequest(url: '$_baseUrl/spree_oauth/token', method: 'POST', headers: headers, body: requestBody);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var accessToken = data["access_token"]; // Acceder al access_token
        if (accessToken != null) {
          // Guarda el access_token con el prefijo 'Bearer '
          prefs.setString('access_token', 'Bearer $accessToken');
          return true; // Token renovado exitosamente
        } else {
          return false; // No se encontró access_token en la respuesta
        }
      } else {
        return false; // Respuesta no exitosa
      }
    } catch (e) {
      print('Error during token refresh: $e');
      return false; // Error durante la solicitud
    }
  }


  ///Create login user
  Future<void> loginUser(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final headers = {"Content-Type": "application/json"};
    final requestBody = {
      "grant_type": "password",
      "username": email,
      "password": password,
    };
    var request = FlexibleHttpRequest( url: '$_baseUrl/spree_oauth/token', method: 'POST', headers: headers, body: requestBody);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var accessToken = data["access_token"]; // Acceder al access_token
        var refreshToken = data["refresh_token"]; // Acceder al refresh_token
        if (accessToken != null && refreshToken != null) {
          prefs.setString('access_token', 'Bearer $accessToken'); // Guarda el access_token con el prefijo 'Bearer '
          prefs.setString( 'refresh_token', refreshToken); // Guarda el refresh_token
        } else {
          //Manejar cuando no se encuentra tokens en la respuesta
        }
      } else {
        if (response.statusCode == 400) {
          throw ("Email or password is incorrect.");
        } else {
          final Map<String, dynamic> decodedBody = json.decode(response.body);
          final String errorMessage = decodedBody['error'] ?? 'An unknown error occurred.';
          throw errorMessage;
        }
      }
    } catch (e) {
      throw ('$e');
    }
  }

  ///Get Token User
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Asegúrate de recuperar 'access_token', no 'token'.
    return prefs.getString('access_token');
  }

  ///Get Refresh Token user
  Future<String?> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Asegúrate de recuperar 'refresh_token', no 'token'.
    return prefs.getString('refresh_token');
  }

  ///Get account info
  Future<UserData> retrieveAccount() async {
    final token = await getToken();
    final refreshToken = await getRefreshToken();
    final headers = {
      "Content-Type": "application/json",
      "Authorization": token!,
    };
    var request = FlexibleHttpRequest( url: '$_baseUrl/api/v2/storefront/account', method: 'GET', headers: headers);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        var attributes = data['attributes'];
        // Crea una instancia de UserData usando los datos obtenidos
        return UserData.fromJson(attributes);
      } else {
        if (response.statusCode == 401) {
          if (await refreshLoginUser(refreshToken!)) {
            retrieveAccount();
          }
        }
        // Manejar errores o lanzar una excepción si los datos no pueden ser obtenidos
        final Map<String, dynamic> decodedBody = json.decode(response.body);
        final String errorMessage = decodedBody['error'] ?? 'An unknown error occurred.';
        throw errorMessage;
      }
    } catch (e) {
      throw '$e';
    }
  }

  /// LogOut User
  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Elimina el access_token y el refresh_token de las preferencias compartidas.
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    // Aquí podrías redirigir al usuario a la pantalla de inicio de sesión o realizar otras acciones necesarias después del cierre de sesión.
    Get.offAll(() => const LoginScreen());
  }

  /// Update Account
  Future<void> updateAccount(
    String token,
    String email,
    String firstName,
    String lastName,
    String selectedLocale,
    String password,
    String passwordConfirmation) async {
    final headers = { "Content-Type": "application/vnd.api+json", "Authorization": token};
    final body = {
      "user": {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "selected_locale": selectedLocale,
        "password": password,
        "password_confirmation": passwordConfirmation,
      }
    };
    final refreshToken = await getRefreshToken();
    var request = FlexibleHttpRequest( url: '$_baseUrl/api/v2/storefront/account', method: 'PATCH', headers: headers, body: body);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        // El recurso se actualizó correctamente
      } else {
        if (response.statusCode == 401) {
          if (await refreshLoginUser(refreshToken!)) {
            const SettingsScreen();
          }
        }
        final Map<String, dynamic> decodedBody = json.decode(response.body);
        final String errorMessage = decodedBody['error'] ?? 'An unknown error occurred.';
        throw errorMessage;
      }
    } catch (e) {
      throw '$e';
    }
  }

  /// Get The User address
  Future<List<Address>> getUserAddresses() async {
    final token = await getToken();
    final refreshToken = await getRefreshToken();
    final headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };
    var request = FlexibleHttpRequest( url: '$_baseUrl/api/v2/storefront/account/addresses', method: 'GET', headers: headers);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> addressesJson = json.decode(response.body)['data'];
        return addressesJson.map((json) => Address.fromJson(json)).toList();
      } else {
        if (response.statusCode == 401) {
          if (await refreshLoginUser(refreshToken!)) {
            const UserAddressScreen();
          }
        }
        final Map<String, dynamic> decodedBody = json.decode(response.body);
        final String errorMessage = decodedBody['error'] ?? 'An unknown error occurred.';
        throw errorMessage;
      }
    } catch (e) {
      throw '$e';
    }
  }

  /// Create an address
  Future<void> createAnAddress(
      String firstName,
      String lastName,
      String label,
      String company,
      String address1,
      String address2,
      String city,
      String countryIso,
      String zipcode,
      String phone,
      String stateName) async {
    final token = await getToken();
    final refreshToken = await getRefreshToken();
    final headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {
      "address": {
        "firstname": firstName,
        "lastname": lastName,
        "company": company,
        "address1": address1,
        "address2": address2,
        "city": city,
        "phone": phone,
        "zipcode": zipcode,
        "state_name": stateName,
        "country_iso": countryIso,
        "label": label,
      }
    };
    var request = FlexibleHttpRequest( url: '$_baseUrl/api/v2/storefront/account/addresses', method: 'POST', headers: headers, body: body);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        ///Address created Successfully
      } else {
        print(firstName);
        if (response.statusCode == 401) {
          if (await refreshLoginUser(refreshToken!)) {
            const UserAddressScreen();
          }
        }
        final Map<String, dynamic> decodedBody = json.decode(response.body);
        final String errorMessage = decodedBody['error'] ?? 'An unknown error occurred.';
        throw errorMessage;
      }
    } catch (e) {
      throw '$e';
    }
  }

  ///Remove an address
  Future<void> removeAddress(String addressId) async {
    final token = await getToken();
    final refreshToken = await getRefreshToken();
    final headers = {
      'Accept': 'application/vnd.api+json',
      'Authorization': '$token',
    };
    var request = FlexibleHttpRequest(
      url: '$_baseUrl/api/v2/storefront/account/addresses/$addressId',
      headers: headers,
      method: 'DELETE',
    );

    try {
      var response = await request.send();
      if (response.statusCode == 204) {
        // La dirección se eliminó correctamente
      } else {
        if (response.statusCode == 401){
          if (await refreshLoginUser(refreshToken!)) {
            const UserAddressScreen();
          }
        }
        final Map<String, dynamic> decodedBody = json.decode(response.body);
        final String errorMessage = decodedBody['error'] ?? 'An unknown error occurred.';
        throw errorMessage;
      }
    } catch (e) {
      throw '$e';
    }
  }

  ///Upgrade an address
  Future<bool> updateAddress({
    required String addressId,
    required String firstName,
    required String lastName,
    required String companyName,
    required String address1,
    required String address2,
    required String city,
    required String stateName,
    required String countryIso,
    required String zipCode,
    required String phoneNumber,
  }) async {
    final token = await getToken();
    final refreshToken = await getRefreshToken();
    final headers = {
      'Content-Type': 'application/vnd.api+json',
      'Accept': 'application/vnd.api+json',
      'Authorization': '$token',
    };
    final body = {
      'address': {
        'firstname': firstName,
        'lastname': lastName,
        'company': companyName,
        'address1': address1,
        'address2': address2,
        'city': city,
        'state_name': stateName,
        'country_iso': countryIso,
        'zipcode': zipCode,
        'phone': phoneNumber,
      }
    };
    var request = FlexibleHttpRequest(
      url: '$_baseUrl/api/v2/storefront/account/addresses/$addressId',
      headers: headers,
      method: 'PATCH',
      body: body
    );
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        if (response.statusCode == 401){
          if (await refreshLoginUser(refreshToken!)) {
            const UserAddressScreen();
          }
        }
        final Map<String, dynamic> decodedBody = json.decode(response.body);
        final String errorMessage = decodedBody['error'] ?? 'An unknown error occurred.';
        throw errorMessage;
      }
    } catch (e) {
      throw '$e';
    }
  }

  ///Get Address Data by ID
  Future<Address> getAddressById(String addressId) async {
    final token = await getToken();
    final refreshToken = await getRefreshToken();
    final headers = { 'Content-Type': 'application/json', 'Authorization': '$token'};
    var request = FlexibleHttpRequest( url: '$_baseUrl/api/v2/storefront/account/addresses/$addressId', method: 'GET', headers: headers);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
      return Address.fromJson(data);
      } else {
        if (response.statusCode == 401){
          if (await refreshLoginUser(refreshToken!)) {
            const UserAddressScreen();
          }
        }
        final Map<String, dynamic> decodedBody = json.decode(response.body);
        final String errorMessage = decodedBody['error'] ?? 'An unknown error occurred.';
        throw errorMessage;
      }
    } catch (e) {
      throw '$e';
    }
  }

}



///Address Type
class Address {
  final String id;
  final String firstName;
  final String lastName;
  final String address1;
  final String address2;
  final String city;
  final String zipCode;
  final String phoneNumber;
  final String stateName;
  final String countryName;
  final String company;
  final String label;

  Address({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.address2,
    required this.city,
    required this.zipCode,
    required this.phoneNumber,
    required this.stateName,
    required this.countryName, 
    required this.company,
    required this.label,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    return Address(
      company: attributes['company'],
      label: attributes['label'],
      id: json['id'],
      firstName: attributes['firstname'],
      lastName: attributes['lastname'],
      address1: attributes['address1'],
      address2: attributes['address2'] ?? '', // Handle optional fields
      city: attributes['city'],
      zipCode: attributes['zipcode'],
      phoneNumber: attributes['phone'],
      stateName: attributes['state_name'],
      countryName: attributes['country_iso'],
      
    );
  }
}

///UserData Type
class UserData {
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  // Puedes añadir más campos según sea necesario

  UserData(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber});

  // Método para crear una instancia de UserData desde un mapa (la respuesta de la API)
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] ?? '',
      // Inicializa otros campos de manera similar
    );
  }
}

/// Flexible HTTP Request
  class FlexibleHttpRequest {
    final String url;
    final String method;
    final Map<String, String>? headers;
    final dynamic body;

    FlexibleHttpRequest({
      required this.url,
      this.method = 'GET',
      this.headers,
      this.body,
    });

    Future<http.Response> send() async {
      Uri uri = Uri.parse(url);
      switch (method.toUpperCase()) {
        case 'POST':
          return await http.post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
        case 'PATCH':
          return await http.patch(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
        case 'PUT':
          return await http.put(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
        case 'DELETE':
          return await http.delete(
            uri,
            headers: headers,
          );
        case 'GET':
        default:
          return await http.get(
            uri,
            headers: headers,
          );
      }
    }
}