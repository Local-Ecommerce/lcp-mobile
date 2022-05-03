part of 'discover_bloc.dart';

abstract class DiscoverEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DiscoverUpdatedEvent extends DiscoverEvent {
  final List<Product> products;
  final List<dynamic> lstChildCategory;
  final Object category;

  DiscoverUpdatedEvent({this.products, this.lstChildCategory, this.category});

  @override
  List<Object> get props => [products, lstChildCategory, category];
}

class LoadingDiscoverEvent extends DiscoverEvent {
  final Object category;
  final List<dynamic> lstChildCategory;
  final String productType;
  final String apartmentId;

  LoadingDiscoverEvent(
      {this.category,
      this.productType,
      this.apartmentId,
      this.lstChildCategory});

  @override
  List<Object> get props =>
      [category, productType, apartmentId, lstChildCategory];
}

class LoadingCategoryFoodEvent extends DiscoverEvent {
  final Object category;
  final List<dynamic> lstChildCategory;
  final String productType;
  final String apartmentId;

  LoadingCategoryFoodEvent(
      {this.category,
      this.productType,
      this.apartmentId,
      this.lstChildCategory});

  @override
  List<Object> get props =>
      [category, productType, apartmentId, lstChildCategory];
}

class LoadingWishlistEvent extends DiscoverEvent {}

class WishlistUpdatedEvent extends DiscoverEvent {
  final List<Product> products;

  WishlistUpdatedEvent({this.products});

  @override
  List<Object> get props => [
        products,
      ];
}
