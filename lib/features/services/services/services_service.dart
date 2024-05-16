import 'dart:convert';
import 'package:price_flow_project/features/authentication/services/user_service.dart';
import 'package:price_flow_project/features/personalization/screens/settings/settings.dart';

import '../../personalization/screens/address/address.dart';
import '../screens/services.dart';

class ServicesService {
  final String _baseUrl = 'https://squirrel.priceflow.c66.me';

  ///Type of cleaning service (deep cleaning, easy cleaning, etc...)
  Future<List<CleaningService>> getCleaningServices() async {
    final token = await UserService().getToken();
    final refreshToken = await UserService().getRefreshToken();
    var cleaningServicesId = "29"; // Hardcoded for now but it needs to be change
    final headers = {
      'Accept': 'application/vnd.api+json',
      'Authorization': '$token',
    };

    var request = FlexibleHttpRequest(
      url: '$_baseUrl/api/v2/storefront/products?filter[taxons]=$cleaningServicesId&include=images&fields[image]=transformed_url&image_transformation[size]=600x600&fields[product]=images,name,description,relationships&sort=name',
      headers: headers,
      method: 'GET',
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        return _parseCleaningServicesResponse(jsonDecode(response.body));
      } else {
        if (response.statusCode == 401){
          if (await UserService().refreshLoginUser(refreshToken!)) {
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

  List<CleaningService> _parseCleaningServicesResponse(response){
    List<CleaningService> cleaningServices = [];
    for(var i = 0; i < response['meta']['count']; i++){
      int id = int.parse(response['data'][i]['id']);  // Convierte ID de String a int
      CleaningService cleaningService = CleaningService(
          id,
          response['data'][i]['attributes']['name'],
          response['data'][i]['attributes']['description'],
          _findOnIncluded(response['included'], "image", response['data'][i]['relationships']['images']['data'][0]['id'])
      );
      cleaningServices.add(cleaningService);
    }
    return cleaningServices;
  }

  _findOnIncluded(includedData, type, id){
    for(var i = 0; i < includedData.length; i++){
      if(includedData[i]['id'] == id && includedData[i]['type'] == type){
        return includedData[i]['attributes']['transformed_url'];
      }
    }
    return "";
  }

  /// Book Services service
  Future<Map<String, dynamic>> bookService(
    String propertyType,
    int propertySize,
    String bookingDate,
    int serviceId,
    double longitude,
    double latitude,
    String address
  ) async {
    final token = await UserService().getToken();
    final refreshToken = await UserService().getRefreshToken();
    final headers = {
      'Content-Type': 'application/vnd.api+json',
      'Accept': 'application/vnd.api+json',
      'Authorization': token!,
    };
    final body = {
      'booking': {
        'service_type': 'cleaning',
        'property_type': propertyType,
        'property_size': propertySize,
        'booking_date': bookingDate,
        'service_id': serviceId,  //ID del serviceClenaing selected
        'longitude': longitude,
        'latitude': latitude,
        'address': address,
      }
    };
    var request = FlexibleHttpRequest( 
      url: '$_baseUrl/api/v2/storefront/bookings', 
      method: 'POST', 
      headers: headers,
      body: body,
    );
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Devuelve el cuerpo de la respuesta
      } else {
        if (response.statusCode == 401){
          if (await UserService().refreshLoginUser(refreshToken!)) {
            const ServicesScreen();
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

  ///Confirm Book Service
  Future<void> confirmBookService(String id) async {
    final token = await UserService().getToken();
    final refreshToken = await UserService().getRefreshToken();
    final headers = {
      'Content-Type': 'application/vnd.api+json',
      'Accept': 'application/vnd.api+json',
      'Authorization': token!,
    };
    final body = {
      "id": id
    };

    var request = FlexibleHttpRequest(
      url: '$_baseUrl/api/v2/storefront/bookings/confirm',
      headers: headers,
      method: 'POST',
      body: body,
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        ///Do something
      } else {
        if (response.statusCode == 401){
          if (await UserService().refreshLoginUser(refreshToken!)) {
            const ServicesScreen();
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

  ///List of bookings services confirmed
  Future<List<dynamic>> getListOfBookedServices() async {
    final token = await UserService().getToken();
    final refreshToken = await UserService().getRefreshToken();
    var headers = {
      'Content-Type': 'application/vnd.api+json',
      'Accept': 'application/vnd.api+json',
      'Authorization': token!
    };

    var request = FlexibleHttpRequest(
      url: '$_baseUrl/api/v2/storefront/bookings/list',
      headers: headers,
      method: 'GET',
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Devuelve el cuerpo de la respuesta
      } else {
        if (response.statusCode == 401){
          if (await UserService().refreshLoginUser(refreshToken!)) {
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
}


class CleaningService
{
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  CleaningService(this.id, this.name, this.description, this.imageUrl);
}