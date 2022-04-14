import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';
import 'package:lcp_mobile/feature/portal/repository/api_portal_repository.dart';

class PortalDetailsRepository {
  ApiPortalRepository apiPortalRepository;

  PortalDetailsRepository() {
    apiPortalRepository = new ApiPortalRepository();
  }

  Future<POI> getPOIDetails(String id) async {
    POI result = await apiPortalRepository.getPOIDetail(id);
    return _poiListFromSnapshot(result);
  }

  POI _poiListFromSnapshot(POI doc) {
    return POI(
        apartmentId: doc.apartmentId,
        poiId: doc.poiId,
        releaseDate: doc.releaseDate,
        residentId: doc.residentId,
        status: doc.status,
        text: doc.text,
        title: doc.title);
  }

  Future<New> getNewDetails(String id) async {
    New result = await apiPortalRepository.getNewDetail(id);
    return _newListFromSnapshot(result);
  }

  New _newListFromSnapshot(New doc) {
    return New(
        apartmentId: doc.apartmentId,
        newsId: doc.newsId,
        releaseDate: doc.releaseDate,
        residentId: doc.residentId,
        status: doc.status,
        text: doc.text,
        title: doc.title);
  }
}
