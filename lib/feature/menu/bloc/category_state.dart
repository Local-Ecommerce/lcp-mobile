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

  CategoryLoadFinished({this.categories = const [], this.isSuccess = false});

  @override
  List<Object> get props => [categories.hashCode, isSuccess];

  @override
  String toString() {
    return 'CategoryLoadFinished{categories: $categories}';
  }
}
