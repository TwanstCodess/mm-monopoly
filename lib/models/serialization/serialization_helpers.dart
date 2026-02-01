import 'package:flutter/material.dart';
import '../avatar.dart';

/// Serialization helpers for common types

/// Serialize an enum to its string name
String enumToJson(Enum e) => e.name;

/// Deserialize an enum from its string name
T enumFromJson<T extends Enum>(String name, List<T> values) {
  return values.firstWhere((v) => v.name == name);
}

/// Serialize a Color to JSON
Map<String, dynamic> colorToJson(Color color) {
  return {'value': color.toARGB32()};
}

/// Deserialize a Color from JSON
Color colorFromJson(Map<String, dynamic> json) {
  return Color(json['value'] as int);
}

/// Serialize an Avatar to JSON (nullable)
Map<String, dynamic>? avatarToJson(Avatar? avatar) {
  if (avatar == null) return null;
  return {
    'id': avatar.id,
    'category': enumToJson(avatar.category),
    'emoji': avatar.emoji,
    'name': avatar.name,
    'primaryColor': colorToJson(avatar.primaryColor),
    'secondaryColor': colorToJson(avatar.secondaryColor),
    'iconData': avatar.iconData.codePoint,
    'customImagePath': avatar.customImagePath,
  };
}

/// Deserialize an Avatar from JSON (nullable)
Avatar? avatarFromJson(Map<String, dynamic>? json) {
  if (json == null) return null;
  return Avatar(
    id: json['id'] as String,
    category: enumFromJson(json['category'] as String, AvatarCategory.values),
    emoji: json['emoji'] as String,
    name: json['name'] as String,
    primaryColor: colorFromJson(json['primaryColor'] as Map<String, dynamic>),
    secondaryColor: colorFromJson(json['secondaryColor'] as Map<String, dynamic>),
    iconData: IconData(json['iconData'] as int, fontFamily: 'MaterialIcons'),
    customImagePath: json['customImagePath'] as String?,
  );
}
