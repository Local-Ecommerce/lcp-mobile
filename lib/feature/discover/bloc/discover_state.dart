part of 'discover_bloc.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();

  @override
  List<Object> get props => [];
}

class DiscoverLoading extends DiscoverState {}

class DiscoverLoadFinished extends DiscoverState {
  final bool isSuccess;
  final List<Product> products;
  // final List<Menu> menus;
  // final List<SysCategory> categories;

  DiscoverLoadFinished(
      {
      // this.menus = const [],
      this.products = const [],
      this.isSuccess = false});

  @override
  List<Object> get props => [products.hashCode, isSuccess];

  @override
  String toString() {
    return 'DiscoverLoadFinished{products: $products}';
  }
}

class WishlistLoadFinished extends DiscoverState {
  final bool isSuccess;
  final List<Product> products;

  WishlistLoadFinished({this.products = const [], this.isSuccess = false});

  @override
  List<Object> get props => [products.hashCode, isSuccess];

  @override
  String toString() {
    return 'WishlistLoadFinished{products: $products}';
  }
}
