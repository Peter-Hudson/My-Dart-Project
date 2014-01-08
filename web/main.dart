import 'dart:html' as dom;
import 'dart:async';

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




class PageRouteInitializer implements RouteInitializer {
  void init(Router router, ViewFactory view) {    
    print('loading... ${router.activePath}');
    router.root
      ..addRoute(
        defaultRoute: true,        
        name: 'index',
        path: '/index',
        enter: view('parts/index.html')
      )..addRoute(
        name: 'about',
        path: '/about',
        enter: view('parts/about.html')
      );
  }
}


main() {
  // Set up the Angular directives.
  var module = new Module()
    ..type(RouteInitializer, implementedBy: PageRouteInitializer)
    ..type(Twitter)
    ..type(MainController);

  ngBootstrap(module:module);
}
