import 'package:budgify/features/expense_tracker/view/widgets/dialog/reusable_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../shared/view/widgets/buttons/reusable_icon_button.dart';
import '../../../../../shared/view/widgets/global_widgets.dart';
import 'dialog_widgets.dart';

class ReusableDialogClass {
  static Future<bool> showYesNoDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ReusableDialog(
        dialogTitle:  "Are you sure you want to exit?",
        dialogRowItem1: DialogYesNoButton(
          text: 'Yes',
          fontSize: 16,
          onTapFun: () {
            SystemNavigator.pop();
          },
          color: Colors.redAccent,
        ),
        dialogRowItem2: DialogYesNoButton(
          text: 'No',
          fontSize: 16,
          onTapFun: () {
            Navigator.of(context).pop();
          },
          color: Colors.green,
        ),
      ),
    );
  }

  static Future<bool> deletedEntryDialog({required BuildContext context,required VoidCallback onClick,String text="transaction"}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ReusableDialog(
        dialogTitle:  "Are you sure you want to delete $text?",
        dialogRowItem1: DialogYesNoButton(
          text: 'Yes',
          fontSize: 16,
          onTapFun: onClick ,
          color: Colors.redAccent,
        ),
        dialogRowItem2: DialogYesNoButton(
          text: 'No',
          fontSize: 16,
          onTapFun: () {
            Navigator.of(context).pop();
          },
          color: Colors.green,
        ),
      ),
    );
  }

  static Future<bool> connectUsDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      // barrierColor: Colors.transparent, // Makes the background fully transparent
      builder: (context) => ReusableDialog(
        dialogTitle:  "Connect with us on",
        dialogRowItem1: ReusableIconButton(
          title: 'Youtube',
          socialIconSize: 20,
          icon: FontAwesomeIcons.youtube,
          colors: AppGradients.youtubeGradient,
          onTap: () =>openUrl(url: Constants.youtubeLink, context: context)
        ),
        dialogRowItem2: ReusableIconButton(
            title: 'Instagram',
            socialIconSize: 18,
            spacerWidth: 4,
            icon: FontAwesomeIcons.instagram,
            colors: AppGradients.instagramGradient,
            onTap: () =>openUrl(url: Constants.instagramLink, context: context)
        )
      ),
    );
  }
}