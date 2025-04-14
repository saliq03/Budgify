import 'package:budgify/core/theme/app_styles.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/drawer/custom_drawer.dart';

class ExpenseTrackerPage extends StatefulWidget {
  const ExpenseTrackerPage({super.key});

  @override
  State<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomDrawer(h: h, w: w * 0.7),
      appBar: ReusableAppBar(
        text: 'Expense Tracker',
        // text: 'Profile',
        isCenterText: false,
        isMenu: true,
        onPressed: () {
          _scaffoldKey.currentState!.openEndDrawer();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacerH(),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: w,
                  padding: const EdgeInsets.all(15),
                  height: 250,
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [



                      Text("Total Balance",style: AppStyles.descriptionPrimary(context: context,color: Colors.white),),
                      spacerH(5),
                      Text("\$ 1,000777433.00",style: AppStyles.headingPrimary(context: context,fontSize: 30,color: Colors.white),),
                      spacerH(),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Change Currency",style: AppStyles.headingPrimary(context: context,fontSize: 15,color: Colors.white),),
                      //     spacerW(10),
                      //     const Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 15,),
                      //
                      //   ],
                      // ),

                    ],
                  ),

                ),
              ),
              spacerH(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text("Recent Transactions", style: AppStyles.headingPrimary(context: context,fontSize: 19),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    ),
                  ),

                  spacerW(),
                   
                  ReusableOutlinedButton(onPressed: (){})
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }

}


class ReusableOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const ReusableOutlinedButton({super.key, this.text="View all >>", required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return   InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
        decoration: BoxDecoration(
            color: theme.surface,
            border: Border.all(color: theme.onSurface,width: 0.8),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Text(text,style:  AppStyles.descriptionPrimary(context: context,fontSize: 14),),),
    );
  }
}
