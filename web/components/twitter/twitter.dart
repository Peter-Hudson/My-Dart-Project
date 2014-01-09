library twitter;

import 'package:angular/angular.dart';

import 'dart:html';
import 'dart:convert';
import 'dart:async';

@NgComponent(
    selector: 'twitter',    
    templateUrl: 'components/twitter/twitter.html',
    cssUrl: 'components/twitter/twitter.css',
    publishAs: 'tw'
  )

  class Twitter extends NgShadowRootAware{
    Scope scope;
    Element domdiv;
    DivElement domcontainer;
    DivElement domref;
    Compiler compiler;
    Injector injector;
    int length = 0;
    var setTimer;
    Duration durationCount;
    int duration_time = 10;

    void onShadowRoot(ShadowRoot shadowRoot) {
      domcontainer = shadowRoot.querySelector("#twitter");
      domcontainer.append(domdiv);    
      BlockFactory template = compiler([domcontainer]);
      Scope childScope = scope.$new();
      Injector childInjector = injector.createChild([new Module()..value(Scope, childScope)]);
      template(childInjector, [domcontainer]);
    }
    
    Twitter(this.compiler, this.injector, this.scope) {
      domdiv = new DivElement();
      domdiv.setAttribute('class','twitter-wrapper');
      Syncer('updates.json',loadDisplay);
    }
    
    void Syncer(pasd_url,future_func){
      var request = HttpRequest.getString(pasd_url).then(future_func).catchError((error) => print('Failed to connect ${error.toString()}'));      
    }
    
    // Convert URLs in the text to links.
    String linkwrapper(String text) {      
      List words = text.split(' ');
      var buffer = new StringBuffer();
      for (var word in words) {
        if (!buffer.isEmpty) buffer.write(' ');
        if (word.startsWith('http://') || word.startsWith('https://')) {
          buffer.write('<a href="$word" target="_blank">$word</a>');
        } else {
          buffer.write(word);
        }
      }
      return buffer.toString();
    }
    
    void loadDisplay(var data) {
      var results = JSON.decode(data);      
      divListCreate(results, domdiv, results.length);
      setupPolling();      
    }
    
    void appendTweetFeed(List pasd_results){
      divListCreate(pasd_results, domcontainer.firstChild, pasd_results.length-length, domdiv.firstChild);      
    }
    
    void divListCreate(List pasd_results,DivElement parent_dom, int max_i,[reference_dom = null]){
      for(int ii = 0; ii < (pasd_results.length-length); ii++){
        var result = pasd_results[ii];
        String user = result['user']['name'];
        String text = linkwrapper(result['text']);
        var div = new DivElement()
          ..setInnerHtml('<div>From: $user</div><div>$text</div>', validator: new NodeValidatorBuilder()
            ..allowTextElements()
            ..allowHtml5()
            ..allowElement('a', attributes: ['href']))
            ..setAttribute('class', 'tweet-item');
        if(reference_dom != null){
          parent_dom.insertBefore(div, reference_dom);
        }else{
          parent_dom.append(div);
        }
        
      }
      length = pasd_results.length;
    }
    
    void setupPolling(){
      durationCount = new Duration(seconds: duration_time);
      new Timer(durationCount, () => Syncer('updates.json',displayChecker));      
    }    
    
    displayChecker(var data){
      var json_data = JSON.decode(data);
      if(json_data.length > length){
        appendTweetFeed(json_data);
      }
//      print('running...');
      return new Timer(durationCount, () => Syncer('updates.json',displayChecker));
    }

}