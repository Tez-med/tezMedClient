import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class SearchService {
  // O‘zbekiston chegaralari (aniqroq qamrov)
  final uzbekistanBoundingBox = BoundingBox(
    southWest: Point(latitude: 37.0, longitude: 55.0),
    northEast: Point(latitude: 46.0, longitude: 74.0),
  );

  Future<List<SearchItem>> searchByText(String query) async {
    try {
      final resultWithSession = YandexSearch.searchByText(
        searchText: query,
        geometry: Geometry.fromBoundingBox(uzbekistanBoundingBox),
        searchOptions: const SearchOptions(
          searchType: SearchType.geo,
          geometry: true,
          resultPageSize: 20,
          disableSpellingCorrection: false,
          // lang parametri yo‘q, shuning uchun foydalanuvchi tiliga tayaniladi
        ),
      );

      final result = await resultWithSession;
      final data = await result.$2;

      return data.items ?? [];
    } catch (e) {
      debugPrint('Qidiruvda xatolik yuz berdi: $e');
      return [];
    }
  }

  Future<String?> getAddressFromPoint(Point point) async {
    try {
      final resultWithSession = YandexSearch.searchByPoint(
        point: point,
        searchOptions: const SearchOptions(
          searchType: SearchType.geo,
          geometry: false,
        ),
      );
      final result = await resultWithSession;
      final data = await result.$2;
      return data.items?.first.name;
    } catch (e) {
      debugPrint('Manzilni olishda xatolik: $e');
      return null;
    }
  }
}
