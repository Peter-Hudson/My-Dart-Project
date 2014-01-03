import 'dart:html' as dom;

import 'package:angular/angular.dart';
import 'package:di/di.dart';

import 'components/twitter/twitter.dart';

@NgDirective(
  selector: '[main-controller]'
)
class MainController {
  
  MainController(Scope scope) {
     
  }
}




class RecipesRouteInitializer implements RouteInitializer {
  void init(Router router, ViewFactory view) {
    router.root
      ..addRoute(
        name: 'index',
        path: '/',
        enter: view('parts/index.html')
      );
  }
}


main() {
  // Set up the Angular directives.
  var module = new Module()
    ..type(RouteInitializer, implementedBy: RecipesRouteInitializer)
    ..type(Twitter)
    ..type(MainController);

  ngBootstrap(module:module);
}