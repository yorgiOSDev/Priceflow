import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_flow_project/features/authentication/services/user_service.dart';
import 'package:price_flow_project/features/personalization/screens/address/widgets/upgrade_address.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import 'add_new_address.dart';
import 'widgets/single_address.dart';

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({super.key});

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  late Future<List<Address>> _futureAddresses;

  @override
  void initState() {
    super.initState();
    _loadUserAddresses();
  }

  void _loadUserAddresses() {
    _futureAddresses = UserService().getUserAddresses();
  }

  void _deleteAddress(String addressId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 216, 243, 255),
          title: const Text('Confirm'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.black),),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red),),
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar el diálogo
                await UserService().removeAddress(addressId); // Borrar la dirección
                _loadUserAddresses(); // Recargar las direcciones
                setState(() {}); // Actualizar el UI
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Addresses', style: Theme.of(context).textTheme.headlineSmall,)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Espera el resultado de AddNewAddressScreen
          final result = await Get.to(() => const AddNewAddressScreen());
          // Si el resultado es 'true', entonces recarga las direcciones
          if (result == true) {
            setState(() {
              _loadUserAddresses();
            });
          }
        },
        backgroundColor: TColors.primary,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Address>>(
        future: _futureAddresses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
              )
            );
          } else if (snapshot.hasError) {
            // El mensaje de error aquí corresponderá al mensaje lanzado en UserService
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No addresses available.'));
          }

          final addresses = snapshot.data!;
          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return TSingleAddress(
                address: address,
                selectedAddress: false,
                onEdit: () {
                  Get.to(() => UpgradeAddressScreen(addressId: address.id))
                    ?.then((result) {
                    // Si hubo una actualización, recarga la lista de direcciones
                    if (result == 'updated') {
                      setState(() {
                        _loadUserAddresses();
                      });
                    }
                  });
                },
                onDelete: () async {
                  _deleteAddress(address.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}

