part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {}

class CategoryLoadFinished extends CategoryState {
  final bool isSuccess;
  final List<SysCategory> categories;
  // final List<SysCategory> cateChild;

  CategoryLoadFinished(
      {this.categories = const [],
      // this.cateChild = const [],
      this.isSuccess = false});

  @override
  List<Object> get props => [categories.hashCode, isSuccess];

  @override
  String toString() {
    return 'CategoryLoadFinished{categories: $categories}';
  }
}

class CategoryChildLoadFinished extends CategoryState {
  final bool isSuccess;
  final List<SysCategory> cateChild;
  final List<SysCategory> categories;

  CategoryChildLoadFinished(
      {this.cateChild = const [],
      this.categories = const [],
      this.isSuccess = false});

  @override
  List<Object> get props =>
      [cateChild.hashCode, categories.hashCode, isSuccess];

  @override
  String toString() {
    return 'CategoryChildLoadFinished{cateChild: $cateChild, categories: $categories}';
  }
}
