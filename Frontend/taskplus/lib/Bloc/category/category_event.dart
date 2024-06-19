// lib/bloc/category/category_event.dart

import 'package:taskplus/Model/Category.dart';

abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final Category category;

  AddCategory(this.category);
}


