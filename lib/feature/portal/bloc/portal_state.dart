part of 'portal_bloc.dart';

abstract class PortalState extends Equatable {
  const PortalState();

  @override
  List<Object> get props => [];
}

class PortalLoading extends PortalState {}

class NewsLoading extends PortalState {}

class PoisLoading extends PortalState {}

class PortalLoadFinished extends PortalState {
  final bool isSuccess;
  final List<POI> pois;
  final List<New> news;

  PortalLoadFinished(
      {this.pois = const [], this.news = const [], this.isSuccess = false});

  @override
  List<Object> get props => [pois.hashCode, news.hashCode, isSuccess];

  @override
  String toString() {
    return 'PortalLoadFinished{poi: $pois, new: $news}';
  }
}

class NewsLoadFinished extends PortalState {
  final bool isSuccess;
  final List<New> news;

  NewsLoadFinished({this.news = const [], this.isSuccess = false});

  @override
  List<Object> get props => [news.hashCode, isSuccess];

  @override
  String toString() {
    return 'PortalLoadFinished{new: $news}';
  }
}

class PoisLoadFinished extends PortalState {
  final bool isSuccess;
  final List<POI> pois;

  PoisLoadFinished({this.pois = const [], this.isSuccess = false});

  @override
  List<Object> get props => [pois.hashCode, isSuccess];

  @override
  String toString() {
    return 'PortalLoadFinished{poi: $pois}';
  }
}
