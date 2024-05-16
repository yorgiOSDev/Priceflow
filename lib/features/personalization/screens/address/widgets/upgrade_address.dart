import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../authentication/services/user_service.dart';

class UpgradeAddressScreen extends StatefulWidget {
  const UpgradeAddressScreen({super.key, required this.addressId});

  final String addressId;

  @override
  State<UpgradeAddressScreen> createState() => _UpgradeAddressScreenState();
}

class _UpgradeAddressScreenState extends State<UpgradeAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _street2Controller = TextEditingController();
  final TextEditingController _stateNameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  Address? addressDetails;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _labelController.dispose();
    _street2Controller.dispose();
    _stateNameController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
  if (_formKey.currentState!.validate()) {
    try {
      await UserService().updateAddress(
        addressId: widget.addressId, // Utiliza el addressId del widget
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        companyName: _companyController.text,
        address1: _streetController.text,
        address2: _street2Controller.text,
        city: _cityController.text,
        stateName: _stateNameController.text,
        countryIso: _countryController.text,
        zipCode: _postalCodeController.text,
        phoneNumber: _phoneNumberController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address updated successfully!"))
      );
      Get.back(result: 'updated'); // Usamos un resultado personalizado para indicar un éxito en la actualización
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update address: $e"))
      );
    }
  }
}
  
  Future<Address> _fetchAddressDetails() async {
    return UserService().getAddressById(widget.addressId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(showBackArrow: true, title: Text('Upgrade your Address')),
      body: FutureBuilder<Address>(
        future: _fetchAddressDetails(), // Este es el método que obtiene los detalles de la dirección
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
              )
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            // Asignar los valores del snapshot a los controladores si hay datos
            addressDetails = snapshot.data;
            _firstNameController.text = addressDetails!.firstName;
            _lastNameController.text = addressDetails!.lastName;
            _cityController.text = addressDetails!.city;
            _companyController.text = addressDetails!.company;
            _countryController.text = addressDetails!.countryName;
            _phoneNumberController.text = addressDetails!.phoneNumber;
            _postalCodeController.text = addressDetails!.zipCode;
            _stateNameController.text = addressDetails!.stateName;
            _labelController.text = addressDetails!.label;
            _streetController.text = addressDetails!.address1;
            _street2Controller.text = addressDetails!.address2;
            // ... haz esto para el resto de los campos ...
            // Ahora construye tu formulario con los controladores ya rellenados
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: TSizes.spaceBtwItems,),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Last name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                
                TextFormField(
                  controller: _labelController,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Label'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your label';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Company'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Company';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TextFormField(
                  controller: _streetController,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TextFormField(
                  controller: _street2Controller,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Address 2'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address 2';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Country ISO'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your country ISO';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TextFormField(
                  controller: _postalCodeController,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Zip Code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your zip code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TextFormField(
                  controller: _stateNameController,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'State Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your state name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), 
                    backgroundColor: TColors.primary,
                    side: BorderSide.none
                  ),
                  child: const Text('Save'),
                ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // En caso de que no haya datos, puedes mostrar un mensaje o tratar de otra manera
            return const Center(child: Text('No address data available.'));
          }
        },
      )
    );
  }

}
