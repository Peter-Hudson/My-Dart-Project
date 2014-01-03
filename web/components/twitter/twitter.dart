library twitter;

import 'package:angular/angular.dart';
import 'package:google_oauth2_client/google_oauth2_browser.dart';

import 'dart:html';
import 'package:js/js.dart' as js;

@NgComponent(
    selector: 'twitter',
    templateUrl: 'components/twitter/twitter.html',
    cssUrl: 'components/twitter/twitter.css'
//    publishAs: 'ctrl',
//    map: const {
//      'twitter-feed' : 'twitter'
//    }
   
  )

  class Twitter{

    var domdiv;
  
    Twitter() {
      domdiv = querySelector('#twitter');
      // Create a JavaScript function called display that forwards to the Dart
      // function.
      js.context.display = display;
    
      // Inject a JSONP request to Twitter invoking the JavaScript display
      // function.
      document.body.nodes.add(new ScriptElement()..src =
        "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=peter_hudson&count=4&callback=display");
    }
    
    // Convert URLs in the text to links.
    String linkify(String text) {
      List words = text.split(' ');
      var buffer = new StringBuffer();
      for (var word in words) {
        if (!buffer.isEmpty) buffer.write(' ');
        if (word.startsWith('http://') || word.startsWith('https://')) {
          buffer.write('<a href="$word">$word</a>');
        } else {
          buffer.write(word);
        }
      }
      return buffer.toString();
    }
    
    // Display the JSON data on the web page.
    // Note callbacks are automatically executed within a scope.
    void display(var data) {
      // The data and results objects are proxies to JavaScript object.
      var results = data.results;
      int length = results.length;
    
      for (int i = 0; i < length; ++i) {
        var result = results[i];
        String user = result.from_user_name;
        String text = linkify(result.text);
    
        var div = new DivElement()
          ..innerHtml = '<div>From: $user</div><div>$text</div><p>';
        domdiv.nodes.add(div);
      }
    }

}