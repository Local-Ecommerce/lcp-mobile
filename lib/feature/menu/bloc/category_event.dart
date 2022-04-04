part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryUpdatedEvent extends CategoryEvent {
  final List<SysCategory> categories;

  CategoryUpdatedEvent({this.categories});

  @override
  List<Object> get props => [categories];
}

class LoadingCategoryEvent extends CategoryEvent {
  final List<SysCategory> categories;

  LoadingCategoryEvent({this.categories});

  @override
  List<Object> get props => [categories];
}

class LoadingCategoryChildEvent extends CategoryEvent {
  final List<SysCategory> cateChild;
  final List<SysCategory> categories;
  final String category;

  LoadingCategoryChildEvent({this.cateChild, this.categories, this.category});

  @override
  List<Object> get props => [cateChild, categories];
}

class CategoryChildUpdatedEvent extends CategoryEvent {
  final List<SysCategory> categories;
  final List<SysCategory> cateChild;

  CategoryChildUpdatedEvent({this.categories, this.cateChild});

  @override
  List<Object> get props => [categories, cateChild];
}
