import 'package:azadel_daily/providers/menu_provider.dart';
import 'package:azadel_daily/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RdvallWidget extends StatefulWidget {
  final String nameRdv;
  const RdvallWidget({super.key, required this.nameRdv});

  @override
  State<RdvallWidget> createState() => _RdvallWidgetState();
}

class _RdvallWidgetState extends State<RdvallWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, menuP, child) {
        print(widget.nameRdv);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.nameRdv == "rdvAzadel"
                ? CustomText.center(
                    "Tes rendez-vous",
                    Theme.of(context).textTheme.headlineLarge,
                  )
                : CustomText.center(
                    "Rendez vous de ton bébé",
                    Theme.of(context).textTheme.headlineLarge,
                  ),
            SizedBox(height: 30),
            SizedBox(
              height: 600,
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        spacing: 10,
                        children: [
                          CustomText.center(
                            "${menuP.extractPartMenu("jour")[index]} :",
                            Theme.of(context).textTheme.headlineMedium,
                          ),

                          menuP.extractPartMenu(widget.nameRdv)[index] != ""
                              ? CustomText.center(
                                  menuP.extractPartMenu(widget.nameRdv)[index],
                                  Theme.of(context).textTheme.bodyLarge,
                                )
                              : CustomText.center(
                                  "Pas de rendez-vous et tant mieux",
                                  Theme.of(context).textTheme.bodyMedium,
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
