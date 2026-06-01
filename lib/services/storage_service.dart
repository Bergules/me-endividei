import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/caso_model.dart';

class StorageService {
  static const _key = 'meus_casos';

  static Future<void> salvarCaso(CasoModel caso) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = await carregarCasos();
    lista.insert(0, caso);
    // Manter apenas os 20 mais recentes
    if (lista.length > 20) lista.removeRange(20, lista.length);
    final json = lista.map((c) => c.toJson()).toList();
    await prefs.setString(_key, jsonEncode(json));
  }

  static Future<List<CasoModel>> carregarCasos() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key);
    if (str == null) return [];
    final lista = jsonDecode(str) as List;
    return lista.map((j) => CasoModel.fromJson(j)).toList();
  }

  static Future<void> limparCasos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
