var sublimeVideo;
document.observe("dom:loaded", function() {
 sublimeVideo = new SublimeVideo();
});

// TODOs
// - MobileSafari support / Directly show video tag and bypass observers
// - improve secondsToTime to support hours
 
var SublimeVideo = Class.create({
  initialize: function() {
    
    this.webKitTransitionSupported = (typeof WebKitTransitionEvent === "object" || typeof WebKitTransitionEvent === "function");
    this.fullwindowTransitionDuration = 0.5;
    
    if (Prototype.Browser.MobileSafari) {
      this.prepareSublimeVideosMobileSafari();
    }
    else {
      // this.prepareSublimeVideos(Prototype.Browser.WebKit);
      
      //better: (to be sure it won't work if FF users simply change the user agent to webkit)
      this.prepareSublimeVideos(this.webKitTransitionSupported);
    }
  },
  showScrollbars: function() {
    $(document.body).setStyle({ overflow:'auto' });
  },
  hideScrollbars: function() {
    $(document.body).setStyle({ overflow:'hidden' });
  },
  prepareSublimeVideosMobileSafari: function() {
    $$("video.sublime source").each(function(source, index) {
      source.up().writeAttribute({ src: source.readAttribute('title').replace('.mp4', '_iphone.mp4') });
      source.remove();
    }.bind(this));
  },
  prepareSublimeVideos: function(supportedBrowser) {
    $$("video.sublime").each(function(video, index){
      video.hide();
      
      var wrapperId = 'sublime_video_wrapper_'+index;
      
      var wrapper = new Element("div", { 'class':'sublime_video_wrapper', id:wrapperId }).setStyle({ 
        width:video.readAttribute('width')+"px",
        height:video.readAttribute('height')+"px"
      });
      var img = new Element("img", { src:video.readAttribute('poster'), width:video.readAttribute('width'), height:video.readAttribute('height') });
      
      var playButton;
      if (supportedBrowser) {
        playButton = new Element("span", {'class':'play_button'}).observe("click", this.showVideo.bindAsEventListener(this, wrapperId));
      }
      else {
        playButton = new Element("div", { 'class':'unsupported' }).insert(new Element('p').update("browser not supported")); //unsupported div
      }
      
      wrapper.insert(img).insert(playButton);
      video.insert({before:wrapper});
    }.bind(this));
  },
  unlooadVideo: function() {
    // Stop observers
    this.video.stopObserving("load");
    this.video.stopObserving("progress");
    this.video.stopObserving("play");
    this.video.stopObserving("pause");
    this.video.stopObserving("timeupdate");
    this.video.stopObserving("ratechange");
    this.video.stopObserving("ended");
    this.controls.down(".progress_indicator").stopObserving("change").remove();
    this.controls.down(".fullscreen_button").stopObserving("click").remove();
    this.controls.down(".play_pause_button").stopObserving("click").remove();
    if (this.controls.down('.playback_display')) {
      this.controls.down(".fast_backward").stopObserving("click").remove();
      this.controls.down(".fast_forward").stopObserving("click").remove();
    }
    this.controls.remove();
    
    var wrapper = this.video.up();
    this.video.removeAttribute("style");
    this.video.removeAttribute("autoplay");
    this.video.hide();
    this.video.addClassName("sublime_zoom");
    this.video.select("source").each(function(source){
      source.writeAttribute({
        title: source.readAttribute('src'),
        src: ""
      });
    });
    wrapper.insert({ after: this.video });
    
    // show poster and play button
    wrapper.removeClassName("playing");
    wrapper.down('img').show();
    wrapper.down('.play_button').show();
    
    this.video = null;
  },
  showVideo: function(event, wrapperId) {
    event.stop();
    
    if (this.video) {
      this.unlooadVideo();
    }
    
    this.videoWebkitTransitionValue = this.fullwindowTransitionDuration+"s -webkit-transform";
    
    // Create new video element
    var originalVideoTag = $(wrapperId).next('video');
    
    this.video = new Element("video", {
      width: originalVideoTag.readAttribute('width'), 
      height: originalVideoTag.readAttribute('height'),
      autoplay: 'autoplay',
      poster: originalVideoTag.readAttribute('poster')
      // controls: 'controls'
    }).setStyle({
      position: "relative",
      top: 0,
      left: 0
      // zIndex: 2
      // WebkitTransition: this.videoWebkitTransitionValue
    });
    
    // Clone original sources to new video element
    originalVideoTag.select('source').each(function(source){
      source.writeAttribute({
        src: source.readAttribute('title'),
        title: ""
      });
      this.video.insert(source);
    }.bind(this));
    originalVideoTag.remove();
    
    // ===========================
    // = Create sublime controls =
    // ===========================
    
    // Progress bar
    var progressBar = new Element("div", { 'class':'progress_bar' }).setStyle({ width:this.video.width-40+'px' });
    var elapsedTime = new Element("em", { 'class':'elapsed_time' }).update("00:00");
    var progressBarBackWrap = new Element("div", { 'class':'progress_back_wrap' });
    var progressBarBackground = new Element("div", { 'class':'progress_back' });
    var progressBarBuffered = new Element("div", { 'class':'progress_buffered' });
    var progressBarElapsedTime = new Element("div", { 'class':'progress_elapsed_time' });
    var progressBarIndicator = new Element("input", { 'class':'progress_indicator', type:'range', min:0, max:this.video.width, value:0 }).observe("change", function(event){
      var newTime = this.video.duration * progressBarIndicator.value/this.video.width;
      if (newTime < 0) {
        newTime = 0;
      }
      else if (newTime > this.video.duration) {
        newTime = this.video.duration;
      }
      // NO!!
      // else if (newTime > this.video.buffered.end(0)) {
      //   newTime = this.video.buffered.end(0);
      // }
      this.video.currentTime = newTime;
    }.bind(this));
    progressBarBackground.insert(progressBarBuffered).insert(progressBarElapsedTime).insert(progressBarIndicator);
    progressBarBackWrap.insert(progressBarBackground);
    var remainingTime = new Element("em", { 'class':'remaining_time' }).update("00:00");
    
    progressBar.insert(elapsedTime).insert(progressBarBackWrap).insert(remainingTime);
    
    // Fullscreen button
    var fullScreenButton = new Element("span", { 'class':'fullscreen_button' }).observe("click", function(event){
      if (this.controls.hasClassName('small')) {
        this.enterFullWindow(event);
      }
      else {
        this.exitFullWindow(event);
      }
    }.bind(this));
    
    // Play button
    var playPauseButton = new Element("span", { 'class':'play_pause_button pause' }).observe("click", this.playPause.bind(this));
    this.hasAlreadyClickedPlayPause = false;
    
    // Show new video element with sublime controls
    this.controls = new Element("div", { 'class':'controls small' });
    this.controls.insert(playPauseButton).insert(progressBar).insert(fullScreenButton);
    // controlsWrapper.insert(this.controls);
    $(wrapperId).addClassName('playing').insert(this.video).insert(this.controls);
    
    // Hide poster
    // this.video.previous('img').setStyle({ visibility : 'hidden' }); 
    this.video.previous('img').hide();
    this.video.previous('.play_button').hide();
    
    // var fullscreenButtonX = (this.video.cumulativeOffset().left + this.video.width)-21;
    // var fullscreenButtonY = (this.video.cumulativeOffset().top + this.video.height)-21;
    // var style = new Element("style", {'type':'text/css'}).update('#'+$(wrapperId).id+' video::-webkit-media-controls-fullscreen-button{top:'+fullscreenButtonY+'px;left:'+fullscreenButtonX+'px}');
    // $(wrapperId).insert(style);
    
    // Buffered Time Observer
    this.video.observe("load", function(event){
      if (this.video.buffered.length === 1) { // because this method is also called once even if the video is NOT fully loaded
        progressBarBuffered.setStyle({ width:'100%' });
      }
    }.bind(this));
    this.video.observe("progress", function(event){
      // force playing if enough buffered (10secs)
      if (this.video.buffered.end(0) > 10 && !this.hasAlreadyClickedPlayPause) {
        setTimeout(this.playPause.bind(this), 0);
        setTimeout(this.playPause.bind(this), 200);
        setTimeout(this.playPause.bind(this), 400);
      }
      
      progressBarBuffered.setStyle({ width:(this.video.buffered.end(0)/this.video.duration)*100+'%' });
    }.bind(this));
    
    // Play Observer
    this.video.observe("play", function(event){
      playPauseButton.addClassName('pause');
    });
    
    // Pause Observer
    this.video.observe("pause", function(event){
      playPauseButton.removeClassName('pause');
      var playbackDisplay = this.video.next().down('.playback_display');
      if (playbackDisplay) playbackDisplay.setOpacity(0);
    }.bind(this));
        
    // Elapsed Time Observer
    this.video.observe("timeupdate", function(event){
      elapsedTime.update(this.secondsToTime(this.video.currentTime));
      progressBarElapsedTime.setStyle({ width:(this.video.currentTime/this.video.duration)*100+'%' });
      progressBarIndicator.value = (this.video.currentTime/this.video.duration)*this.video.width;
      remainingTime.update('-'+this.secondsToTime(this.video.duration-this.video.currentTime));
    }.bind(this));
    
    // Playback Rate Observer
    this.video.observe("ratechange", function(event){
      var playbackRateDisplay = this.video.next().down('.playback_display');
      if (this.video.playbackRate > 1 || this.video.playbackRate < -1) {
        playbackRateDisplay.setOpacity(1).update(Math.abs(this.video.playbackRate) + 'x');
      }
      else {
        playbackRateDisplay.setOpacity(0);
      }
    }.bind(this));
    
    // Video Ended Observer
    this.video.observe("ended", function(event){
      this.video.pause();
      if (playPauseButton.hasClassName('pause')) playPauseButton.removeClassName('pause');
      if (this.video.next(".controls").hasClassName('full')) this.exitFullWindow();
    }.bind(this));
    
    
    // document.observe("keydown", function(event){
    //   switch(event.keyCode) {
    //     case 18: //alt
    //       this.controls.setStyle({width:this.video.width-24 + 'px'});
    //       fullScreenButton.hide();
    //       break;
    //   }      
    // }.bind(this));
    // 
    // document.observe("keyup", function(event){
    //   switch(event.keyCode) {
    //     case 18: //alt
    //       this.controls.setStyle({width:'100%'});
    //       fullScreenButton.show();
    //       break;
    //   }      
    // }.bind(this));
    
    // For Firefox
    // var enterFullWindowButton = new Element("span", {'class':'enter_fullwindow_button'});
    // $(wrapperId).insert(enterFullWindowButton);
  },
  playPause: function() {
    this.hasAlreadyClickedPlayPause = true;
    if (this.video.ended) {
      this.video.currentTime = 0;
      this.video.play();
      if (this.video.up().hasClassName("paused")) this.video.up().removeClassName("paused");
    }
    else if (this.video.paused) {
      this.video.play();
      if (this.video.up().hasClassName("paused")) this.video.up().removeClassName("paused");
    }
    else {
      this.showControls();
      this.video.pause();
      this.video.up().addClassName("paused");
    }
  },
  fastForward: function() {
    if (this.video.paused) this.video.play();
    
    if (this.video.playbackRate < 0 && this.video.playbackRate > -8) {
      this.video.playbackRate = this.video.playbackRate/0.5;
    }
    else if (this.video.playbackRate == 1) {
      this.video.playbackRate = -2;
    }
    else if (this.video.playbackRate > 0) {
      this.video.playbackRate = this.video.playbackRate/2;
    }
  },
  fastBackward: function() {
    if (this.video.paused) this.video.play();
    
    if (this.video.playbackRate > 0 && this.video.playbackRate < 8) {
      this.video.playbackRate = this.video.playbackRate*2;
    }
    else if (this.video.playbackRate == -1) {
      this.video.playbackRate = 1;
    }
    else if (this.video.playbackRate < 0) {
      this.video.playbackRate = this.video.playbackRate*0.5;
    }
  },
  enterFullWindow: function(event) {
    event.stop();
    
    // if (fullscreen) {
    //   //TODO exit fullscreen
    // }
    
    if (event.altKey) {
      if (this.video.webkitSupportsFullscreen) {
        this.video.webkitEnterFullScreen();
      }
    }
    else {
      // Immediately hide small controls
      this.controls.hide().setStyle({opacity:0});
      this.video.up().setStyle({ zIndex: '999999' }); //wrapper
      this.controls.removeClassName('small').addClassName('full');
      this.controls.down('.progress_bar').writeAttribute('style','');
      
      // Add fullwindow-specific controls (if not already done)
      if (!this.controls.retrieve('hasFullscreenControls')) {
        var fastBackward = new Element("span", { 'class':'fast_backward' }).observe("click", this.fastForward.bind(this));
        var fastForward = new Element("span", { 'class':'fast_forward' }).observe("click", this.fastBackward.bind(this));
        var playbackDisplay = new Element("span", { 'class':'playback_display ui-draggable' }).setOpacity(0);
        this.controls.insert(playbackDisplay).insert({top:fastForward}).insert({top:fastBackward});
        
        this.controls.store("hasFullscreenControls", true);
      }
      
      // Make fullwindow controls pane draggable
      this.controlsDragger = new S2.UI.Behavior.WebkitTransformDrag(this.controls);
      
      this.hideScrollbars();
      
      // Enter fullwindow
      this.computeAndSetFullscreenWidth();
      
      // Observe browser's window resizing
      Event.observe(document.onresize ? document : window, "resize", this.computeAndSetFullscreenWidth.bind(this, true)); 
      // Observe keydown to play/pause and exit fullwindow
      this.fwKeydownListener = this.fullWindowKeyDown.bind(this);
      document.observe("keydown", this.fwKeydownListener);
      
      if (this.webKitTransitionSupported) {
        this.video.setStyle({ WebkitTransition: this.videoWebkitTransitionValue });
        
        // Observe webkit "scaling to fullwindow" transition end
        this.video.observe("webkitTransitionEnd", function(e){
          this.video.stopObserving("webkitTransitionEnd");
          // to remove the scaling transition during window resizing (when in fullwindow)
          this.video.setStyle({ WebkitTransition: 'none' });
          this.finishEnteringFullWindow();
        }.bind(this));
      }
      else {
        this.finishEnteringFullWindow();
      }
      
      this.showOverlay();
    }
  },
  finishEnteringFullWindow: function() { 
    this.showControls();
    this.controls.setStyle({bottom:'8%'});
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // WORKAROUND for make the live fullwindow-resizing work on current Safari for Mac (v4.0.4)
    // if (navigator.userAgent.indexOf("Macintosh") > -1 
    //     && navigator.userAgent.indexOf("532") === -1) { //but don't do this on WebKit nightly
    //   setTimeout(function(){
    //     this.video.setStyle({ position:"absolute" });
    //   }.bind(this),100);
    // }
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    // Fades-out controls after delay
    this.fwMouseMoveListener = this.fullWindowMouseMove.bind(this);
    document.observe("mousemove", this.fwMouseMoveListener);
    this.pollingTime = 500;
    this.poller = setInterval(this.fullWindowPoll.bind(this), 500);
    this.mouseFrozenDuration = 0;
  },
  fullWindowMouseMove: function(event) {
    this.mousePosition = event.pointerY();
  },
  showControls: function() {
    // Fade-in fullwindow controls
    this.controls.show().morph('opacity:1', { duration: 0.5 });
  },
  hideFullControls: function() {
    this.controls.morph('opacity:0', { duration: 0.5 });
  },
  fullWindowPoll: function() {
    if (!this.video.paused) {
      if (this.latestPolledMousePosition === this.mousePosition) {
        this.mouseFrozenDuration += this.pollingTime;
      }
      else {
        this.mouseFrozenDuration = 0;
      }
      this.latestPolledMousePosition = this.mousePosition;
      
      if (this.mouseFrozenDuration > 3000) {
        if (!this.controlsDidHide) {
          this.hideFullControls();
          this.controlsDidHide = true;
          this.controlsDidShow = false;
        }
      }
      else {
        if (!this.controlsDidShow) {
          this.showControls();
          this.controlsDidShow = true;
          this.controlsDidHide = false;
        }
      }
    }
  },
  exitFullWindow: function(event) {
    // Stop observers & timers
    Event.stopObserving(document.onresize ? document : window, "resize"); 
    document.stopObserving("keydown", this.fwKeydownListener);
    document.stopObserving("mousemove", this.fwMouseMoveListener);
    clearInterval(this.poller);
    
    this.controls.setStyle({ 
      WebkitTransition: "none",
      WebkitTransform:'translate(0px,0px)',
      opacity:0,
      bottom:'0px'
    });
    this.controls.hide().removeClassName('full').addClassName('small');
    // this.controls.up().removeClassName('fullwindow');
    
    // stop controls dragger
    this.controlsDragger.destroy();
    
    this.video.next('.controls').down('.progress_bar').setStyle({ width:this.video.width-40+'px' });
    
    if (this.webKitTransitionSupported) {
      // the following line is for "security reasons" (in case the user immediately presses the Esc key WHILE the video was entering ENTERING fullwindow)
      this.video.stopObserving("webkitTransitionEnd");
      
      // Restore webkit transition 
      this.video.setStyle({ WebkitTransition: this.videoWebkitTransitionValue });
      this.video.observe("webkitTransitionEnd", function(e) {
        this.video.stopObserving("webkitTransitionEnd");
        this.finishExitingFullWindow();
      }.bind(this));
    }
    
    this.hideOverlay();
    
    this.video.setStyle({
      WebkitTransform: 'none',
      MozTransform: 'none'
    });
    
    if (!this.webKitTransitionSupported) {
      this.finishExitingFullWindow();
    }
  },
  finishExitingFullWindow: function() {
    // called at the end of the transition (for webkit)
    this.video.up().setStyle({ zIndex: "auto" });
    this.showControls();
    this.showScrollbars();
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // WORKAROUND for make the live fullwindow-resizing work on current Safari for Mac (v4.0.4)
    // if (navigator.userAgent.indexOf("Macintosh") > -1 
    //     && navigator.userAgent.indexOf("532") === -1) { //but don't do this on WebKit nightly
    //   setTimeout(function(){
    //     this.video.setStyle({ position:"relative" });
    //   }.bind(this),100);
    // }
    ////////////////////////////////////////////////////////////////////////////////////////////
  },
  fullWindowKeyDown: function(event) {
    switch(event.keyCode) {
      case 32: //spacebar
        this.playPause();
        break;
      case Event.KEY_ESC: //27
        this.exitFullWindow();
        event.stop();
        break;
    }
  },
  computeAndSetFullscreenWidth: function(isResizing) {
    var videoWidth = this.video.readAttribute("width");
    var videoHeight = this.video.readAttribute("height");
    var browserSize = document.viewport.getDimensions();
    var scrollOffset = document.viewport.getScrollOffsets();
    var videoOffset = this.video.cumulativeOffset();
    var aspectRatio = videoWidth/videoHeight;
    var aspectRatioBrowser = browserSize.width/browserSize.height;
    
    var scaleFactor;
    if (aspectRatio >= aspectRatioBrowser) {
      scaleFactor = browserSize.width / videoWidth;
    }
    else {
      scaleFactor = browserSize.height / videoHeight;
    }
    
    var videoTop = videoOffset.top - scrollOffset.top;
    var videoLeft = videoOffset.left - scrollOffset.left;
    
    //// Nope, I can't do this, 'cause I won't have the transformOrigin computed to properly exit fullwindow IF the browser window was resized while in fullwindow
    // if (isResizing) { //resizing browser's window
    //   translateX = ( browserSize.width/2 - (videoOffset.left + videoWidth/2) + scrollOffset.left) / scaleFactor;
    //   translateY = ( browserSize.height/2 - (videoOffset.top + videoHeight/2) + scrollOffset.top) / scaleFactor;
    //   transformOrigin = "50% 50%";
    // }
    // else { //entering/exiting fullScreen
    // ... so I have to keep computing the transformOrigin (event if I dont't use it while in fs) just to prepare the transform origin for the exit fs transition:
    
    if (isResizing) {
      ////////////////////////////////////////////////////////////////////////////////////////////
      // WORKAROUND for make the live fullwindow-resizing work on current Safari for Mac (v4.0.4)
      if (navigator.userAgent.indexOf("Macintosh") > -1 
          && navigator.userAgent.indexOf("532") === -1) { //but don't do this on WebKit nightly
        
        setTimeout(function(){
          this.video.setStyle({ position:"relative" });
        }.bind(this),10);
        
        setTimeout(function(){
          this.video.setStyle({ position:"absolute" });
        }.bind(this),20);
      }
      ////////////////////////////////////////////////////////////////////////////////////////////
    }
    
    var originPercentX = videoLeft / (browserSize.width - videoWidth);
    var originPercentY = videoTop / (browserSize.height - videoHeight);
    
    var initialOriginX = videoLeft + videoWidth*originPercentX;
    var initialOriginY = videoTop + videoHeight*originPercentY;
    
    var finalOriginX = (browserSize.width - videoWidth*scaleFactor)/2 + videoWidth*scaleFactor*originPercentX;
    var finalOriginY = (browserSize.height - videoHeight*scaleFactor)/2 + videoHeight*scaleFactor*originPercentY;
    
    var translateX = parseInt( (finalOriginX - initialOriginX) / scaleFactor, 10 );
    var translateY = parseInt( (finalOriginY - initialOriginY) / scaleFactor, 10 );
    
    var transformOrigin = (100*originPercentX)+"% "+(100*originPercentY)+"%";
    var transformValue = 'scale('+scaleFactor+') translate('+translateX+'px, '+translateY+'px)';
    
    this.video.setStyle({
      WebkitTransformOrigin: transformOrigin,
      MozTransformOrigin: transformOrigin,
      WebkitTransform: transformValue,
      MozTransform: transformValue
    });
  },
  showOverlay: function(sublime_video_wrapper) {
    if (!this.overlay) {
      this.opacityWebkitTransitionValue = this.fullwindowTransitionDuration+"s opacity";
      
      this.overlay = new Element("div").setStyle({
        position: "fixed",
        top: 0,
        left: 0,
        width: "100%",
        height: "100%",
        background: "#000",
        zIndex: 999998,
        opacity: 0
      });
    }
    
    this.overlay.setStyle({ WebkitTransition: this.opacityWebkitTransitionValue });
    
    $(document.body).insert(this.overlay);
    
    if (this.webKitTransitionSupported) {
      setTimeout(function(){
        this.overlay.setStyle({ opacity:1 });
      }.bind(this), 10);
    }
    else {
      this.overlay.setStyle({ opacity:1 });
    }
  },
  hideOverlay: function() {
    if (this.webKitTransitionSupported) {
      this.overlay.setStyle({ WebkitTransition: this.opacityWebkitTransitionValue });
      
      setTimeout(function(){
        this.overlay.setStyle({ opacity:0 });
      }.bind(this), 10);
      
      this.overlay.observe("webkitTransitionEnd", function(e){
        this.overlay.stopObserving("webkitTransitionEnd");
        this.overlay.setStyle({ WebkitTransition: "none" });
        this.overlay.remove();
      }.bind(this));
    }
    else {
      this.overlay.remove();
    }
  },
  secondsToTime: function(secs) {
    // TODO: improve this to support hours
    
    // var h = Math.floor(secs / 3600);
    // secs %= 3600;
    // var m = Math.floor(secs / 60);
    // var s = Math.floor(secs % 60);
    // 
    // h = h>0 ? ( h<10 ? '0'+h : h )+':' : '';
    // m = m>0 ? ( m<10 ? '0'+m : m )+':' : '';
    // s = s>0 ? ( s<10 ? '0'+s : s ) : '';
    // ddd(h+m+s)
    // return h+m+s;

    // OLD
    var hours = Math.floor(secs / (60 * 60));
    var minDivisor = secs % (60 * 60);
    var minutes = Math.floor(minDivisor / 60);
    var secDivisor = minDivisor % 60;
    var seconds = Math.ceil(secDivisor);
    if (minutes < 10) {
      minutes = "0" + minutes;
    }
    if (seconds < 10) {
      seconds = "0" + seconds;
    }
    return minutes + ":" + seconds;
  }
});

function ddd(){console.log.apply(console, arguments);}