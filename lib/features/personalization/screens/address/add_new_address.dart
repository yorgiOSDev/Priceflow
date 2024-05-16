import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/services/user_service.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
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
      await UserService().createAnAddress(
        _firstNameController.text,
          _lastNameController.text,
          _labelController.text,
          _companyController.text,
          _streetController.text,
          _street2Controller.text,
          _cityController.text,
          _countryController.text,
          _postalCodeController.text,
          _phoneNumberController.text,
          _stateNameController.text,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address added successfully!"))
      );
      // Utiliza Get para volver y pasar un valor booleano indicando que una dirección fue añadida
      Get.back(result: true);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add address: $e"))
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(showBackArrow: true, title: Text('Add New Address')),
      body: SingleChildScrollView(
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
      ),
    );
  }
}
