import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lcp_mobile/feature/portal/repository/api_portal_repository.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';

part 'portal_event.dart';

part 'portal_state.dart';

class PortalBloc extends Bloc<PortalEvent, PortalState> {
  StreamSubscription _streamSubscription;
  ApiPortalRepository _apiPortalRepository;

  PortalBloc()
      : _apiPortalRepository = ApiPortalRepository(),
        super(PortalLoading());

  @override
  Stream<PortalState> mapEventToState(
    PortalEvent event,
  ) async* {
    //TODO
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  //TODO
}
