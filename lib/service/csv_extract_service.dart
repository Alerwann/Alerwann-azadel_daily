import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_model.dart';

class MenuService {
  static const String _csvURL =
      "https://gist.github.com/Alerwann/c66af773df21c4a1029858906ee8eacb/raw/menu.csv";

  final List<MenuDuJour> _menus = [];
  List<MenuDuJour> get menus => _menus;

  Future<bool> chargerMenus() async {
    try {
      // Ajouter un timestamp pour éviter le cache
      final url = Uri.parse(
        '$_csvURL?t=${DateTime.now().millisecondsSinceEpoch}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final csvString = utf8.decode(response.bodyBytes);
        return _traiterCSV(csvString);
      } else {
        print('Erreur HTTP: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur de chargement: $e');
      return false;
    }
  }

  bool _traiterCSV(String csvString) {
    final lignes = csvString.split('\n');
    _menus.clear();

    for (int i = 0; i < lignes.length; i++) {
      final ligne = lignes[i].trim();
      if (ligne.isEmpty) continue;

      final colonnes = ligne.split(';');

      if (i == 0 || colonnes.length < 6) continue;

      final menu = MenuDuJour(
        jour: colonnes[0],
        menuMidi: colonnes[1],
        menuSoir: colonnes[2],
        rendezVousAzadel: colonnes[3],
        rendezVousAlerwann: colonnes[4],
        messageDoux: colonnes[5],
      );

      _menus.add(menu);
    }

    return true;
  }

  MenuDuJour? menuPourAujourdhui() {
    final maintenant = DateTime.now();

    // Utiliser weekday au lieu de DateFormat
    final joursSemaine = [
      'lundi',
      'mardi',
      'mercredi',
      'jeudi',
      'vendredi',
      'samedi',
      'dimanche',
    ];

    final jourActuel = joursSemaine[maintenant.weekday - 1];

    for (final menu in _menus) {
      if (menu.jour.toLowerCase().contains(jourActuel)) {
        return menu;
      }
    }
    return null;
  }

  List extractPartMenu(String typeToExtract) {
    List<String> listToExtract = [];
    switch (typeToExtract) {
      case "rdvAzadel":
        for (final menu in _menus) {
          listToExtract.add(menu.rendezVousAzadel);
        }
        break;
      case "rdvAlerwann":
        for (final menu in _menus) {
          listToExtract.add(menu.rendezVousAlerwann);
        }
        break;
      case "jour":
        for (final menu in _menus) {
          listToExtract.add(menu.jour);
        }
        break;
           case "midi":
        for (final menu in _menus) {
          listToExtract.add(menu.menuMidi);
        }
        break;
           case "soir":
        for (final menu in _menus) {
          listToExtract.add(menu.menuSoir);
        }
        break;
    }

    return listToExtract;
  }
}
