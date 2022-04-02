import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lcp_mobile/feature/discover/repository/discover_repository.dart';
import 'package:lcp_mobile/feature/discover/repository/api_discover_repository.dart';
import 'package:lcp_mobile/feature/product_category/model/system_category.dart';
import 'package:lcp_mobile/feature/product_category/repository/api_product_category_repository.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  DiscoverRepository _discoverRepository;
  StreamSubscription _streamSubscription;
  // ApiMenuRepository _apiMenuRepository;
  ApiDiscoverRepository _apiDiscoverRepository;
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
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
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
}

Stream<CategoryState> _mapCategoryUpdatedEventToState(
    CategoryUpdatedEvent event) async* {
  var categories = event.categories;
  yield CategoryLoadFinished(categories: categories, isSuccess: true);
}
