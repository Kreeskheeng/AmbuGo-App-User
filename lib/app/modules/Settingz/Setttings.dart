import 'package:easy_settings/easy_settings.dart';
import 'package:flutter/material.dart';

List<SettingsCategory> settingsCategories = [
  SettingsCategory(
      title: "Category 1",
      iconData: Icons.settings,
      settingsSections: [
        SettingsSection(settingsElements: [
          StringSettingsProperty(
              key: "str",
              title: "This is a String settings",
              defaultValue: "Test",
              iconData: Icons.text_fields),
          IntSettingsProperty(
              key: "integer",
              title: "This is an int settings",
              defaultValue: 3,
              iconData: Icons.numbers),
          DoubleSettingsProperty(
              key: "double",
              title: "This is a double settings",
              defaultValue: 3.14,
              iconData: Icons.double_arrow),
          BoolSettingsProperty(
              key: "isDarkKey",
              title: "Dark Theme",
              subtitle: "Do you want to use dark theme ?",
              defaultValue: false,
              iconData: Icons.dark_mode),
          EnumSettingsProperty(
              key: "language",
              title: "Language",
              subtitle: "This is an enum settings",
              defaultValue: 0,
              iconData: Icons.language,
              choices: ["English", "Espanol", "Français"]),
          ButtonSettingsElement(
              title: "Quick reset settings",
              subtitle: "I don't ask for confirmation.",
              iconData: Icons.restore,
              onClick: (BuildContext context) => resetSettings())
        ])
      ])
];



class Settingz extends StatelessWidget {
  const Settingz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: const EasySettingsWidget());
  }
}