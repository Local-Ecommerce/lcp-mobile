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
    if (event is LoadingNewsEvent) {
      yield* _mapLoadNewsEvent(event);
    } else if (event is NewsUpdateEvent) {
      yield* _mapNewsUpdatedEventToState(event);
    } else if (event is LoadingPoisEvent) {
      yield* _mapLoadPoisEvent(event);
    } else if (event is PoisUpdateEvent) {
      yield* _mapPoisUpdatedEventToState(event);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  Stream<PortalState> _mapLoadNewsEvent(LoadingNewsEvent event) async* {
    _streamSubscription = Stream.fromFuture(_apiPortalRepository
            .getAllNewsByApartmentId(event.apartmentId, event.type))
        .listen((news) {
      add(NewsUpdateEvent(news: news));
    });
  }

  Stream<PortalState> _mapNewsUpdatedEventToState(
      NewsUpdateEvent event) async* {
    var filterList;
    // if (event.category != "") {
    //   filterList = event.products.where((element) {
    //     return element.systemCategoryId == event.category;
    //   }).toList();
    // } else {
    filterList = event.news;
    yield NewsLoadFinished(news: filterList, isSuccess: true);
  }

  Stream<PortalState> _mapLoadPoisEvent(LoadingPoisEvent event) async* {
    _streamSubscription = Stream.fromFuture(_apiPortalRepository
            .getAllPoisByApartmentId(event.apartmentId, event.type))
        .listen((pois) {
      add(PoisUpdateEvent(pois: pois));
    });
  }

  Stream<PortalState> _mapPoisUpdatedEventToState(
      PoisUpdateEvent event) async* {
    var filterList;
    // if (event.category != "") {
    //   filterList = event.products.where((element) {
    //     return element.systemCategoryId == event.category;
    //   }).toList();
    // } else {
    filterList = event.pois;
    yield PoisLoadFinished(pois: filterList, isSuccess: true);
  }
}
