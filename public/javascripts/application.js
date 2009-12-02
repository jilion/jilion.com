var imagesPreloader = null;

Element.addMethods({
  shake: function(element, options) {
    S2.Extensions.webkitCSSTransitions = false; //essential, cause webkit transitions in this case are less smooth
    
    var originalLeft = parseFloat(element.getStyle('left') || '0');
    var oldStyle = { left:originalLeft };
    element.makePositioned();
    
    var opts = { distance:15, duration:0.6 };
    Object.extend(opts, options);
    var distance = opts.distance;
    var duration = opts.duration;

    var split = parseFloat(duration) / 10.0;

    var shakeEffect = element.morph('left:' + (originalLeft+distance) + 'px', { duration:split 
      }).morph('left:' + (originalLeft-distance) + 'px', { duration:split*2
        }).morph('left:' + (originalLeft+distance) + 'px', { duration:split*2
          }).morph('left:' + (originalLeft-distance) + 'px', { duration:split*2
            }).morph('left:' + (originalLeft+distance) + 'px', { duration:split*2
              }).morph('left:' + (originalLeft) + 'px', { duration:split, after: function() {
                element.undoPositioned().setStyle(oldStyle);
                }});

    return shakeEffect;
  }
});

document.observe("dom:loaded", function() {
  // var imagesToPreload = ["/images/jilion.png", "/images/header_back.jpg"];
  // imagesPreloader = new ImagesPreloader(imagesToPreload, showHeader);
  
  //Google Map
  $('show_location').observe("click", showMap);
  var dropPin = new Image();
  dropPin.src = "/images/map_drop_pin.png";
  
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
    emailFlash.scrollTo();
    setTimeout(function(){ emailFlash.pulsate({pulses:3, duration:1.4}); }, 500);
    
    // if unsubscribed... make email_field re-appear ;-)
    if (emailFlash.hasClassName('unsubscribed')) {
      setTimeout(function(){ 
        emailFlash.fade({ afterFinish: function(){ $('new_subscriber').appear(); } });
      }, 3000);
    }
  }
});

function validateEmail(email) {
  return email.match(/^\s*([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*$/i);
}

function googleMapInitialize() {
  var myLatlng = new google.maps.LatLng(46.524638, 6.563698);
  // var cenLatlng = new google.maps.LatLng(46.525424, 6.56372);
  var cenLatlng = new google.maps.LatLng(46.524754, 6.563699);
  var myOptions = {
    zoom: 20,
    center: cenLatlng,
    mapTypeId: google.maps.MapTypeId.HYBRID
  };
  var map = new google.maps.Map(document.getElementById("map_wrap"), myOptions);

  var image = '/images/map_drop_pin.png';
  var marker = new google.maps.Marker({
      position: myLatlng, 
      map: map,
      title:"Jilion",
      icon: image
  });
  
  var contentString = '<div id="popbox">'+
      '<p><a href="http://is.gd/2mQ6V">Chemin de la Raye 13 <br />1024 Ecublens <br /> Switzerland</a></p>'+
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
    $('map_overlay').setStyle({top:window.scrollY+50+'px'});
    googleMapInitialize();
    hideGArrow();
    $('map_background').observe("click", bodyClick);
  }
}

function hideGArrow() {
  var gmPane = $$('#pane_6 div.gmnoprint');
  
  if (gmPane.size() > 0) {
    var gmnoprint = gmPane.first();
    var closeButton = Prototype.Browser.IE ? gmnoprint.select('img')[5] : gmnoprint.down('img');
    if (closeButton) {
      closeButton.remove();
      // do not loop anymore
    }
    else setTimeout(hideGArrow, 250);
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


// ====================
// = Images preloader =
// ====================
var ImagesPreloader = Class.create({
  initialize: function(images, callback) { 
    this.callback = callback || null;
    this.imagesSrc = images;
    
    this.loaded = 0;
    this.processed = 0;
    this.images = $A([]);
    this.nImages = this.imagesSrc.length;
    
    // ddd("Preloading "+this.nImages+" images...");
    for (var i = 0; i < this.nImages; i++) {
      this.preload(this.imagesSrc[i]);
    }
  },
  allLoaded: function() { //callback called when all images are loaded
    //ddd("All images loaded");
    if (this.callback) {
      this.callback();
    }
    else {
      alert('not calling callback');
    }
  },
  preload: function(imageSrc) {
    var oImage = new Image();
    this.images.push(oImage);
    
    // set up event handlers for the Image object
    oImage.onload = this.onload.bind(this);
    oImage.onerror = this.onerror.bind(this);
    oImage.onabort = this.onabort.bind(this);
    
    // assign the .src property of the Image object
    oImage.src = imageSrc;
    // ddd(oImage.complete) //true if already in browser's cache
  },
  onload: function() {
    this.loaded++;
    //ddd('image preloaded')
    this.onComplete();
  },
  onerror: function() {
    this.bError = true;
    // ddd('error preloading image');
    this.onComplete();
  },
  onabort: function() {
    this.bAbort = true;
    // ddd('abort preloading image');
    this.onComplete();
  },
  onComplete: function() {
     this.processed++;
     //ddd(this.processed)
     if (this.processed === this.nImages) {
        this.allLoaded();
     }
  }
});

function ddd(){console.log.apply(console, arguments);}
