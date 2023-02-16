import 'dart:convert';

class GetLinkResponse {
  final String id;
  final String name;
  final String link;
  final String path;
  final String type;
  final String size;

  GetLinkResponse({
    required this.id,
    required this.name,
    required this.link,
    required this.path,
    required this.size,
    required this.type,
  });

  factory GetLinkResponse.fromJson(Map<String, dynamic> json) {
    String name = (json['name'] as String);
    String type = name.substring(name.lastIndexOf("."));
    print(type);
    return GetLinkResponse(
      id: json['id'],
      name: name,
      link: json['link'],
      path: json['path'],
      size: json['size'],
      type: type,
    );
  }

  GetLinkResponse clone() {
    return GetLinkResponse(
      id: id,
      name: name,
      link: link,
      path: path,
      size: size,
      type: type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'link': link,
      'path': path,
      'size': size,
      'type': type,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
