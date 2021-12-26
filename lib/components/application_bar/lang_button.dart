import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/lang_popup_menu_button.dart';

class LangButton extends StatelessWidget {
  const LangButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LangPopupMenuButton(
      onLangChanged: (newLang) async {
        await context.setLocale(Locale(newLang));
      },
      lang: context.locale.languageCode,
    );
  }
}
