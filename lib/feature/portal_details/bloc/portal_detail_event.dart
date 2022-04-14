part of 'portal_detail_bloc.dart';

abstract class PortalDetailsEvent {}

class LoadPOIDetails extends PortalDetailsEvent {
  final String poiId;

  LoadPOIDetails(this.poiId);
}

class LoadNewDetails extends PortalDetailsEvent {
  final String newId;

  LoadNewDetails(this.newId);
}
