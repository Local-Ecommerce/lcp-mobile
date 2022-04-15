part of 'portal_bloc.dart';

abstract class PortalEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PoisUpdateEvent extends PortalEvent {
  final List<POI> pois;

  PoisUpdateEvent({this.pois});

  @override
  List<Object> get props => [pois];
}

class NewsUpdateEvent extends PortalEvent {
  final List<New> news;

  NewsUpdateEvent({this.news});

  @override
  List<Object> get props => [news];
}

class LoadingPoisEvent extends PortalEvent {
  final String apartmentId;
  final String type;

  LoadingPoisEvent({this.apartmentId, this.type});

  @override
  List<Object> get props => [apartmentId];
}

class LoadingNewsEvent extends PortalEvent {
  final String apartmentId;
  final String type;

  LoadingNewsEvent({this.apartmentId, this.type});

  @override
  List<Object> get props => [apartmentId];
}
