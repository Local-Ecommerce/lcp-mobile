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
