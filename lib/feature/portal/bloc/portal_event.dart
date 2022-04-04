part of 'portal_bloc.dart';

abstract class PortalEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PortalUpdatedEvent extends PortalEvent {
  final List<POI> pois;
  final List<New> news;

  PortalUpdatedEvent({this.pois, this.news});

  @override
  List<Object> get props => [pois, news];
}

class LoadingPortalEvent extends PortalEvent {
  final String apartmentId;

  LoadingPortalEvent({this.apartmentId});

  @override
  List<Object> get props => [apartmentId];
}
