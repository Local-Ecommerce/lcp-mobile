part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderUpdatedEvent extends OrderEvent {
  final Order order;

  OrderUpdatedEvent({this.order});

  @override
  List<Object> get props => [this.order];
}

class LoadingOrderEvent extends OrderEvent {
  final Order order;
  final String orderId;

  LoadingOrderEvent({this.order, this.orderId});

  @override
  List<Object> get props => [this.order];
}

class CreateOrderEvent extends OrderEvent {
  final List<OrderRequest> lstRequest;

  CreateOrderEvent({this.lstRequest});

  @override
  List<Object> get props => [this.lstRequest];
}

class LoadingListOrderEvent extends OrderEvent {
  final status;

  LoadingListOrderEvent({this.status});

  @override
  List<Object> get props => [this.status];
}

class OrderListUpdateEvent extends OrderEvent {
  final List<Order> lstOrder;
  final status;

  OrderListUpdateEvent({this.lstOrder, this.status});

  @override
  List<Object> get props => [this.lstOrder];
}
