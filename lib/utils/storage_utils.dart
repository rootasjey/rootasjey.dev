import 'package:glutton/glutton.dart';
import 'package:rootasjey/types/credentials.dart';
import 'package:rootasjey/globals/constants/storage_keys.dart';

class StorageUtils {
  static Future<bool> clearCredentials() {
    return Future.wait([
      Glutton.digest(StorageKeys.username),
      Glutton.digest(StorageKeys.email),
      Glutton.digest(StorageKeys.password),
      Glutton.digest(StorageKeys.userUid),
    ]).then((value) => value.every((bool success) => success));
  }

  static Future<Credentials> getCredentials() async {
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

  static void setCredentials({
    required String email,
    required String password,
  }) async {
    await Future.wait([
      Glutton.eat(StorageKeys.email, email),
      Glutton.eat(StorageKeys.password, password),
    ]);
  }

  static void setPassword(String password) async {
    await Glutton.eat(StorageKeys.password, password);
  }

  static Future<bool> getHeroImageControlsVisible() async {
    return await Glutton.vomit(StorageKeys.heroImageControlVivisible, true);
  }

  static void setHeroImageControlsVisible(bool newValue) {
    Glutton.eat(StorageKeys.heroImageControlVivisible, newValue);
  }
}
