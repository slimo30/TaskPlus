// lib/bloc/category/category_state.dart

import 'package:taskplus/Model/Category.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoadInProgress extends CategoryState {}

class CategoryLoadSuccess extends CategoryState {
  final List<Category> categories;

  CategoryLoadSuccess(this.categories);
}

class CategoryOperationFailure extends CategoryState {
  final String error;

  CategoryOperationFailure(this.error);
}
