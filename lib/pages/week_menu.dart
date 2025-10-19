import 'package:azadel_daily/pages/list_course.dart';
import 'package:azadel_daily/providers/menu_provider.dart';
import 'package:azadel_daily/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekMenu extends StatefulWidget {
  const WeekMenu({super.key});

  @override
  State<WeekMenu> createState() => _WeekMenuState();
}

class _WeekMenuState extends State<WeekMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Repas de la semaine")),
      body: Consumer<MenuProvider>(
        builder: (context, menuP, child) {
          return Column(
            spacing: 15,
            
            children: [
                    ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TopicListScreen()),
                  );
                },
                child:Text("Ajouter des courses"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText.center(
                              "${menuP.extractPartMenu("jour")[index]} :",
                              Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: 5),
                            CustomText.center(
                              "Midi : ${menuP.extractPartMenu("midi")[index]}",
                              Theme.of(context).textTheme.bodyLarge,
                            ),
                            CustomText.center(
                              "Soir : ${menuP.extractPartMenu("soir")[index]}",
                              Theme.of(context).textTheme.bodyLarge,
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
      ),
    );
  }
}
