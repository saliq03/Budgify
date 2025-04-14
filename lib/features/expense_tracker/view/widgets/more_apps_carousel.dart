import "package:flutter/material.dart";
import "package:flutter_carousel_widget/flutter_carousel_widget.dart";
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
      this.viewportFraction = 0.9,
      this.infiniteScroll = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableCarousel(
      items: moreAppsContentsList.map((e) {
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
      }).toList(),
      options: ExpandableCarouselOptions(
        initialPage: 0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 2),
        autoPlayAnimationDuration: const Duration(milliseconds: 600),
        scrollDirection: scrollDirection,
        viewportFraction: viewportFraction,
        aspectRatio: 1.1,
        enableInfiniteScroll: infiniteScroll,
      ),
    );
  }
}
