import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapService {
  late YandexMapController mapController;

  Future<void> initializeMap(YandexMapController controller) async {
    mapController = controller;
  }

  Future<void> moveToPoint(Point point, {double zoom = 15}) async {
    await mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: zoom),
      ),
    );
  }
}
