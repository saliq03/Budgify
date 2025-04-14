import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

void openUrl(
    {required String url,
    required BuildContext context,
    bool isExternal = false,
    String label = "Unable to open!"}) async {
  try {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri) || isExternal) {
      await launchUrl(uri,
          mode: isExternal
              ? LaunchMode.externalApplication
              : LaunchMode.platformDefault);
    } else {
      if (context.mounted) {
        IconSnackBar.show(context,
            label: label, snackBarType: SnackBarType.alert);
      }
    }
  } catch (e) {
    if (context.mounted) {
      IconSnackBar.show(context,
          label: "The link cannot be opened!", snackBarType: SnackBarType.fail);
    }
  }
}

Image staticImage(
        {required String assetName,
        double? width,
        double? height,
        Color? color,
        BoxFit fit = BoxFit.cover}) =>
    Image.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );

SizedBox spacerH([double height = 20]) => SizedBox(height: height);

SizedBox spacerW([double width = 20]) => SizedBox(width: width);
