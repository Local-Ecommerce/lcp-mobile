import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/discover/repository/discover_repository.dart';
import 'package:lcp_mobile/feature/discover/repository/firebase_discover_repository.dart';
import 'package:lcp_mobile/feature/discover/repository/api_discover_repository.dart';
import 'package:lcp_mobile/feature/menu/model/menu.dart';
import 'package:lcp_mobile/feature/menu/repository/api_menu_repository.dart';
import 'package:lcp_mobile/feature/product_category/model/system_category.dart';
import 'package:lcp_mobile/feature/product_category/repository/api_product_category_repository.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'discover_event.dart';

part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverRepository _discoverRepository;
  StreamSubscription _streamSubscription;
  // ApiMenuRepository _apiMenuRepository;
  ApiDiscoverRepository _apiDiscoverRepository;
  ApiProductCategoryRepository _apiProductCategoryRepository;

  DiscoverBloc()
      : _discoverRepository = FirebaseDiscoverRepository(),
        _apiDiscoverRepository = ApiDiscoverRepository(),
        _apiProductCategoryRepository = ApiProductCategoryRepository(),
        super(DiscoverLoading());

  @override
  Stream<DiscoverState> mapEventToState(
    DiscoverEvent event,
  ) async* {
    if (event is LoadingDiscoverEvent) {
      yield* _mapLoadDiscoverEvent(event);
    } else if (event is DiscoverUpdatedEvent) {
      yield* _mapDiscoverUpdatedEventToState(event);
    }
    // else if (event is LoadingWishlistEvent) {
    //   yield* _mapLoadWishlistEvent(event);
    // } else if (event is WishlistUpdatedEvent) {
    //   yield* _mapWishlistUpdatedEventToState(event);
    // }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  Stream<DiscoverState> _mapLoadDiscoverEvent(
      LoadingDiscoverEvent event) async* {
    // List<SysCategory> _sysCate =
    //     await _apiProductCategoryRepository.getAllCategories();

    // _streamSubscription =
    //     _discoverRepository.getListProduct().listen((products) {
    //   add(DiscoverUpdatedEvent(products: products, category: _sysCate));
    // });

    print(event.category);
    print(event.apartmentId);

    _streamSubscription = Stream.fromFuture(_apiDiscoverRepository
            .getProductByApartmentCategory(event.apartmentId, event.category))
        .listen((products) {
      print(products);
      add(DiscoverUpdatedEvent(products: products, category: event.category));
    });

    // _streamSubscription = Stream.fromFuture(_apiMenuRepository
    //         .getMenuByApartmentIdType(event.apartmentId, event.productType))
    //     .listen((menus) {
    //   add(DiscoverUpdatedEvent(
    //       menus: menus, categories: _sysCate, productType: event.productType));
    // });
  }
}

//TODO need refactor
Stream<DiscoverState> _mapDiscoverUpdatedEventToState(
    DiscoverUpdatedEvent event) async* {
  var filterList = event.products.where((element) {
    return element.systemCategoryId == event.category;
    // &&
    //     element. == event.category;
    // return null;
  }).toList();

  // var filterList = event.products.toList();
  // var categories = event.category;
  // _discoverRepository.addListProduct(demoProducts);
  yield DiscoverLoadFinished(products: filterList, isSuccess: true);
}

// Stream<DiscoverState> _mapLoadWishlistEvent(
//     LoadingWishlistEvent event) async* {
//   _discoverRepository.getListProduct().listen((event) {
//     var filterList = event.where((element) {
//       return element.isFavorite;
//     }).toList();
//     add(WishlistUpdatedEvent(products: filterList));
//   });
// }

// Stream<DiscoverState> _mapWishlistUpdatedEventToState(
//     WishlistUpdatedEvent event) async* {
//   yield WishlistLoadFinished(products: event.products, isSuccess: true);
// }
