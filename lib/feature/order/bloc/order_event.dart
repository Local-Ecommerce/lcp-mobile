part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderUpdatedEvent extends OrderEvent {
  final Order order;

  OrderUpdatedEvent({this.order});

  @override
  List<Object> get props => [order];
}

class LoadingOrderEvent extends OrderEvent {
  final Order order;
  final String orderId;

  LoadingOrderEvent({this.order, this.orderId});

  @override
  List<Object> get props => [order];
}

class CreateOrderEvent extends OrderEvent {
  final List<OrderRequest> lstRequest;

  CreateOrderEvent({this.lstRequest});

  @override
  List<Object> get props => [lstRequest];
}
