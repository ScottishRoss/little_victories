import 'package:flutter/material.dart';

class VictoryIcon {
  VictoryIcon({
    required this.icon,
    required this.iconName,
  });

  final IconData icon;
  final String iconName;
}

final List<VictoryIcon> victoryIconList = <VictoryIcon>[
  VictoryIcon(icon: Icons.sentiment_satisfied_alt, iconName: 'happy'),
  VictoryIcon(icon: Icons.park, iconName: 'park'),
  VictoryIcon(icon: Icons.restaurant, iconName: 'restaurant'),
  VictoryIcon(icon: Icons.groups, iconName: 'groups'),
  VictoryIcon(icon: Icons.fitness_center, iconName: 'fitness'),
  VictoryIcon(icon: Icons.favorite, iconName: 'favorite'),
];

IconData getIconData(String icon) {
  try {
    return victoryIconList.firstWhere((VictoryIcon victoryIcon) {
      return victoryIcon.iconName == icon;
    }).icon;
  } catch (e) {
    return Icons.sentiment_satisfied_alt;
  }
}
