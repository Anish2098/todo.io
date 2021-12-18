
import 'dart:convert';

TodoModel clientFromJson(String str) {
  final jsonData = json.decode(str);
  return TodoModel.fromMap(jsonData);
}

String clientToJson(TodoModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class TodoModel {
  int? age;
  String? first_name;
  String? last_name;
  String? occupation;

  TodoModel({
    this.age,
    this.first_name,
    this.last_name,
    this.occupation
  });

  factory TodoModel.fromMap(Map<String, dynamic> json) => new TodoModel(
    age: json["age"],
    first_name: json["first_name"],
    last_name: json["last_name"],
    occupation: json["occupation"]
  );

  Map<String, dynamic> toMap() => {
    "age": age,
    "first_name": first_name,
    "last_name": last_name,
    "occupation": occupation
  };
}