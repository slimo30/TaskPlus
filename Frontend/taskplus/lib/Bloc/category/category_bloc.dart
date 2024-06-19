// lib/bloc/category/category_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskplus/Controller/category_repo.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoadInProgress());
    try {
      final categories = await categoryRepository.fetchCategories();
      emit(CategoryLoadSuccess(categories));
    } catch (e) {
      emit(CategoryOperationFailure(e.toString()));
    }
  }

  Future<void> _onAddCategory(
      AddCategory event, Emitter<CategoryState> emit) async {
    try {
      await categoryRepository.addCategory(event.category);
      final categories = await categoryRepository.fetchCategories();
      emit(CategoryLoadSuccess(categories));
    } catch (e) {
      emit(CategoryOperationFailure(e.toString()));
    }
  }
}
