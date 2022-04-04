part of 'portal_detail_bloc.dart';

abstract class PortalDetailsState {}

class PortalDetailsInitial extends PortalDetailsState {}

class LoadPOIDetailsFinished extends PortalDetailsState {
  final POI poi;

  LoadPOIDetailsFinished(this.poi);
}

class LoadNewDetailsFinished extends PortalDetailsState {
  final New news;

  LoadNewDetailsFinished(this.news);
}
