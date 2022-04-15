import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/discover/repository/discover_repository.dart';
import 'package:lcp_mobile/feature/discover/repository/api_discover_repository.dart';
import 'package:lcp_mobile/feature/product_category/model/system_category.dart';
import 'package:lcp_mobile/feature/product_category/repository/api_product_category_repository.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  StreamSubscription _streamSubscription, _streamSubscriptionChild;
  ApiProductCategoryRepository _apiProductCategoryRepository;

  CategoryBloc()
      : _apiProductCategoryRepository = ApiProductCategoryRepository(),
        super(CategoryLoading());

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is LoadingCategoryEvent) {
      yield* _mapLoadCategoryEvent(event);
    } else if (event is CategoryUpdatedEvent) {
      yield* _mapCategoryUpdatedEventToState(event);
    } else if (event is LoadingCategoryChildEvent) {
      yield* _mapLoadCategoryChildEvent(event);
    } else if (event is CategoryChildUpdatedEvent) {
      yield* _mapCategoryChildUpdatedEventToState(event);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    _streamSubscriptionChild.cancel();
    return super.close();
  }

  Stream<CategoryState> _mapLoadCategoryEvent(
      LoadingCategoryEvent event) async* {
    _streamSubscription =
        Stream.fromFuture(_apiProductCategoryRepository.getAllCategories())
            .listen((categories) {
      add(CategoryUpdatedEvent(categories: categories));
    });
  }

  Stream<CategoryState> _mapCategoryUpdatedEventToState(
      CategoryUpdatedEvent event) async* {
    add(LoadingCategoryChildEvent(categories: event.categories));
    // yield CategoryLoadFinished(categories: categories, isSuccess: true);
  }

  Stream<CategoryState> _mapLoadCategoryChildEvent(
      LoadingCategoryChildEvent event) async* {
    _streamSubscriptionChild = Stream.fromFuture(_apiProductCategoryRepository
            .getChildListCategory(event.category == null
                ? event.categories[0].sysCategoryID
                : event.category))
        .listen((cateChild) {
      add(CategoryChildUpdatedEvent(
          cateChild: cateChild, categories: event.categories));
    });
  }

  Stream<CategoryState> _mapCategoryChildUpdatedEventToState(
      CategoryChildUpdatedEvent event) async* {
    // var cateChild = event.cateChild;
    yield CategoryChildLoadFinished(
        cateChild: event.cateChild,
        categories: event.categories,
        isSuccess: true);
  }
}
