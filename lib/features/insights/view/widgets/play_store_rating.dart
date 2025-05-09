import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../shared/view/widgets/global_widgets.dart';

class PlatyStoreRating extends StatefulWidget {
  final String url;
  final int count;
  final double initialRating;
  final IconData icon;
  final double itemSize;
  final Color color;
  final bool ignoreGesture;

  const PlatyStoreRating(
      {super.key,
      required this.url,
      this.count = 5,
      this.initialRating = 0,
      this.icon = Icons.star_border,
      this.color = Colors.amber,
      this.itemSize = 40,
      this.ignoreGesture = false});

  @override
  State<PlatyStoreRating> createState() => _PlatyStoreRatingState();
}

class _PlatyStoreRatingState extends State<PlatyStoreRating> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  void delayShowSnackBar(BuildContext context) {
    if (context.mounted) {
      IconSnackBar.show(context,
          duration: const Duration(seconds: 2),
          label: "Thank you for your feedback",
          snackBarType: SnackBarType.success);
    }
    timer = Timer(const Duration(seconds: 2), () {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RatingBar.builder(
      ignoreGestures: widget.ignoreGesture,
      initialRating: widget.initialRating,
      itemSize: widget.itemSize,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: widget.count,
      itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
      itemBuilder: (context, index) {
        return Icon(
          widget.icon,
          color: widget.color,
        );
      },
      onRatingUpdate: (rating) {
        if (rating < 4) {
          if (timer == null || timer!.isActive == false) {
            delayShowSnackBar(context);
          }
        } else {
          if (timer == null || timer!.isActive == false) {
            delayShowSnackBar(context);
          }
          openUrl(url: widget.url, context: context);
        }
      },
    );
  }
}
