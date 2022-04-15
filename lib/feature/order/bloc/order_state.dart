part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderLoading extends OrderState {}

class OrderLoadFinished extends OrderState {
  final bool isSuccess;
  final Order order;
  final String orderId;

  OrderLoadFinished({this.order, this.orderId, this.isSuccess});

  @override
  List<Object> get props => [order.hashCode, isSuccess];

  @override
  String toString() {
    return 'OrderLoadFinished{order: $order}';
  }
}

class OrderCreateFinished extends OrderState {
  final bool isSuccess;
  final Order order;

  OrderCreateFinished({this.order, this.isSuccess = false});

  @override
  List<Object> get props => [order, isSuccess];

  @override
  String toString() {
    return 'OrderCreateFinished{cateChild: $order}';
  }
}
