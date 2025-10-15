import 'package:azadel_daily/providers/menu_provider.dart';
import 'package:azadel_daily/widget/rdvAll_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeetingAzadel extends StatefulWidget {
  const MeetingAzadel({super.key});

  @override
  State<MeetingAzadel> createState() => _MeetingAzadelState();
}

class _MeetingAzadelState extends State<MeetingAzadel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<MenuProvider>(
        builder: (context, menuP, child) {
          return Center(child: Column(
            children: [
              RdvallWidget(nameRdv: "rdvAzadel",)
            ],
          ));
        },
      ),
    );
  }
}
