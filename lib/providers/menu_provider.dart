import 'package:azadel_daily/models/menu_model.dart';
import 'package:azadel_daily/service/csv_extract_service.dart';
import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  final MenuService _menuService = MenuService();

  List<MenuDuJour> get menus => _menuService.menus;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> chargerMenus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final succes = await _menuService.chargerMenus();

    _isLoading = false;
    if (!succes) {
      _errorMessage = 'Erreur de chargement des menus';
    }
    notifyListeners();
  }

  MenuDuJour? menuPourAujourdhui() {
    return _menuService.menuPourAujourdhui();
  }

  List extractPartMenu(String extractT) {
    return _menuService.extractPartMenu(extractT);
  }


}
