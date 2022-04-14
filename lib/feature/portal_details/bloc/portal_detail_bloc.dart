import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/feature/portal_details/repository/portal_detail_repository.dart';
import 'package:lcp_mobile/feature/product_details/repository/product_details_repository.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';

part 'portal_detail_event.dart';

part 'portal_detail_state.dart';

class PortalDetailsBloc extends Bloc<PortalDetailsEvent, PortalDetailsState> {
  PortalDetailsRepository _portalDetailsDao;

  PortalDetailsBloc()
      : _portalDetailsDao = PortalDetailsRepository(),
        super(PortalDetailsInitial());

  @override
  Stream<PortalDetailsState> mapEventToState(
    PortalDetailsEvent event,
  ) async* {
    if (event is LoadPOIDetails) {
      yield* _mapLoadPOIDetailsEventToState(event);
    } else if (event is LoadNewDetails) {
      yield* _mapLoadNewDetailsEventToState(event);
    }
  }

  Stream<PortalDetailsState> _mapLoadPOIDetailsEventToState(
      LoadPOIDetails event) async* {
    var poi = await _portalDetailsDao.getPOIDetails(event.poiId);

    yield LoadPOIDetailsFinished(poi);
  }

  Stream<PortalDetailsState> _mapLoadNewDetailsEventToState(
      LoadNewDetails event) async* {
    var news = await _portalDetailsDao.getNewDetails(event.newId);

    yield LoadNewDetailsFinished(news);
  }
}
