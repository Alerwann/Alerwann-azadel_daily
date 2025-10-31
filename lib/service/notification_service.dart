import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    print('🔔 Début initialisation notifications...');

    // Demander la permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('✅ Permission: ${settings.authorizationStatus}');
    print('📱 Alert: ${settings.alert}');
    print('🔔 Sound: ${settings.sound}');
    print('🔴 Badge: ${settings.badge}');

    // Attendre un peu
    // print('⏳ Attente de 5 secondes...');
    // await Future.delayed(Duration(seconds: 2));

    // Vérifier le token APNS
    print('🍎 Vérification token APNS...');
    String? apnsToken = await _messaging.getAPNSToken();
    print('🍎 Token APNS: ${apnsToken ?? "NULL"}');

    // Si on a le token APNS, on peut récupérer le FCM
    if (apnsToken != null) {
      print('✅ Token APNS OK, récupération FCM...');
      String? fcmToken = await _messaging.getToken();
      print('🔥 Token FCM: $fcmToken');

      if (fcmToken != null) {
        await saveTokenToFirestore(fcmToken);
      }
    } else {
      print('❌ Token APNS toujours NULL après 5 secondes');
      print('📝 Configuration iOS probablement incomplète');
    }
  }

  Future<void> saveTokenToFirestore(String token) async {
    try {
      await FirebaseFirestore.instance
          .collection('deviceTokens')
          .doc(token)
          .set({'token': token, 'lastUpdated': FieldValue.serverTimestamp()});

      print('✅ Token sauvegardé dans Firestore !');
    } catch (e) {
      print('❌ Erreur sauvegarde: $e');
    }
  }
}
