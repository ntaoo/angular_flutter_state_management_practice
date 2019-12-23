import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

import 'hero.dart';

class HeroService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _heroesUrl = 'api/heroes'; // URL to web API

  final Client _http;
  final _heroesController = BehaviorSubject<UnmodifiableListView<Hero>>.seeded(
      UnmodifiableListView([]));

  HeroService(this._http) {
    _getAll();
  }

  Stream<UnmodifiableListView<Hero>> get topHeroes =>
      allHeroes.map((list) => UnmodifiableListView(list.take(4)));

  Stream<UnmodifiableListView<Hero>> get allHeroes => _heroesController.stream;

  void _getAll() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = (_extractData(response) as List)
          .map((json) => Hero.fromJson(json));
      _heroesController.add(UnmodifiableListView(heroes));
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _extractData(Response resp) => json.decode(resp.body)['data'];

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }

  Future<Hero> get(int id) async {
    try {
      final response = await _http.get('$_heroesUrl/$id');
      return Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  void create(String name) async {
    try {
      await _http.post(_heroesUrl,
          headers: _headers, body: json.encode({'name': name}));
    } catch (e) {
      throw _handleError(e);
    }
    _getAll();
  }

  void update(Hero hero) async {
    try {
      final url = '$_heroesUrl/${hero.id}';

          await _http.put(url, headers: _headers, body: json.encode(hero));

    } catch (e) {
      throw _handleError(e);
    }
    _getAll();
  }

  void delete(int id) async {
    try {
      final url = '$_heroesUrl/$id';
      await _http.delete(url, headers: _headers);
    } catch (e) {
      throw _handleError(e);
    }
    _getAll();
  }
}
