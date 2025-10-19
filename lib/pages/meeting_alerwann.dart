import 'package:azadel_daily/providers/menu_provider.dart';
import 'package:azadel_daily/widget/rdvAll_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RdvAlerwann extends StatefulWidget {
  const RdvAlerwann({super.key});

  @override
  State<RdvAlerwann> createState() => _RdvAlerwannState();
}

class _RdvAlerwannState extends State<RdvAlerwann> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<MenuProvider>(
        builder: (context, menuP, child) {
          return Center(child: Column(
            children: [
              RdvallWidget(nameRdv: "rdvAlerwann",)
            ],
          ));
        },
      ),
    );
  }
}