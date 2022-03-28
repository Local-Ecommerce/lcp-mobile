part of 'discover_bloc.dart';

abstract class DiscoverEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DiscoverUpdatedEvent extends DiscoverEvent {
  final List<Menu> menus;
  final List<Product> products;
  final List<SysCategory> categories;
  // final String category;
  final String productType;

  DiscoverUpdatedEvent(
      {this.menus, this.products, this.categories, this.productType});

  @override
  List<Object> get props => [products, categories, productType];
}

class LoadingDiscoverEvent extends DiscoverEvent {
  final Object category;
  final String productType;
  final String apartmentId;

  LoadingDiscoverEvent({this.category, this.productType, this.apartmentId});

  @override
  List<Object> get props => [category, productType, apartmentId];
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
