import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/discover/repository/discover_repository.dart';
import 'package:lcp_mobile/feature/discover/repository/api_discover_repository.dart';
import 'package:lcp_mobile/feature/order/model/order.dart';
import 'package:lcp_mobile/feature/order/repository/api_order_repository.dart';
import 'package:lcp_mobile/feature/product_category/model/system_category.dart';
import 'package:lcp_mobile/feature/product_category/repository/api_product_category_repository.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  StreamSubscription _streamSubscription;
  ApiOrderRepository _apiOrderRepository;

  OrderBloc()
      : _apiOrderRepository = ApiOrderRepository(),
        super(OrderLoading());

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if (event is LoadingOrderEvent) {
      yield* _mapLoadOrderEvent(event);
    } else if (event is OrderUpdatedEvent) {
      yield* _mapOrderUpdatedEventToState(event);
    } else if (event is CreateOrderEvent) {
      yield* _createOrderEventToState(event);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  Stream<OrderState> _mapLoadOrderEvent(LoadingOrderEvent event) async* {
    _streamSubscription =
        Stream.fromFuture(_apiOrderRepository.getOrderById(event.orderId))
            .listen((order) {
      add(OrderUpdatedEvent(order: order));
    });
  }

  Stream<OrderState> _mapOrderUpdatedEventToState(
      OrderUpdatedEvent event) async* {
    yield OrderLoadFinished(
        orderId: event.order.orderId, order: event.order, isSuccess: true);
    // yield CategoryLoadFinished(categories: categories, isSuccess: true);
  }

  Stream<OrderState> _createOrderEventToState(CreateOrderEvent event) async* {
    // _streamSubscription =
    //     Stream.fromFuture(_apiOrderRepository.createOrder(event.lstRequest))
    //         .listen((order) async* {
    //   yield OrderCreateFinished(order: order);
    // });
    _streamSubscription =
        Stream.fromFuture(_apiOrderRepository.createOrder(event.lstRequest))
            .listen((order) {
      add(OrderUpdatedEvent(order: order));
    });
  }
}
