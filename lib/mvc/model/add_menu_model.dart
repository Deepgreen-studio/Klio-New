import 'dart:convert';

AddMenuModel addMenuModelFromJson(String str) => AddMenuModel.fromJson(json.decode(str));

class AddMenuModel {
  AddMenuModel({
    required this.categories,
    required this.mealPeriods,
    required this.addons,
    required this.allergies,
    required this.ingredients,
  });
  late final List<Categories> categories;
  late final List<MealPeriods> mealPeriods;
  late final List<Addons> addons;
  late final List<Allergies> allergies;
  late final List<Ingredients> ingredients;

  AddMenuModel.fromJson(Map<String, dynamic> json){
    categories = List.from(json['categories']).map((e)=>Categories.fromJson(e)).toList();
    mealPeriods = List.from(json['meal_periods']).map((e)=>MealPeriods.fromJson(e)).toList();
    addons = List.from(json['addons']).map((e)=>Addons.fromJson(e)).toList();
    allergies = List.from(json['allergies']).map((e)=>Allergies.fromJson(e)).toList();
    ingredients = List.from(json['ingredients']).map((e)=>Ingredients.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categories'] = categories.map((e)=>e.toJson()).toList();
    _data['meal_periods'] = mealPeriods.map((e)=>e.toJson()).toList();
    _data['addons'] = addons.map((e)=>e.toJson()).toList();
    _data['allergies'] = allergies.map((e)=>e.toJson()).toList();
    _data['ingredients'] = ingredients.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Categories {
  Categories({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Categories.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class MealPeriods {
  MealPeriods({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  MealPeriods.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Addons {
  Addons({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Addons.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Allergies {
  Allergies({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Allergies.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Ingredients {
  Ingredients({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Ingredients.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}