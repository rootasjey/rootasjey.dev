import 'dart:ui';

import 'package:glutton/glutton.dart';
import 'package:rootasjey/globals/constants/storage_keys.dart';
import 'package:rootasjey/types/credentials.dart';
import 'package:rootasjey/types/enums/enum_language_selection.dart';

class Vault {
  Future<bool> clearCredentials() {
    return Future.wait([
      Glutton.digest(StorageKeys.username),
      Glutton.digest(StorageKeys.email),
      Glutton.digest(StorageKeys.password),
      Glutton.digest(StorageKeys.userUid),
    ]).then((value) => value.every((bool success) => success));
  }

  Future<Credentials> getCredentials() async {
    String email = "";
    String password = "";

    if (await Glutton.have(StorageKeys.email)) {
      email = await Glutton.vomit(StorageKeys.email);
    }

    if (await Glutton.have(StorageKeys.password)) {
      password = await Glutton.vomit(StorageKeys.password);
    }

    return Credentials(
      email: email,
      password: password,
    );
  }

  void setCredentials({
    required String email,
    required String password,
  }) async {
    await Future.wait([
      Glutton.eat(StorageKeys.email, email),
      Glutton.eat(StorageKeys.password, password),
    ]);
  }

  void setPassword(String password) async {
    await Glutton.eat(StorageKeys.password, password);
  }

  Future<bool> getHeroImageControlsVisible() async {
    return await Glutton.vomit(StorageKeys.heroImageControlVivisible, true);
  }

  void setHeroImageControlsVisible(bool newValue) {
    Glutton.eat(StorageKeys.heroImageControlVivisible, newValue);
  }

  /// Return the last saved value for app language.
  /// Retrieve the index of EnumLanguageSelection and return enum value.
  Future<EnumLanguageSelection> getLanguage() async {
    final int index = await Glutton.vomit(StorageKeys.language, 0);
    return EnumLanguageSelection.values[index];
  }

  /// Saves the app language.
  /// Use index of EnumLanguageSelection.
  void setLanguage(EnumLanguageSelection locale) {
    Glutton.eat(StorageKeys.language, locale.index);
  }

  void setBrightness(Brightness brightness) {
    Glutton.eat(StorageKeys.brightness, brightness.index);
  }

  Future<Brightness> getBrightness() async {
    final int index = await Glutton.vomit(
      StorageKeys.brightness,
      Brightness.light.index,
    );

    return Brightness.values[index];
  }
}
