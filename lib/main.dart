import 'package:azadel_daily/bloc/weather_bloc.dart';
import 'package:azadel_daily/bloc/weather_event.dart';
import 'package:azadel_daily/data/weather_repository.dart';
import 'package:azadel_daily/firebase_options.dart';
import 'package:azadel_daily/models/menu_model.dart';
import 'package:azadel_daily/pages/daily_message.dart';
import 'package:azadel_daily/pages/list_course.dart';

import 'package:azadel_daily/pages/meeting_alerwann.dart';
import 'package:azadel_daily/pages/meeting_azadel.dart';
import 'package:azadel_daily/pages/week_menu.dart';
import 'package:azadel_daily/providers/menu_provider.dart';
import 'package:azadel_daily/theme/app-theme.dart';
import 'package:azadel_daily/utilis/change_color.dart';
import 'package:azadel_daily/widget/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  NotificationService notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        BlocProvider(
          create: (context) =>
              WeatherBloc(WeatherRepository())..add(GetWeatherByGps())),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<MenuProvider>(context, listen: false).chargerMenus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bébé Info',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const DailyMessageAzadel(),
    );
  }
}

class DailyMessageAzadel extends StatefulWidget {
  const DailyMessageAzadel({super.key});

  @override
  State<DailyMessageAzadel> createState() => _DailyMessageAzadelState();
}

class _DailyMessageAzadelState extends State<DailyMessageAzadel> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
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
            title: Text('❤️ 😈 ❤️', style: TextStyle(fontSize: 40)),
          ),
          body: Consumer<MenuProvider>(
            builder: (context, menuP, child) {
              MenuDuJour? menuDuJour = menuP.menuPourAujourdhui();
              if (menuDuJour == null) {
                return Center(child: Text("Aucun menu pour aujourd'hui"));
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 30,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 30),
                        child: CustomText.center(
                          " Coucou mon coeur ",
                          Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DailyMessage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Message du jour"),
                            SizedBox(width: 15),
                            Icon(
                              Icons.favorite,
                              size: 50,
                              color: getColor(selectedColor),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeetingAzadel(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Rendez-vous de la semaine de bébé d'amour",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (menuDuJour.rendezVousAzadel != "")
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.notification_important_rounded,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RdvAlerwann(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Rendez-vous de la semaine de bébé d'ange",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (menuDuJour.rendezVousAlerwann != "")
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.notification_important_rounded,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WeekMenu()),
                          );
                        },
                        child: Text("Menu de la semaine"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopicListScreen(),
                            ),
                          );
                        },
                        child: Text("Ajouter des courses"),
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
}
