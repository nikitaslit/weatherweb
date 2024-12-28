// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CityModel {
  final String id;
  final String name;
  final String userId;
  CityModel({
    this.id = '',
    this.userId = '',
    required this.name,
  });

  CityModel copyWith({
    String? id,
    String? name,
    String? userId,
  }) {
    return CityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'userId': userId,
    };
  }

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id'] as String,
      name: map['name'] as String,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CityModel.fromJson(String source) => CityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CityModel(id: $id, name: $name, userId: $userId)';

  @override
  bool operator ==(covariant CityModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.userId == userId;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ userId.hashCode;
}
