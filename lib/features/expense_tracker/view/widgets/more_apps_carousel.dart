import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "../../../../shared/view/widgets/containers/reusable_stylish_container.dart";
import "../../../../shared/view/widgets/global_widgets.dart";
import "../../data/more_apps_contents.dart";

class ReusableMoreAppsCarousel extends StatelessWidget {
  final Axis scrollDirection;
  final double viewportFraction;
  final double w;
  final bool infiniteScroll;

  const ReusableMoreAppsCarousel(
      {required this.w,
        this.scrollDirection = Axis.horizontal,
        this.viewportFraction = 0.82,
        this.infiniteScroll = false,
        super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: moreAppsContentsList.length,
      itemBuilder: (BuildContext context, int itemIndex, int i) {
        final e = moreAppsContentsList[itemIndex];
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ReusableStylishContainer(
            w: w,
            colors: e.colors,
            title: e.title,
            description: e.description,
            image: e.image,
            onTap: () {
              openUrl(url: e.url, context: context);
            },
          ),
        );
      },
      options: CarouselOptions(
        initialPage: 0,
        autoPlay: true,
        height: 485,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 600),
        scrollDirection: scrollDirection,
        viewportFraction: viewportFraction,
        aspectRatio: 1.1,
        enableInfiniteScroll: infiniteScroll,
        enlargeCenterPage: true,
        pauseAutoPlayOnTouch: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        // pauseAutoPlayOnManualNavigate: true,
        // enlargeStrategy: CenterPageEnlargeStrategy.scale,
      ),
    );
  }
}
