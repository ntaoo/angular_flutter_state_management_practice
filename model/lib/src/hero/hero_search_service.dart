import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

import 'hero.dart';

class HeroSearchService {
  final Client _http;
  final _searchQueryController = BehaviorSubject<String>();

  final _searchResultController =
      BehaviorSubject<UnmodifiableListView<Hero>>.seeded(
          UnmodifiableListView([]));

  HeroSearchService(this._http) {
    _searchQueryController
        .debounceTime(const Duration(milliseconds: 300))
        .distinct()
        .forEach(_search);
  }

  Sink<String> get searchQuery => _searchQueryController.sink;
  Stream<UnmodifiableListView<Hero>> get searchResult =>
      _searchResultController.stream;

  void _search(String term) async {
    if (term.isEmpty) {
      _searchResultController.add(UnmodifiableListView([]));
      return;
    }

    var result;
    try {
      final response = await _http.get('app/heroes/?name=$term');
      result =
          (_extractData(response) as List).map((json) => Hero.fromJson(json));
    } catch (e) {
      throw _handleError(e);
    }
    _searchResultController.add(UnmodifiableListView(result));
  }

  dynamic _extractData(Response resp) => json.decode(resp.body)['data'];

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }

  void dispose() {
    _searchQueryController.close();
    _searchResultController.close();
  }
}
