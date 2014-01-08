library twitter;

import 'package:angular/angular.dart';

import 'dart:html';
import 'dart:convert';

@NgComponent(
    selector: 'twitter',    
    templateUrl: 'components/twitter/twitter.html',
    cssUrl: 'components/twitter/twitter.css',
    publishAs: 'tw'
  )

  class Twitter extends NgShadowRootAware{
    Scope scope;
    Element domdiv;
    Compiler compiler;
    Injector injector;

    void onShadowRoot(ShadowRoot shadowRoot) {     
      DivElement domcontainer = shadowRoot.querySelector("#twitter");
      domcontainer.append(domdiv);    
      BlockFactory template = compiler([domcontainer]);
      Scope childScope = scope.$new();
      Injector childInjector = injector.createChild([new Module()..value(Scope, childScope)]);
      template(childInjector, [domcontainer]);
    }
    
    Twitter(this.compiler, this.injector, this.scope) {
      domdiv = new DivElement();     
      var request = HttpRequest.getString("updates.json").then(display);
      
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
    
    void display(var data) {
      var results = JSON.decode(data);
      int length = results.length;          
      for (int i = 0; i < length; ++i) {
        var result = results[i];
        String user = result['user']['name'];
        String text = linkwrapper(result['text']);
        var atag = new AnchorElement();
        
        var div = new DivElement()
          ..setInnerHtml('<div>From: $user</div><div>$text</div>', validator: new NodeValidatorBuilder()
            ..allowTextElements()
            ..allowHtml5()
            ..allowElement('a', attributes: ['href']));
        domdiv.append(div);

      }
    }
    

}