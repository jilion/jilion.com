Element.addMethods({
  shake: function(element, options) {
    S2.Extensions.webkitCSSTransitions = false; //essential, cause webkit transitions in this case are less smooth
    
    element = $(element);
    var originalLeft = parseFloat(element.getStyle('left') || '0');
    var oldStyle = { left:originalLeft };
    element.makePositioned();
    
    var opts = { distance:15, duration:0.5 };
    Object.extend(opts, options);
    var distance = opts.distance;
    var duration = opts.duration;
    
    var split = parseFloat(duration) / 10.0;
    
    var shakeEffect = element.morph('left:' + (originalLeft+distance) + 'px', { duration:split 
      }).morph('left:' + (originalLeft-distance) + 'px', { duration:split*2
        }).morph('left:' + (originalLeft+distance) + 'px', { duration:split*2
          }).morph('left:' + (originalLeft-distance) + 'px', { duration:split*2
            }).morph('left:' + (originalLeft+distance) + 'px', { duration:split*2
              }).morph('left:' + (originalLeft) + 'px', { duration:split*2, after: function() {
                element.undoPositioned().setStyle(oldStyle);
                }});
                
    return shakeEffect;
  },
  pulsate: function(element, options) {
  }
});

document.observe("dom:loaded", function() {
  // Windows Disable Typekit
  if ((navigator.userAgent.indexOf("Windows")!=-1)) $(document.body).addClassName('win');
  
  //Curvy Corners (IE)
  // if (Prototype.Browser.IE || Prototype.Browser.Opera) {
  if (Prototype.Browser.IE) {
    var settings = {
      tl: { radius: 10 },
      tr: { radius: 10 },
      bl: { radius: 10 },
      br: { radius: 10 },
      antiAlias: true
    };
    var divObj = $("back").addClassName("curvyRedraw"); //class curvyRedraw to be able to call curvyCorners.redraw()
    curvyCorners(settings, divObj);
    divObj.style.filter="alpha(opacity=70)";
  }
  
  //Google Map
  if (Prototype.Browser.MobileSafari) {
    if ($('show_location'))
      $('show_location').href = "http://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=Chemin+de+la+Raye+13,+1024+Ecublens,+Switzerland&sll=46.524693,6.564245&sspn=0.010586,0.019033&ie=UTF8&ll=46.524708,6.564074&spn=0.010586,0.019033&z=16&iwloc=A";
  }
  else {
    if ($('show_location'))
      $('show_location').observe("click", showMap);
  }
  
  var dropPin = new Image();
  dropPin.src = "/images/embed/map_drop_pin.png";
  
  //Newsletter
  var emailField = $('subscriber_email');
  var emailFlash = $('email_flash');
  if (emailField) {
    var placeholder = $('email_placeholder');
    if ($F(emailField).blank()) placeholder.show(); //the "if" is for freaking FF (when reloading page with the field filled)
    emailField.observe("focus", function(e){ placeholder.hide(); });
    emailField.observe("blur", function(e){ 
      if ($F(emailField).blank()) placeholder.show();
    });
    placeholder.observe("click", function(e){ emailField.focus(); });
    $('new_subscriber').observe("submit", function(e){
      if (!validateEmail($F(emailField))) {
        // $('email_field_wrap').shake({distance:15, duration:0.6});
        // $('email_field_wrap').shake({distance:35, duration:2.6});
        
        // ===========================================
        // = Implementing Shake effect with scripty2 =
        
        $('email_field_wrap').shake();
        
        // var emailFieldWrap = $('email_field_wrap');
        // var originalLeft = parseFloat(emailFieldWrap.getStyle('left') || '0');
        // var oldStyle = { left:originalLeft };
        // emailFieldWrap.makePositioned();
        // 
        // var distance = 15;
        // var duration = 0.6;
        // 
        // var split = parseFloat(duration) / 10.0;
        // 
        // emailFieldWrap.morph('left:' + (originalLeft+distance) + 'px', { duration:split 
        //   }).morph('left:' + (originalLeft-distance) + 'px', { duration:split*2
        //     }).morph('left:' + (originalLeft+distance) + 'px', { duration:split*2
        //       }).morph('left:' + (originalLeft-distance) + 'px', { duration:split*2
        //         }).morph('left:' + (originalLeft+distance) + 'px', { duration:split*2
        //           }).morph('left:' + (originalLeft) + 'px', { duration:split, after: function() {
        //             emailFieldWrap.undoPositioned().setStyle(oldStyle);
        //             }});
        
        // emailFieldWrap.morph('left:' + (originalLeft+distance) + 'px', { duration:split, after: function() {
        //   emailFieldWrap.morph('left:' + (originalLeft-distance) + 'px', { duration:split*2, after: function() {
        //     emailFieldWrap.morph('left:' + (originalLeft+distance) + 'px', { duration:split*2, after: function() {
        //       emailFieldWrap.morph('left:' + (originalLeft-distance) + 'px', { duration:split*2, after: function() {
        //         emailFieldWrap.morph('left:' + (originalLeft+distance) + 'px', { duration:split*2, after: function() {
        //           emailFieldWrap.morph('left:' + (originalLeft) + 'px', { duration:split, after: function() {
        //             emailFieldWrap.undoPositioned().setStyle(oldStyle);
        //           }});
        //         }});
        //       }});
        //     }});
        //   }});
        // }});
        // ===========================================
        e.stop();
      }
    });
  }
  if (emailFlash) {
    setTimeout(function(){ 
      emailFlash.scrollTo();
      emailFlash.pulsate({pulses:3, duration:1.4});
    }, 500);
    
    // if unsubscribed... make email_field re-appear ;-)
    if (emailFlash.hasClassName('unsubscribed')) {
      setTimeout(function(){ 
        emailFlash.fade({ afterFinish: function(){ $('new_subscriber').appear(); } });
      }, 3000);
    }
  }
  
  $$('input[type=file]').each(function(input){
    input.observe('change', function(e){
      input.previous().down('.fake_file_input_value').update(input.value);
    });
    // input.observe('click', function(e){
    //   fakeFileInputButton.addClassName('active');
    // });
  });
  
  $$("#contact_topics li a.title").each(function(a){
    if (!a.hasClassName('static')) {
      if (a.next('.form_box').hasClassName('errors')) a.up().addClassName('expanded');
      a.observe("click",function(e){
        var form_box = a.next('.form_box');
        if (form_box.visible()) {
          a.up().removeClassName('expanded');
          form_box.hide();
        
          if (Prototype.Browser.IE) {
            curvyCorners.redraw();
          }
        
        } else {
          $$("#contact_topics li .form_box").invoke("hide");
          $$("#contact_topics li").invoke("removeClassName", "expanded");
          a.up().addClassName('expanded');
          form_box.setStyle({display:"block"});
        
          if (Prototype.Browser.IE) {
            curvyCorners.redraw();
          }
        
          var elementToScrollTo = a.up();
          var scrollPos = elementToScrollTo.cumulativeOffset().top;
          scrollTo(0,scrollPos-11);
        }
        e.stop();
      });
    }
  });
});

function validateEmail(email) {
  return email.match(/^\s*([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*$/i);
}

function googleMapInitialize() {
  var myLatlng = new google.maps.LatLng(46.51725, 6.56210);
  var cenLatlng = new google.maps.LatLng(46.51735, 6.56210);
  var myOptions = {
    zoom: 18,
    center: cenLatlng,
    mapTypeId: google.maps.MapTypeId.HYBRID
  };
  var map = new google.maps.Map(document.getElementById("map_wrap"), myOptions);
  
  var image = '/images/embed/map_drop_pin.png';
  var marker = new google.maps.Marker({
      position: myLatlng,
      map: map,
      title:"Jilion",
      icon: image
  });
  
  var contentString = '<div id="popbox">'+
      '<p><a href="http://bit.ly/h4GQ0l">EPFL Innovation Square <br /> PSE-D<br />1015 Lausanne <br /> Switzerland</a></p>'+
      '</div>';
      
  var infowindow = new google.maps.InfoWindow({
      content: contentString,
      disableAutoPan: true
  });
  
  infowindow.open(map,marker);
}

function showMap(event) {
  event.stop();
  var mapOverlay = $('map_global');
  if (mapOverlay.visible()) {
    hideMap();
  }
  else {
    mapOverlay.show();
    // mapOverlay.setStyle({opacity:"1"});
    
    var scrollPositionY =  window.pageYOffset
                        || document.documentElement.scrollTop
                        || document.body.scrollTop
                        || 0;
    var marginTop = scrollPositionY + 90;
    $('map_overlay').setStyle({ top:marginTop+'px' });
    googleMapInitialize();
    hideGArrow();
    $('map_background').observe("click", bodyClick);
  }
}

function hideGArrow() {
  var GArrows = $$('img[src="http://maps.gstatic.com/intl/en_us/mapfiles/iw_close.gif"]');
  
  if (GArrows.size() > 0) {
    GArrows.invoke('remove');
  }
  else setTimeout(hideGArrow, 250);
}

function hideMap() {
  // $('map_overlay').fade();
  $('map_global').hide();
}

function bodyClick(event) {
  var el = event.element();
  
  var clickInsideMap = el.match('#map_overlay') || el.up('#map_overlay');
  if (!clickInsideMap) {
    hideMap();
    $('map_background').stopObserving("click", bodyClick);
    event.stop();
  }
}

function ddd(){console.log.apply(console, arguments);}