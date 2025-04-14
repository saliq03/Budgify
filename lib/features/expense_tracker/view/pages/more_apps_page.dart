import 'package:flutter/material.dart';
import '../../../../shared/view/widgets/containers/reusable_stylish_container.dart';
import '../../../../shared/view/widgets/global_widgets.dart';
import '../../../../shared/view/widgets/reusable_app_bar.dart';
import '../../data/more_apps_contents.dart';

class MoreAppsPage extends StatefulWidget {
  const MoreAppsPage({super.key});

  @override
  State<MoreAppsPage> createState() => _MoreAppsPageState();
}

class _MoreAppsPageState extends State<MoreAppsPage> {

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: ReusableAppBar(text: 'More Apps', isCenterText: false,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              spacerH(30),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: moreAppsContentsList.length,
                      itemBuilder: (context, index) {
                        final e = moreAppsContentsList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ReusableStylishContainer(
                            h: 350,
                            w: w,
                            colors: e.colors,
                            isCarousel: false,
                            title: e.title,
                            description: e.description,
                            image: e.image,
                            onTap: () {
                              openUrl(url: e.url, context: context);
                            },
                          ),
                        );
                      },
                    ),
              spacerH(100),
            ],
          ),
        ),
      ),
    );
  }
}