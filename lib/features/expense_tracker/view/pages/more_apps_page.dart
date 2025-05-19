import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../shared/view/widgets/containers/reusable_stylish_container.dart';
import '../../../../shared/view/widgets/global_widgets.dart';
import '../../../../shared/view/widgets/reusable_app_bar.dart';
import '../../../../shared/view/widgets/text_view/reusable_text_field.dart';
import '../../viewmodel/riverpod/more_apps_notifier.dart';

class MoreAppsPage extends ConsumerStatefulWidget {
  const MoreAppsPage({super.key});

  @override
  ConsumerState<MoreAppsPage> createState() => _MoreAppsPageState();
}

class _MoreAppsPageState extends ConsumerState<MoreAppsPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    final rProvider = ref.read(moreAppsProvider.notifier);
    final uProvider = ref.watch(moreAppsProvider);
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: ReusableAppBar(
        text: 'More Apps',
        isCenterText: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            spacerH(),
            ReusableTextField(
              controller: searchController,
              hintText: 'Search by App Name',
              onChanged: (value) {
                rProvider.filterApps(value);
              },
            ),
            spacerH(10),
            uProvider.isEmpty
                ? SizedBox(
                    width: w,
                    height: h - 200,
                    child: Center(
                        child: Text(
                      'No apps found',
                      style: AppStyles.descriptionPrimary(
                          context: context, color: theme.onSurface),
                    )))
                : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10, bottom: 80),
                      itemCount: uProvider.length,
                      itemBuilder: (context, index) {
                        final e = uProvider[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ReusableStylishContainer(
                            // h: 350,
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
                  ),
          ],
        ),
      ),
    );
  }
}
