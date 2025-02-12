import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class SearchService {
  Future<List<SearchItem>> searchByText(String query, BoundingBox boundingBox) async {
    try {
      final resultWithSession = YandexSearch.searchByText(
        searchText: query,
        geometry: Geometry.fromBoundingBox(boundingBox),
        searchOptions: const SearchOptions(
          searchType: SearchType.geo,
          geometry: true,
        ),
      );
      final result = await resultWithSession;
      final data = await result.$2;
      return data.items ?? [];
    } catch (e) {
      debugPrint('Error searching place: $e');
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
      debugPrint('Error getting address: $e');
      return null;
    }
  }
}
