import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:price_flow_project/features/services/services/services_service.dart';
import 'package:price_flow_project/utils/constants/colors.dart'; // Asegúrate de que este archivo existe y contiene TColors
import 'package:price_flow_project/utils/theme/custom_themes/slider_theme.dart';
import '../../../../utils/constants/sizes.dart';

class ImagesSlider extends StatefulWidget {
  final Function(int) onSelectImage;

  const ImagesSlider({super.key, required this.onSelectImage});

  @override
  // ignore: library_private_types_in_public_api
  _ImagesSliderState createState() => _ImagesSliderState();
}

class _ImagesSliderState extends State<ImagesSlider> {
  final ServicesService _servicesService = ServicesService();
  List<CleaningService>? _services;
  int _currentImageIndex = 0;
  bool _isLoading = true;
  String? _errorMessage;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      var services = await _servicesService.getCleaningServices();
      if (!mounted) return;
      setState(() {
        _services = services;
        _isLoading = false;
        if (_services!.isNotEmpty) {
          widget.onSelectImage(_services![0].id);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return loadingSkeleton();
    }

    if (_errorMessage != null || _services == null || _services!.isEmpty) {
      return Center(child: Text(_errorMessage ?? 'No images available.'));
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _services!.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  useOldImageOnUrlChange: true,
                  imageUrl: _services![index].imageUrl,
                  fadeInDuration: const Duration(milliseconds: 0),
                  fadeOutDuration: const Duration(milliseconds: 0),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                  widget.onSelectImage(_services![index].id);
                });
              },
            ),
          ),
        ),
        SliderTheme(
            data: TSliderTheme.lightSliderTheme,
            child: Slider(
              value: _currentImageIndex.toDouble(),
              min: 0,

              max: (_services!.length - 1).toDouble(),
              divisions: _services!.length - 1,
              label: _services![_currentImageIndex].name,
              onChanged: (double value) {
                _pageController.jumpToPage(value.toInt());
              },
            )
        )

      ],
    );
  }

  loadingSkeleton(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CardLoading(
              cardLoadingTheme: CardLoadingTheme(colorOne: TColors.secondary, colorTwo: CardLoadingTheme.defaultTheme.colorTwo),
              height: 128,
            )
          ),
        ),
        SliderTheme(
            data: TSliderTheme.lightSliderTheme,
            child: Slider(
              value: 0.0,
              min: 0,
              max: 10.0, onChanged: (double value) {  },
            )
        )

      ],
    );
  }


}
