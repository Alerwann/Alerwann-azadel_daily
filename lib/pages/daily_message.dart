import 'package:azadel_daily/models/menu_model.dart';
import 'package:azadel_daily/providers/menu_provider.dart';
import 'package:azadel_daily/utilis/change_color.dart';
import 'package:azadel_daily/widget/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather_package/bloc/weather_bloc.dart';
import 'package:weather_package/bloc/weather_state.dart';

class DailyMessage extends StatefulWidget {
  const DailyMessage({super.key});

  @override
  State<DailyMessage> createState() => _DailyMessageState();
}

class _DailyMessageState extends State<DailyMessage> {
  late TextStyle? bodyL = Theme.of(context).textTheme.bodyLarge;
  late TextStyle? headM = Theme.of(context).textTheme.headlineMedium;
  late TextStyle? headL = Theme.of(context).textTheme.headlineLarge;
  late TextStyle? headS = Theme.of(context).textTheme.headlineSmall;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('appState')
          .doc('hearts')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        String selectedColor = snapshot.data!.get('selectedColor');
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text("Coucou bébé ", style: headL),
                Icon(Icons.favorite, size: 50, color: getColor(selectedColor)),
              ],
            ),
          ),
          body: Consumer<MenuProvider>(
            builder: (context, menuP, child) {
              MenuDuJour? menuDuJour = menuP.menuPourAujourdhui();
              if (menuDuJour == null) {
                return Center(child: Text("Aucun menu pour aujourd'hui"));
              }

              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 15,
                    children: [
                      SizedBox(height: 10),
                      _listMessage("🥰 On est : ", menuDuJour.jour, headM),
                      BlocBuilder<WeatherBloc, WeatherState>(
                        builder: (context, state) {
                          if (state is WeatherLoaded) {
                            // C'est ici que tu affiches ta météo (ex: dans un _listMessage)
                            return _listMessage(
                              "Météo du jour ☀️",
                              "${state.weather.temperature}°C - ${state.weather.sunny}",
                              headM,
                            );
                          }
                          // Pour Loading, Initial, Error... on n'affiche rien (ou un petit truc discret)
                          return SizedBox.shrink();
                        },
                      ),
                      _listMessage(
                        "À midi on mange 🍛 ",
                        menuDuJour.menuMidi,
                        headM,
                      ),
                      _listMessage(
                        "Ce soir on mange 🧆 ",
                        menuDuJour.menuSoir,
                        headM,
                      ),
                      menuDuJour.rendezVousAzadel != ""
                          ? _listMessage(
                              "Tu dois faire   ",
                              menuDuJour.rendezVousAzadel,
                              headM,
                            )
                          : _listMessage(
                              "Tu dois faire   ",
                              "Rien à faire et tant mieux",
                              headM,
                            ),

                      menuDuJour.rendezVousAlerwann != ""
                          ? _listMessage(
                              "Je dois faire  ",
                              menuDuJour.rendezVousAlerwann,
                              headS,
                            )
                          : _listMessage(
                              "Je dois faire   ",
                              "Rien à faire et tant mieux",
                              headS,
                            ),
                      SizedBox(height: 10),

                      _listMessage(
                        "Et surtout n'oublie pas   ",
                        menuDuJour.messageDoux,
                        headL,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Bouton rouge
                          IconButton(
                            icon: Icon(Icons.favorite, size: 50),
                            color: Colors.red,
                            onPressed: () {
                              changeColor('red');
                            },
                          ),
                          // Bouton bleu
                          IconButton(
                            icon: Icon(Icons.favorite, size: 50),
                            color: Colors.blue,
                            onPressed: () {
                              changeColor('blue');
                            },
                          ),
                          // Bouton vert
                          IconButton(
                            icon: Icon(Icons.favorite, size: 50),
                            color: Colors.green,
                            onPressed: () {
                              changeColor('green');
                            },
                          ),
                          // Bouton jaune
                          IconButton(
                            icon: Icon(Icons.favorite, size: 50),
                            color: Colors.yellow,
                            onPressed: () {
                              changeColor('yellow');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Container _listMessage(String messageT, String importT, TextStyle? styleI) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        spacing: 3,
        children: [
          CustomText.center(messageT, bodyL),
          CustomText.center(importT, styleI),
        ],
      ),
    );
  }
}
