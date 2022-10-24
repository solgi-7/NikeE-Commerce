import 'package:flutter/material.dart';
import 'package:seven_learn_nick/data/banner_entity.dart';
import 'package:seven_learn_nick/ui/widget/image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatelessWidget {
  final PageController _controller = PageController();
  final List<BannerEntity> banners;
  BannerSlider({Key? key, required this.banners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          PageView.builder(
              controller: _controller,
              itemCount: banners.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _Silde(banner: banners[index]);
              }),
          Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Center(
                  child: SmoothPageIndicator(
                controller: _controller,
                count: banners.length,
                effect: WormEffect(
                  paintStyle: PaintingStyle.fill,
                  dotHeight: 3,
                  radius: 4,
                  dotColor: Colors.grey.shade400,
                  dotWidth: 20,
                  activeDotColor: Theme.of(context).colorScheme.onBackground,
                ),
              ))),
        ],
      ),
    );
  }
}

class _Silde extends StatelessWidget {
  const _Silde({
    Key? key,
    required this.banner,
  }) : super(key: key);

  final BannerEntity banner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0),
      child: ImageLoadingService(
        borderRadius: BorderRadius.circular(12),
        imageUrl: banner.imageUrl,
      ),
    );
  }
}
