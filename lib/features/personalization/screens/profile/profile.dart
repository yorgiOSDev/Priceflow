import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:price_flow_project/features/authentication/services/user_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  late Future _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await UserService().retrieveAccount();
      _firstNameController.text = userData.firstName;
      _lastNameController.text = userData.lastName;
      _emailController.text = userData.email;
      _phoneNumberController.text = userData.phoneNumber;
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final String token = await UserService().getToken() ?? '';
      const String selectedLocale = 'en';

      await UserService().updateAccount(
        token,
        _emailController.text,
        _firstNameController.text,
        _lastNameController.text,
        selectedLocale,
        _passwordController.text,
        _confirmPasswordController.text,
      );
      showAwesomeSnackbar(
          ContentType.success, 'Profile updated successfully.', 'Success');
    } catch (e) {
      showAwesomeSnackbar(
          ContentType.failure, 'Failed to update profile: $e', 'Error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showAwesomeSnackbar(ContentType type, String message, String title) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          color: TColors.primary,
          contentType: type,
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Profile'),
      ),
      body: FutureBuilder(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return _buildProfileForm();
        },
      ),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.md * 1.5),
              child: Column(
                children: [
                  Text(
                    'Upgrade your user information:',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            prefixIcon: Icon(Iconsax.user),
                          ),
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            prefixIcon: Icon(Iconsax.user),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Iconsax.direct),
                    ),
                    enabled: false,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                        labelText: 'Phone Number', prefixIcon: Icon(Iconsax.call)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections * 1.8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _passwordVisible ? Iconsax.eye : Iconsax.eye_slash),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        icon: Icon(_confirmPasswordVisible
                            ? Iconsax.eye
                            : Iconsax.eye_slash),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Padding(
          padding: const EdgeInsets.all(TSizes.md * 1.5),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _updateProfile,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: TColors.primary,
              side: BorderSide.none,
              disabledBackgroundColor: TColors.primary.withOpacity(0.4),
            ),
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }
}
