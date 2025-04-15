import 'package:budgify/core/theme/app_gradients.dart';
import 'package:budgify/core/theme/app_styles.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:budgify/shared/view/widgets/text_view/reusable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      body: Padding(
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                   gradient: LinearGradient(colors: AppGradients.skyBlueMyAppGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Balance",
                      style: AppStyles.descriptionPrimary(
                          context: context, color: Colors.white),
                    ),
                    spacerH(5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Icon(
                            Icons.attach_money,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        spacerW(2),
                        Flexible(
                            child: Text(
                              "1,0007773.00",
                              style: AppStyles.headingPrimary(
                                  context: context,
                                  fontSize: 30,
                                  color: Colors.white),)),
                      ],
                    ),

                    spacerH(),
      
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ReusableCardDetails(
                            text: "Income",
                            icon: Icons.arrow_circle_up_outlined,
                            currencySymbol: Icons.attach_money,
                            amount: "1,000777433.00",
                          ),
                        ),
                        spacerW(),
                        Expanded(
                          child: ReusableCardDetails(
                            text: "Expense",
                            icon: Icons.arrow_circle_down_outlined,
                            currencySymbol: Icons.attach_money,
                            amount: "23,0007433.00",
                          ),
                        ),
                      ],
                    )
      
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
                  child: Text(
                    "Recent Transactions",
                    style: AppStyles.headingPrimary(
                        context: context, fontSize: 19),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                spacerW(),
                ReusableOutlinedButton(onPressed: () {})
              ],
            ),
            spacerH(10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemBuilder: (context,index) {
                  var income= index%2==0;
                 return  ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                          income?
                          Icons.arrow_circle_up_outlined
                          :Icons.arrow_circle_down_outlined,
                          color: income? Colors.green :Colors.red, size: 40),
                      title: Text("Phone Installments",
                        style: AppStyles.headingPrimary(
                            context: context, fontSize: 18),),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Icon(
                             income? Icons.add :Icons.remove,
                              color: income? Colors.green :Colors.red,
                              size: 20,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Icon(
                              Icons.attach_money,
                              color: income? Colors.green :Colors.red,
                              size: 20,
                            ),
                          ),
                          spacerW(2),
                          Flexible(
                              child: Text(
                                "1,000777433.00",
                                style: AppStyles.headingPrimary(
                                    context: context,
                                    fontSize: 18,
                                  color: income? Colors.green :Colors.red),
                              )),
                        ],
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("12/10/2023",
                              style: AppStyles.descriptionPrimary(
                                  context: context, fontSize: 14)),
                          spacerH(5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit,
                                color: theme.primary,
                                size: 25,
                              ),
                              spacerW(10),
                              Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 25,
                              ),
                            ],
                          )

                        ],
                      )
                  );
                },
              itemCount: 20,),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          showModalBottomSheet(context: context, builder: (context){
            return Column(
              children:[
                spacerH(10),
                Text("Add Income",style: AppStyles.headingPrimary(context: context,fontSize: 20),),
                spacerH(10),
                ReusableTextField(controller: TextEditingController(), hintText: "Enter Amount"),
              ],
            );
          });
        },
        backgroundColor: theme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ReusableOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ReusableOutlinedButton(
      {super.key, this.text = "View all >>", required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
            color: theme.surface,
            border: Border.all(color: theme.onSurface, width: 0.8),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          text,
          style: AppStyles.descriptionPrimary(context: context, fontSize: 14),
        ),
      ),
    );
  }
}

class ReusableCardDetails extends StatelessWidget {
  final String text;
  final IconData icon;
  final IconData currencySymbol;
  final String amount;

  const ReusableCardDetails(
      {super.key,
      required this.text,
      required this.icon,
      required this.currencySymbol,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            spacerW(5),
            Text(
              text,
              style: AppStyles.descriptionPrimary(
                  context: context, fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        spacerH(5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Icon(
                currencySymbol,
                color: Colors.white,
                size: 20,
              ),
            ),
            spacerW(2),
            Flexible(
                child: Text(
              amount,
              style: AppStyles.headingPrimary(
                  context: context, fontSize: 18, color: Colors.white),
            )),
          ],
        ),
      ],
    );
  }
}
