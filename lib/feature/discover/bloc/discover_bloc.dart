import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/discover/repository/api_discover_repository.dart';
import 'package:lcp_mobile/feature/discover/repository/discover_repository.dart';
import 'package:lcp_mobile/feature/discover/repository/firebase_discover_repository.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverRepository _discoverRepository;
  StreamSubscription _streamSubscription;
  ApiDiscoverRepository _apiDiscoverRepository;

  DiscoverBloc()
      : _discoverRepository = FirebaseDiscoverRepository(),
        _apiDiscoverRepository = ApiDiscoverRepository(),
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
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  Stream<DiscoverState> _mapLoadDiscoverEvent(
      LoadingDiscoverEvent event) async* {
    if (event.category != "") {
      _streamSubscription = Stream.fromFuture(_apiDiscoverRepository
              .getProductByApartmentCategory(event.apartmentId, event.category))
          .listen((products) {
        add(DiscoverUpdatedEvent(
            products: products,
            category: event.category,
            lstChildCategory: event.lstChildCategory));
      });
    } else {
      _streamSubscription = Stream.fromFuture(_apiDiscoverRepository
              .getProductListByApartment(event.apartmentId))
          .listen((products) {
        add(DiscoverUpdatedEvent(products: products, category: event.category));
      });
    }
  }
}

Stream<DiscoverState> _mapDiscoverUpdatedEventToState(
    DiscoverUpdatedEvent event) async* {
  var filterList;

  if (event.category != "") {
    filterList = event.products.where((product) {
      var _isChildValid = false;
      event.lstChildCategory.forEach((childCate) {
        if (product.systemCategoryId == childCate['SystemCategoryId'] ||
            product.systemCategoryId == event.category)
          return _isChildValid = true;
      });
      return _isChildValid == true ||
          product.systemCategoryId == event.category;
    }).toList();
  } else {
    filterList = event.products;
  }
  yield DiscoverLoadFinished(products: filterList, isSuccess: true);
}
