import 'package:flutter/foundation.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/shop_type.dart';
import '../../domain/usecases/get_shop_type.dart';
import '../../domain/usecases/save_shop_type.dart';

/// Estado da configuração inicial (qual tipo de oficina o usuário rodou
/// o app sob).
///
/// `current` é a fonte da verdade pro app inteiro depois do setup —
/// outros providers leem ele via `read<SetupProvider>().current`.
class SetupProvider extends ChangeNotifier {
  final GetShopType _get;
  final SaveShopType _save;

  ShopType? _current;
  bool _loading = false;
  String? _error;

  SetupProvider(this._get, this._save);

  ShopType? get current => _current;
  bool get loading => _loading;
  String? get error => _error;
  bool get isConfigured => _current != null;

  Future<void> bootstrap() async {
    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _get(const NoParams());
    result.fold(
      onSuccess: (shop) {
        _current = shop;
      },
      onFailure: (f) {
        _error = f.message;
      },
    );

    _loading = false;
    notifyListeners();
  }

  Future<bool> pick(ShopType type) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _save(type);
    final ok = result.fold(
      onSuccess: (_) {
        _current = type;
        return true;
      },
      onFailure: (f) {
        _error = f.message;
        return false;
      },
    );

    _loading = false;
    notifyListeners();
    return ok;
  }
}
