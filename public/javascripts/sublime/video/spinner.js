if (!Sublime) var Sublime = {};

// Sublime.Spinner = Class.create({
//   initialize: function(container, width, height) {
//     this.container = container;
//     this.containerWidth = width;
//     this.containerHeight = height;
//     
//     this.options = {
//       color: "#000",
//       dotsColor: "#fff",
//       opacity: 0.7
//     };
//     
//   },
//   spinnerWidthFromSizeStep: function(size) {
//     var ref = 20; // the width (in pixels) of the smallest (size=1) spinner
//     var increaseRef = 12; // the number of pixels the width is increased for every step of size
//     
//     return ((size-1)*increaseRef) + ref;
//   },
//   adaptedSizeFactorForWidth: function(containerWidth) {
//     var size = parseInt(1+( containerWidth/8 -20)/12, 10); //I want the spinner width to be ~ 8 times smaller than containerWidth
//     return (size > 0) ? size : 1;
//   },
//   spinnerStyleFor: function(containerWidth, containerHeight) {
//     return this.spinnerStyleForSize(this.adaptedSizeFactorForWidth(this.containerWidth), this.containerWidth, this.containerHeight);
//   },
//   spinnerStyleForSize: function(size, containerWidth, containerHeight) {
//     // - size is an integer (>= 1)
//     // - containerWidth/Height are just use to position the spinner at the center of its container
//     
//     var width = this.spinnerWidthFromSizeStep(size);
//     // because of how the width value is computed, ALL the values below WILL BE INTEGER
//     
//     var height = width/2;
//     var radius = height/2;
//     
//     var top = (containerHeight-width/2)/2;
//     var left = (containerWidth-width)/2;
//     
//     var spinnerStyle = {
//       width: width+"px",
//       height: height+"px",
//       top: top+"px",
//       left: left+"px",
//       WebkitBorderRadius: radius+"px",
//       MozBorderRadius: radius+"px"
//     };
//     
//     var dotDiameter = (height+2)/3;
//     var dotRadius = dotDiameter/2;
//     var dotTop = dotDiameter-1;
//     
//     var dotStyle = {
//       top: dotTop+"px",
//       width: dotDiameter+"px",
//       height: dotDiameter+"px",
//       WebkitBorderRadius: dotRadius+"px",
//       MozBorderRadius: dotRadius+"px"
//     };
//     dotLeftPos = [dotTop+"px", (height-dotRadius)+"px", (width-dotDiameter-dotTop)+"px"];
//     
//     return { spinnerStyle:spinnerStyle, dotStyle:dotStyle, dotLeftPos:dotLeftPos };
//     
//     /////////////////////////////////////////////////
//     //// SPINNER STYLE
//     // switch (size) {
//     //   case 1:
//     //     style = {
//     //       width:"20px",
//     //       height:"10px",
//     //       WebkitBorderRadius:"5px",
//     //       MozBorderRadius:"5px"
//     //     };
//     //     break;
//     //   case 2:
//     //     style = {
//     //       width:"32px",
//     //       height:"16px",
//     //       WebkitBorderRadius:"8px",
//     //       MozBorderRadius:"8px"
//     //     };
//     //     break;
//     //   case 3:
//     //     style = {
//     //       width:"44px",
//     //       height:"22px",
//     //       WebkitBorderRadius:"11px",
//     //       MozBorderRadius:"11px"
//     //     };
//     //     break;
//     //   case 4:
//     //     style = {
//     //       width:"56px",
//     //       height:"28px",
//     //       WebkitBorderRadius:"14px",
//     //       MozBorderRadius:"14px"
//     //     };
//     //     break;
//     //   case 5:
//     //     style = {
//     //       width:"68px",
//     //       height:"34px",
//     //       WebkitBorderRadius:"17px",
//     //       MozBorderRadius:"17px"
//     //     };
//     //     break;
//     // }
//     /////////////////////////////////////////////////
//     //// SPINNER DOTS STYLE
//     // switch (size) {
//     //   case 1:
//     //     dotStyle = {
//     //       top:"3px",
//     //       width:"4px",
//     //       height:"4px",
//     //       WebkitBorderRadius:"2px",
//     //       MozBorderRadius:"2px"
//     //     };
//     //     dotLeftPos = ["3px", "8px", "13px"];
//     //     break;
//     //   case 2:
//     //     dotStyle = {
//     //       top:"5px",
//     //       width:"6px",
//     //       height:"6px",
//     //       WebkitBorderRadius:"3px",
//     //       MozBorderRadius:"3px"
//     //     };
//     //     dotLeftPos = ["5px", "13px", "21px"];
//     //     break;
//     //   case 3:
//     //     dotStyle = {
//     //       top:"7px",
//     //       width:"8px",
//     //       height:"8px",
//     //       WebkitBorderRadius:"4px",
//     //       MozBorderRadius:"4px"
//     //     };
//     //     dotLeftPos = ["7px", "18px", "29px"];
//     //     break;
//     //   case 4:
//     //     dotStyle = {
//     //       top:"9px",
//     //       width:"10px",
//     //       height:"10px",
//     //       WebkitBorderRadius:"5px",
//     //       MozBorderRadius:"5px"
//     //     };
//     //     dotLeftPos = ["9px", "23px", "37px"];
//     //     break;
//     //   case 5:
//     //     dotStyle = {
//     //       top:"11px",
//     //       width:"12px",
//     //       height:"12px",
//     //       WebkitBorderRadius:"5px",
//     //       MozBorderRadius:"5px"
//     //     };
//     //     dotLeftPos = ["11px", "27px", "43px"];
//     //     break;
//     // }
//   },
//   showAfterDelayOf: function(delay) {
//     this.showDelay = setTimeout(this.show.bind(this), delay || 0);
//   },
//   show: function() {
//     this.showDelay = null; //in case it was previously set by showAfterDelayOf
//     
//     var spinnerStyles = this.spinnerStyleFor();
//     var spinnerStyle = spinnerStyles.spinnerStyle;
//     var dotStyle = spinnerStyles.dotStyle;
//     var dotLeftPos = spinnerStyles.dotLeftPos;
//     
//     // If I would have put the style in a separated css file, I would set the .spinner class...
//     // var spinnerDiv = new Element("div", { 'class':'spinner' }).setStyle({
//     this.spinnerDiv = new Element("div").setStyle( Object.extend(
//       {
//         position:"absolute",
//         background: this.options.color,
//         opacity: this.options.opacity,
//         
//         top:"-40px",
//         left:"388px"
//       },
//       spinnerStyle )
//     );
//     
//     this.spinnerDotStyle = Object.extend(
//       {
//         position: "absolute",
//         background: this.options.dotsColor
//       },
//       dotStyle
//     );
//     
//     // If I would have put the style in a separated css file....
//     // var spinnerDot1 = new Element("div", { 'class':'spinner_dot one' });
//     // var spinnerDot2 = new Element("div", { 'class':'spinner_dot two' }).setOpacity(0);
//     // var spinnerDot3 = new Element("div", { 'class':'spinner_dot three' }).setOpacity(0);
//     var spinnerDot1 = new Element("div").setStyle( Object.extend({ left:dotLeftPos[0], opacity:1 }, this.spinnerDotStyle) );
//     var spinnerDot2 = new Element("div").setStyle( Object.extend({ left:dotLeftPos[1], opacity:0 }, this.spinnerDotStyle) );
//     var spinnerDot3 = new Element("div").setStyle( Object.extend({ left:dotLeftPos[2], opacity:0 }, this.spinnerDotStyle) );
//     this.spinnerDots = $A([spinnerDot1, spinnerDot2, spinnerDot3]);
//     
//     this.spinnerDiv.insert(spinnerDot1).insert(spinnerDot2).insert(spinnerDot3);
//     
//     this.thumbOrigDisplayProperty = this.container.getStyle("display");
//     this.container.setStyle({ display:"block" });
//     this.container.makePositioned().insert({ top:this.spinnerDiv });
//     this.container.store('hasShownSpinner', true);
//     
//     // Start animating
//     this.visibleDotIndex = 0;
//     this.interval = setInterval(this.iterateDots.bind(this), 200);
//   },
//   hide: function() {
//     if (this.showDelay) { //in case the spinner was set to show with showAfterDelayOf, but hide() has been called before the delay
//       clearTimeout(this.showDelay);
//     }
//     
//     if (this.container.retrieve('hasShownSpinner')) {
//       clearInterval(this.interval);
//       this.container.undoPositioned();
//       if (this.thumbOrigDisplayProperty) this.container.setStyle({ display:this.thumbOrigDisplayProperty });
//       // this.container.down().remove();
//       this.spinnerDiv.remove();
//       this.container.store('hasShownSpinner', false);
//     }
//   },
//   iterateDots: function() {
//     this.visibleDotIndex += 1;
//     if (this.visibleDotIndex > 2) this.visibleDotIndex = 0;
//     
//     // hide dots that needs to be hidden with a slight fade-out effect (on WebKit) to produce the "halo/glow" effect
//     setTimeout(function(){
//       this.spinnerDots.each(function(el, index){
//         if (index !== this.visibleDotIndex) {
//           el.setStyle({
//             WebkitTransition:"opacity 0.2s",
//             MozTransition:"opacity 0.2s",
//             opacity:0
//           });
//         }
//       });
//     }.bind(this), 0);
//     // to make the webkit transition work
//     
//     setTimeout(function(){
//       this.spinnerDots[this.visibleDotIndex].setStyle({
//         WebkitTransition:"none",
//         MozTransition:"none",
//         opacity:1
//       });
//     }.bind(this), 0);
//     
//     // // note, for browser that do not support webkit transitions, I could simply do:
//     // this.spinnerDots.invoke("setOpacity", 0);
//     // this.spinnerDots[this.visibleDotIndex].setOpacity(1);
//   }
// });

Sublime.SquareSpinner = Class.create({
  initialize: function(container, width, height) {
    this.container = container;
    this.containerWidth = width;
    this.containerHeight = height;
    
    this.options = {
      color: "#000",
      dotsColor: "#fff",
      opacity: 0.7
    };
    
  },
  spinnerWidthFromSizeStep: function(size) {
    var ref = 18; // the width (in pixels) of the smallest (size=1) spinner
    var increaseRef = 9; // the number of pixels the width is increased for every step of size
    
    return ((size-1)*increaseRef) + ref;
  },
  adaptedSizeFactorForWidth: function(containerWidth) {
    var size = parseInt(1+( containerWidth/10 -20)/12, 10); //I want the spinner width to be ~ 8 times smaller than containerWidth
    return (size > 0) ? size : 1;
  },
  spinnerStyleFor: function(containerWidth, containerHeight) {
    return this.spinnerStyleForSize(this.adaptedSizeFactorForWidth(this.containerWidth), this.containerWidth, this.containerHeight);
  },
  spinnerStyleForSize: function(size, containerWidth, containerHeight) {
    // - size is an integer (>= 1)
    // - containerWidth/Height are just use to position the spinner at the center of its container
    
    var width = this.spinnerWidthFromSizeStep(size);
    // because of how the width value is computed, ALL the values below WILL BE INTEGER
    
    var height = width;
    var radius = height/6;
    
    var top = (containerHeight-height)/2;
    var left = (containerWidth-width)/2;
    
    var spinnerStyle = {
      width: width+"px",
      height: height+"px",
      top: top+"px",
      left: left+"px",
      WebkitBorderRadius: radius+"px",
      MozBorderRadius: radius+"5px"
    };
    
    var dotDiameter = (size+1)*2;
    var dotRadius = dotDiameter/2;
    var dotPos1 = dotDiameter; // will be used as first top and left
    var dotPos2 = (size+1)*5; // will be used as second top and left
    
    var dotStyle = {
      width: dotDiameter+"px",
      height: dotDiameter+"px",
      WebkitBorderRadius: dotRadius+"px",
      MozBorderRadius: dotRadius+"px"
    };
    dotPos = [dotPos1+"px", dotPos2+"px"];
    
    return { spinnerStyle:spinnerStyle, dotStyle:dotStyle, dotPos:dotPos };
    
    /////////////////////////////////////////////////
    //// SPINNER STYLE
    // var spinnerStyle, dotStyle, dotPos;
    // switch (size) {
    //   case 1:
    //     spinnerStyle = {
    //       width:"18px",
    //       height:"18px",
    //       WebkitBorderRadius:"4px",
    //       MozBorderRadius:"4px"
    //     };
    //     break;
    //   case 2:
    //     spinnerStyle = {
    //       width:"27px",
    //       height:"27px",
    //       WebkitBorderRadius:"6px",
    //       MozBorderRadius:"6px"
    //     };
    //     break;
    //   case 3:
    //     spinnerStyle = {
    //       width:"36px",
    //       height:"36px",
    //       WebkitBorderRadius:"8px",
    //       MozBorderRadius:"8px"
    //     };
    //     break;
    //   case 4:
    //     spinnerStyle = {
    //       width:"45px",
    //       height:"45px",
    //       WebkitBorderRadius:"10px",
    //       MozBorderRadius:"10px"
    //     };
    //     break;
    //   case 5:
    //     spinnerStyle = {
    //       width:"54px",
    //       height:"54px",
    //       WebkitBorderRadius:"12px",
    //       MozBorderRadius:"12px"
    //     };
    //     break;
    // }
    /////////////////////////////////////////////////
    //// SPINNER DOTS STYLE
    // switch (size) {
    //   case 1:
    //     dotStyle = {
    //       width:"4px",
    //       height:"4px",
    //       WebkitBorderRadius:"2px",
    //       MozBorderRadius:"2px"
    //     };
    //     dotPos = ["4px", "10px"];
    //     break;
    //   case 2:
    //     dotStyle = {
    //       width:"6px",
    //       height:"6px",
    //       WebkitBorderRadius:"3px",
    //       MozBorderRadius:"3px"
    //     };
    //     dotPos = ["6px", "15px"];
    //     break;
    //   case 3:
    //     dotStyle = {
    //       width:"8px",
    //       height:"8px",
    //       WebkitBorderRadius:"4px",
    //       MozBorderRadius:"4px"
    //     };
    //     dotPos = ["8px", "20px"];
    //     break;
    //   case 4:
    //     dotStyle = {
    //       width:"10px",
    //       height:"10px",
    //       WebkitBorderRadius:"5px",
    //       MozBorderRadius:"5px"
    //     };
    //     dotPos = ["10px", "25px"];
    //     break;
    //   case 5:
    //     dotStyle = {
    //       width:"12px",
    //       height:"12px",
    //       WebkitBorderRadius:"6px",
    //       MozBorderRadius:"6px"
    //     };
    //     dotPos = ["12px", "30px"];
    //     break;
    // }
    // return { spinnerStyle:spinnerStyle, dotStyle:dotStyle, dotPos:dotPos };
  },
  showAfterDelayOf: function(delay) {
    this.showDelay = setTimeout(this.show.bind(this), delay || 0);
  },
  show: function() {
    this.showDelay = null; //in case it was previously set by showAfterDelayOf
    
    var spinnerStyles = this.spinnerStyleFor();
    var spinnerStyle = spinnerStyles.spinnerStyle;
    var dotStyle = spinnerStyles.dotStyle;
    var dotPos = spinnerStyles.dotPos;
    
    // If I would have put the style in a separated css file, I would set the .spinner class...
    // var spinnerDiv = new Element("div", { 'class':'spinner' }).setStyle({
    this.spinnerDiv = new Element("div").setStyle( Object.extend(
      {
        position:"absolute",
        background: this.options.color,
        opacity: this.options.opacity
      },
      spinnerStyle )
    );
    
    this.spinnerDotStyle = Object.extend(
      {
        position: "absolute",
        background: this.options.dotsColor
      },
      dotStyle
    );
    
    // If I would have put the style in a separated css file....
    // var spinnerDot1 = new Element("div", { 'class':'spinner_dot one' });
    // var spinnerDot2 = new Element("div", { 'class':'spinner_dot two' }).setOpacity(0);
    // var spinnerDot3 = new Element("div", { 'class':'spinner_dot three' }).setOpacity(0);
    var spinnerDot1 = new Element("div").setStyle( Object.extend({ top:dotPos[0], left:dotPos[0], opacity:1 }, this.spinnerDotStyle) );
    var spinnerDot2 = new Element("div").setStyle( Object.extend({ top:dotPos[0], left:dotPos[1], opacity:0 }, this.spinnerDotStyle) );
    var spinnerDot3 = new Element("div").setStyle( Object.extend({ top:dotPos[1], left:dotPos[0], opacity:0 }, this.spinnerDotStyle) );
    var spinnerDot4 = new Element("div").setStyle( Object.extend({ top:dotPos[1], left:dotPos[1], opacity:0 }, this.spinnerDotStyle) );
    this.spinnerDots = $A([spinnerDot1, spinnerDot2, spinnerDot3, spinnerDot4]);
    
    this.spinnerDiv.insert(spinnerDot1).insert(spinnerDot2).insert(spinnerDot3).insert(spinnerDot4);
    
    this.thumbOrigDisplayProperty = this.container.getStyle("display");
    this.container.setStyle({ display:"block" });
    this.container.makePositioned().insert({ top:this.spinnerDiv });
    this.container.store('hasShownSpinner', true);
    
    // Start animating
    this.visibleDotIndex = 0;
    this.interval = setInterval(this.iterateDots.bind(this), 200);
  },
  hide: function() {
    if (this.showDelay) { //in case the spinner was set to show with showAfterDelayOf, but hide() has been called before the delay
      clearTimeout(this.showDelay);
    }
    
    if (this.container.retrieve('hasShownSpinner')) {
      clearInterval(this.interval);
      this.container.undoPositioned();
      if (this.thumbOrigDisplayProperty) this.container.setStyle({ display:this.thumbOrigDisplayProperty });
      // this.container.down().remove();
      this.spinnerDiv.remove();
      this.container.store('hasShownSpinner', false);
    }
  },
  iterateDots: function() {
    this.visibleDotIndex += 1;
    if (this.visibleDotIndex > 3) this.visibleDotIndex = 0;
    
    // hide dots that needs to be hidden with a slight fade-out effect (on WebKit) to produce the "halo/glow" effect
    setTimeout(function(){
      this.spinnerDots.each(function(el, index){
        if (index !== this.visibleDotIndex) {
          el.setStyle({
            WebkitTransition:"opacity 0.2s",
            MozTransition:"opacity 0.2s",
            opacity:0
          });
        }
      });
    }.bind(this), 0);
    // to make the webkit transition work
    
    setTimeout(function(){
      this.spinnerDots[this.visibleDotIndex].setStyle({
        WebkitTransition:"none",
        MozTransition:"none",
        opacity:1
      });
    }.bind(this), 0);
    
    // // note, for browser that do not support webkit transitions, I could simply do:
    // this.spinnerDots.invoke("setOpacity", 0);
    // this.spinnerDots[this.visibleDotIndex].setOpacity(1);
  }
});
