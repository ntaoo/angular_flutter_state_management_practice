import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'hero_search_component.dart';
import 'package:model/hero.dart';
import 'route_paths.dart';

@Component(
  selector: 'my-dashboard',
  templateUrl: 'dashboard_component.html',
  styleUrls: ['dashboard_component.css'],
  directives: [coreDirectives, HeroSearchComponent, routerDirectives],
)
class DashboardComponent implements OnInit, OnDestroy {
  final HeroService _heroService;
  List<StreamSubscription> _subscriptions = [];
  List<Hero> topHeroes = [];

  DashboardComponent(this._heroService);

  void ngOnInit() {
    _subscriptions.add(_heroService.topHeroes.listen((list) => topHeroes = list));
  }

  void ngOnDestroy() {
    _subscriptions.forEach((s) => s.cancel());
  }

  String heroUrl(int id) => RoutePaths.hero.toUrl(parameters: {idParam: '$id'});
}
