part of 'discover_bloc.dart';

abstract class DiscoverEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DiscoverUpdatedEvent extends DiscoverEvent {
  final List<Product> products;
  final String category;
  final String productType;

  DiscoverUpdatedEvent({this.products, this.category, this.productType});

  @override
  List<Object> get props => [products, category, productType];
}

class LoadingDiscoverEvent extends DiscoverEvent {
  final Object category;
  final String productType;

  LoadingDiscoverEvent({this.category, this.productType});

  @override
  List<Object> get props => [category, productType];
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
