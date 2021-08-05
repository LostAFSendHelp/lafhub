import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageExpected {
  bool? getBool({required String key});
  String? getString({required String key});
  int? getInt({required String key});
  double? getDouble({required String key});

  Future<bool> setString(String value, {required String key});
  Future<bool> remove({required String key});
}

class LocalStorageMock implements LocalStorageExpected {
  final bool? _bool;
  final String? _string;
  final int? _int;
  final double? _double;
  final bool _returnError;

  const LocalStorageMock({
    bool? boolVal,
    String? stringVal,
    int? intVal,
    double? doubleVal,
    required bool returnError,
  })  : _bool = boolVal,
        _string = stringVal,
        _int = intVal,
        _double = doubleVal,
        _returnError = returnError;

  @override
  bool? getBool({required String key}) {
    return _bool;
  }

  @override
  double? getDouble({required String key}) {
    return _double;
  }

  @override
  int? getInt({required String key}) {
    return _int;
  }

  @override
  String? getString({required String key}) {
    return _string;
  }

  @override
  Future<bool> setString(String value, {required String key}) async {
    return !_returnError;
  }

  @override
  Future<bool> remove({required String key}) async {
    return !_returnError;
  }
}

class LocalStorage implements LocalStorageExpected {
  final _pref = Get.find<SharedPreferences>();

  @override
  bool? getBool({required String key}) {
    return _pref.getBool(key);
  }

  @override
  double? getDouble({required String key}) {
    return _pref.getDouble(key);
  }

  @override
  int? getInt({required String key}) {
    return _pref.getInt(key);
  }

  @override
  String? getString({required String key}) {
    return _pref.getString(key);
  }

  @override
  Future<bool> setString(String value, {required String key}) {
    return _pref.setString(key, value);
  }

  @override
  Future<bool> remove({required String key}) {
    return _pref.remove(key);
  }
}
