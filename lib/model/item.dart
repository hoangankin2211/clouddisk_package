import 'package:flutter/material.dart';

class Item {
  final String id;
  final String name;
  final double size;
  final String type;
  final DateTime createDate;
  final IconData icon;
  final Color? color;
  Item(
      {required this.id,
      required this.name,
      required this.size,
      required this.createDate,
      required this.icon,
      required this.type,
      this.color});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'] ?? json["text"],
      size: json['size'] == null ? 0.0 : double.parse(json['size'] as String),
      createDate: json['regdate'] != null
          ? DateTime.now()
              .subtract(Duration(milliseconds: int.parse(json['regdate'])))
          : DateTime.now(),
      icon: json['type'] == null || json['type'] == "dir"
          ? Icons.folder
          : Icons.file_copy_outlined,
      type: json["type"] ?? "dir",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "size": size,
      "createDate": createDate,
      "type": type,
    };
  }
}
