var Sublime = {};

var sublimeVideo;
document.observe("dom:loaded", function() {
  sublimeVideo = new Sublime.Video();
});

Sublime.Video = Class.create({
  initialize: function() {
    if (Prototype.Browser.MobileSafari) {
      this.prepareSublimeVideosMobileSafari();
    }
    else {
      this.webKitTransitionSupported = (typeof WebKitTransitionEvent === "object" || typeof WebKitTransitionEvent === "function");
      this.html5VideoSupported = (typeof HTMLVideoElement === "object" || typeof HTMLVideoElement === "function");
      
      this.fullwindowTransitionDuration = 0.5;
      this.videoWebkitTransitionValue = this.fullwindowTransitionDuration+"s -webkit-transform";
      
      this.prepareSublimeVideos(this.html5VideoSupported);
      
      this.fwKeydownListener = this.fullWindowKeyDown.bind(this);
      this.fwMouseMoveListener = this.fullWindowMouseMove.bind(this);
      this.globalKeyDownListener = this.globalKeyDown.bind(this);
      this.globalKeyUpListener = this.globalKeyUp.bind(this);
    }
  },
  showScrollbars: function() {
    $(document.body).setStyle({ overflow:'auto' });
  },
  hideScrollbars: function() {
    $(document.body).setStyle({ overflow:'hidden' });
  },
  globalKeyDown: function(event) {
    switch(event.keyCode) {
      case 18: // Alt key
        if (this.isFullScreenSupported(this.video)) {
          $$(".sublime_video_wrapper .fullwindow_button").invoke("addClassName","fullscreen");
        }
        break;
    }
  },
  globalKeyUp: function(event) {
    switch(event.keyCode) {
      case 18: // Alt key
        if (this.isFullScreenSupported(this.video)) {
          $$(".sublime_video_wrapper .fullwindow_button").invoke("removeClassName","fullscreen");
        }
        break;
    }
  },
  isHtml5InputSupported: function(inputType) {
    var i = document.createElement("input");
    i.setAttribute("type", inputType);
    return i.type !== "text";
  },
  isFullScreenSupported: function(video) {
    // todo: update to add other browsers compatibility (when thye add this feature)
    return video.webkitSupportsFullscreen ? true : false;
  },
  prepareSublimeVideosMobileSafari: function() {
    // iPad MobileSafari needs the "controls" attribute inside the <video> tag, 
    // and I can't just set this attribute I actually have to recreated a new video element
    
    var supportedExtensionsRegexp = /.mp4$|.m4v$|.mov$/;
    var supportedSuffixesRegexp = /_iphone.mp4$|_iphone.m4v$|_iphone.mov$/;
    $$("video.sublime").each(function(originalVideoTag, index) {
      // look for iPhone/iPad compatible <source>'s src
      
      var iphoneSrc = null;
      var sources = originalVideoTag.select('source');
      // First, we look for a <source> with a src ending with "_iphone.xxx"... 
      sources.each(function(source){
        var src = source.readAttribute('title');
        if (supportedSuffixesRegexp.test(src)) {
          iphoneSrc = src;
        }
      });
      // ...if we don't find it, we'll take the first .mp4, .m4v or .mov
      if (!iphoneSrc) {
        // ddd("couldn't find src ending with '_iphone.xxx'");
        sources.each(function(source){
          var src = source.readAttribute('title');
          if (supportedExtensionsRegexp.test(src)) {
            iphoneSrc = src;
          }
        });
      }
      
      // at this point, if iphoneSrc is still null, it means no iPhone/iPad compatible video was found 
      // => MobileSafari will show the play button with a stroke (unclickable)
      var newVideo = new Element("video", {
        width: originalVideoTag.readAttribute('width'),
        height: originalVideoTag.readAttribute('height'),
        poster: originalVideoTag.readAttribute('poster'),
        src: iphoneSrc,
        controls: "controls"
      });
      
      originalVideoTag.insert({before:newVideo});
      originalVideoTag.remove();
    });
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
        playButton = new Element("span", {'class':'play_button'}).observe("click", this.loadVideo.bindAsEventListener(this, wrapperId));
      }
      else {
        playButton = new Element("div", { 'class':'unsupported' }).insert(new Element('p').update("browser not supported")); //unsupported div
      }
      
      wrapper.insert(img).insert(playButton);
      video.insert({before:wrapper});
    }.bind(this));
  },
  unloadVideo: function() {
    // Stop observers
    this.video.stopObserving("loadedmetadata");
    this.video.stopObserving("load");
    this.video.stopObserving("progress");
    this.video.stopObserving("play");
    this.video.stopObserving("pause");
    this.video.stopObserving("timeupdate");
    this.video.stopObserving("ratechange");
    this.video.stopObserving("ended");
    
    if (this.progressSliderForAntiqueBrowsers) {
      this.progressSliderForAntiqueBrowsers.dispose();
    }
    
    this.controls.down(".progress_indicator").stopObserving("change").remove();
    this.controls.down(".fullwindow_button").stopObserving("click").remove();
    this.controls.down(".play_pause_button").stopObserving("click").remove();
    if (this.controls.down('.playback_display')) {
      this.controls.down(".fast_backward").stopObserving("click").remove();
      this.controls.down(".fast_forward").stopObserving("click").remove();
    }
    this.controls.remove();
    
    document.stopObserving("keydown", this.globalKeyDownListener);
    document.stopObserving("keyup", this.globalKeyUpListener);
    
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
  loadVideo: function(event, wrapperId) {
    event.stop();
    
    if (this.video) {
      this.unloadVideo();
    }
    
    this.mode = "normal"; // can be "normal" or "fullwindow"
    
    // ============================
    // = Create new video element =
    // ============================
    var videoWrapper = $(wrapperId);
    var originalVideoTag = videoWrapper.next('video');
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
    
    // ===================================
    // = Add new <video> to DOM (hidden) =
    // ===================================
    this.video.hide();
    videoWrapper.addClassName('playing').insert(this.video);
    
    // ============================================================
    // = Show Sublime Spinner and observer <video> loadedmetadata =
    // ============================================================
    // Hide play button
    this.video.previous('.play_button').hide();
    
    // Sublime Spinner
    this.sublimeSpinner = new Sublime.SquareSpinner(videoWrapper, videoWrapper.getWidth(), videoWrapper.getHeight());
    this.sublimeSpinner.showAfterDelayOf(300);
    
    // observe loadedmetadata
    this.video.observe("loadedmetadata", function(event) {
      this.finishLoadingVideo();
    }.bind(this));
  },
  finishLoadingVideo: function() {
    // ==================================
    // = Create Sublime custom controls =
    // ==================================
    
    // Progress bar
    var progressBar = new Element("div", { 'class':'progress_bar' }).setStyle({ width:this.video.width-40+'px' });
    var elapsedTime = new Element("em", { 'class':'elapsed_time' }).update("00:00");
    var remainingTime = new Element("em", { 'class':'remaining_time' }).update("00:00");
    var progressBarBackground = new Element("div", { 'class':'progress_back' });
    var progressBarBuffered = new Element("div", { 'class':'progress_buffered' });
    this.progressBarElapsedTime = new Element("div", { 'class':'progress_elapsed_time' });
    
    var progressBarIndicator;
    this.sliderMaxValue = Math.max(this.video.width, 200); 
    // we choose this 'cause as fixed reference for both sliders (small and fullwindow) 
    // and 'cause we know the progressbar will in most cases be > than this, otherwise (for really small videos) we set it to 200 (which is ~ the width of the progressbar in fullwindow mode)
    if (this.isHtml5InputSupported("range")) {
      progressBarIndicator = new Element("input", { 'class':'progress_indicator', type:'range', min:0, max:this.sliderMaxValue, value:0 }); //max value will be set to progressBarBackground's width (and I'll have to do this later)
      this.progressSliderForModernBrowsers = progressBarIndicator;
    }
    else { // Firefox currently doesn't support input tag of type "range" => for such browsers we'll use a javascript slider
      progressBarIndicator = new Element('span', { 'class':'progress_indicator' });
      this.progressSliderForAntiqueBrowsers = true;
    }
    
    progressBarBackground.insert(progressBarBuffered).insert(this.progressBarElapsedTime).insert(progressBarIndicator);
    progressBar.insert(elapsedTime).insert(progressBarBackground).insert(remainingTime);
    
    // Fullscreen button
    var fullWindowButtonClass = this.isFullScreenSupported(this.video) ? 'fullwindow_button supports_fullscreen' : 'fullwindow_button';
    var fullWindowButton = new Element("span", { 'class':fullWindowButtonClass }).observe("click", function(event){
      if (this.controls.hasClassName('small')) {
        this.enterFullWindow(event);
      }
      else {
        this.exitFullWindow(event);
      }
    }.bind(this));
    
    // Play button
    var playPauseButton = new Element("span", { 'class':'play_pause_button' }).observe("click", this.playPause.bind(this));
    this.hasAlreadyClickedPlayPause = false;
    
    // =======================================
    // = Show video and add Sublime controls =
    // =======================================
    this.controls = new Element("div", { 'class':'controls small' });
    this.controls.insert(playPauseButton).insert(progressBar).insert(fullWindowButton);
    this.video.show();
    this.video.up().insert(this.controls);
    
    // I couldn't do this before because I can't get the width until the element is in the DOM)
    this.progressBarWidths = { 
      normal:progressBarBackground.getWidth(),
      fullwindow: 202
    }; // it'll be used to precisely compute the progress elapsed bar
    
    // Hide poster (Sublime Spinner continue to animate...)
    this.video.previous('img').hide();
    
    // setup progress bar "slider"
    if (this.progressSliderForAntiqueBrowsers) {
      this.progressSliderForAntiqueBrowsers = new Sublime.Slider(progressBarIndicator, progressBarBackground, {
        range: $R(0, this.sliderMaxValue),
        onSlide: function(value) {
          // do not "live update" the video (just the progress UI) => we do not set this.video.currentTime = newTime;
          var newTime = this.video.duration * value/this.sliderMaxValue;
          elapsedTime.update(this.secondsToTime(newTime));
          remainingTime.update('-'+this.secondsToTime(this.video.duration-newTime));
          this.updateProgressBarElapsedTime(newTime);
        }.bind(this),
        onChange: function(value) { 
          var newTime = this.video.duration * value/this.sliderMaxValue;
          this.video.currentTime = newTime;
          this.updateProgressBarElapsedTime(newTime);
          
          this.antiqueSliderJustChangedTo = newTime;
        }.bind(this)
      });
    }
    else {
      progressBarIndicator.observe("change", function(event){
        var newTime = this.video.duration * progressBarIndicator.value/this.sliderMaxValue;
        if (newTime < 0) {
          newTime = 0;
        }
        else if (newTime > this.video.duration) {
          newTime = this.video.duration;
        }
        this.video.currentTime = newTime;
      }.bind(this));
    }
    
    // WORKAROUND to make Chrome start playing after loadedmetadata
    if (this.video.buffered) { //firefox didn't implement the buffered attribute
      this.tryPlaying();
      progressBarBuffered.setStyle({ width:(this.video.buffered.end(0)/this.video.duration)*100+'%' });
    }
    
    // =====================
    // = <video> observers =
    // =====================
    
    // Play Observer
    this.video.observe("play", function(event){
      playPauseButton.addClassName('pause');
      
      // Let's hide the Sublime Spinner only when the video really starts playing
      this.sublimeSpinner.hide();
    }.bind(this));
    
    // Pause Observer
    this.video.observe("pause", function(event){
      playPauseButton.removeClassName('pause');
      var playbackDisplay = this.video.next().down('.playback_display');
      if (playbackDisplay) playbackDisplay.setOpacity(0);
    }.bind(this));
    
    this.video.observe("load", function(event) {
      // Note: apparently this is not fired by Chrome
      //
      // Confirmed on this thread: http://code.google.com/p/chromium/issues/detail?id=19923
      // "<video> in chromium will not fire "load" event because we don't have disk cache to support it.
      // For now since we don't cache everything (we only cache a portion of the file in memory), we never will be "loaded"."
      // => shame!!
      if (this.video.buffered && this.video.buffered.length > 0) { // because this method is also called once even if the video is NOT fully loaded
        progressBarBuffered.setStyle({ width:'100%' });
      }
    }.bind(this));
    
    // this.video.observe("loadedmetadata", function(event) {
    //   if (this.video.buffered) { //firefox didn't implement the buffered attribute
    //     this.tryPlaying();
    //     progressBarBuffered.setStyle({ width:(this.video.buffered.end(0)/this.video.duration)*100+'%' });
    //   }
    // }.bind(this));
    
    // Buffered Time Observer
    this.video.observe("progress", function(event){
      this.tryPlaying();
      if (this.video.buffered) { // Safar/Chrome
        progressBarBuffered.setStyle({ width:(this.video.buffered.end(0)/this.video.duration)*100+'%' });
      }
      else if (event.lengthComputable && event.total) {
        // progressBarBuffered.setStyle({ width:parseInt( (event.loaded/event.total)*100, 10 ) +'%' });
        progressBarBuffered.setStyle({ width:(event.loaded/event.total)*100 +'%' });
      }
    }.bind(this));
    
    // Elapsed Time Observer
    this.video.observe("timeupdate", function(event){
      if (this.progressSliderForAntiqueBrowsers && !this.progressSliderForAntiqueBrowsers.dragging) {
        if (this.antiqueSliderJustChangedTo && Math.abs(this.video.currentTime - this.antiqueSliderJustChangedTo) > 0.5) {
          // workaround (on antique browsers like Firefox) to avoid jumps in elapsed progress when clicking the progress bar to jump forward or backward
          this.antiqueSliderJustChangedTo = null;
        }
        else {
          elapsedTime.update(this.secondsToTime(this.video.currentTime));
          remainingTime.update('-'+this.secondsToTime(this.video.duration-this.video.currentTime));
          this.updateProgressBarElapsedTime();
          this.updateProgressBarIndicator();
        }
      }
      
      // on browsers that don't support input range (like Firefox), do not "live update" the video while dragging
      if (this.progressSliderForModernBrowsers) {
        elapsedTime.update(this.secondsToTime(this.video.currentTime));
        remainingTime.update('-'+this.secondsToTime(this.video.duration-this.video.currentTime));
        this.updateProgressBarElapsedTime();
        this.updateProgressBarIndicator();
      }
      
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
    
    // ====================
    // = Global observers =
    // ====================
    document.observe("keydown", this.globalKeyDownListener);
    document.observe("keyup", this.globalKeyUpListener);
  },
  updateProgressBarIndicator: function() {
    var newValue = (this.video.currentTime/this.video.duration)*this.sliderMaxValue;
    if (this.progressSliderForAntiqueBrowsers) {
      this.progressSliderForAntiqueBrowsers.setValueBase(newValue); // set slider value without firing change
    }
    else {
      this.progressSliderForModernBrowsers.value = newValue;
    }
  },
  updateProgressBarElapsedTime: function(time) { //time is optional, but on Firefox it's a good idea to pass it to speed up the update
    this.progressBarElapsedTime.setStyle({ 
      // width:(this.video.currentTime/this.video.duration)*100+'%'
      width:this.computeElapsedTimePercentWidth(time)+'%'
    });
  },
  computeElapsedTimePercentWidth: function(time) {
    ///////////////
    // EQUATIONS //
    ///////////////
    // y = f(x) = Ax + B, where x = slider value (from 0 to MAX) and y = pixel width of elapsed progress,
    // A = ( (W-hWidth/2) - hWidth/2 )/MAX = (W - hWidth)/MAX  (hWidth is the width of the progressIndicator aka the slider handle, W is the width of the progressBarBackground)
    // B = hWidth/2
    // t = videoDuration*(x/MAX) => x = (t/videoDuration)*MAX
    // y [px] = f(t) = (W - hWidth)/MAX * (t/videoDuration)*MAX + hWidth/2 = ((W-hWidth)/videoDuration) t + hWidth/2
    // yp [%] = f(t) = y * 100/W
    // var hWidth = 10;
    var W = this.progressBarWidths[this.mode];
    var t = time || this.video.currentTime;
    return (((W-10)/this.video.duration) * t + 5)*(100/W);
  },
  tryPlaying: function() {
    // try force playing, if enough buffered (10secs)
    if (this.video.buffered && this.video.buffered.end(0) > 10 && !this.hasAlreadyClickedPlayPause) {
      this.hasAlreadyClickedPlayPause = true; //be sure this is called only once
      setTimeout(this.playPause.bind(this), 0);
      setTimeout(function(){
        this.video.play();
        if (this.video.up().hasClassName("paused")) this.video.up().removeClassName("paused");
      }.bind(this), 200);
    }
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
  isPlaybackRateSupported: function() {
    return Math.abs(sublimeVideo.video.playbackRate) > 0;
  },
  enterFullWindow: function(event) {
    event.stop();
    
    if (event.altKey) {
      if (this.isFullScreenSupported(this.video)) {
        this.video.webkitEnterFullScreen();
        // prepare/restore full-window button (for when existing full-screen)
        $$(".sublime_video_wrapper .fullwindow_button").invoke("removeClassName","fullscreen");
      }
    }
    else {
      // Immediately hide small controls
      this.controls.hide().setStyle({opacity:0});
      this.video.up().setStyle({ zIndex: '999999' }); //wrapper
      this.controls.removeClassName('small').addClassName('full');
      this.controls.down('.progress_bar').writeAttribute('style','');
      
      this.mode = "fullwindow";
      
      // Add fullwindow-specific controls (if not already done)
      if (!this.controls.retrieve('hasFullscreenControls')) {
        
        if (this.isPlaybackRateSupported()) {
          var fastBackward = new Element("span", { 'class':'fast_backward' }).observe("click", this.fastForward.bind(this));
          var fastForward = new Element("span", { 'class':'fast_forward' }).observe("click", this.fastBackward.bind(this));
          var playbackDisplay = new Element("span", { 'class':'playback_display ui-draggable' }).setOpacity(0);
          this.controls.insert(playbackDisplay).insert({top:fastForward}).insert({top:fastBackward});
        }
        
        this.controls.store("hasFullscreenControls", true);
      }
      
      // Make fullwindow controls pane draggable
      this.controlsDragger = new S2.UI.Behavior.TransformDrag(this.controls);
      
      this.hideScrollbars();
      
      // Enter fullwindow
      this.computeAndSetFullscreenWidth();
      
      // Observe browser's window resizing
      Event.observe(document.onresize ? document : window, "resize", this.computeAndSetFullscreenWidth.bind(this, true)); 
      // Observe keydown to play/pause and exit fullwindow
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
    
    if (this.progressSliderForAntiqueBrowsers) {
      this.progressSliderForAntiqueBrowsers.recomputeTrackLength();
      this.updateProgressBarIndicator();
    }
    
    // Fades-out controls after delay
    document.observe("mousemove", this.fwMouseMoveListener);
    this.pollingTime = 500;
    this.poller = setInterval(this.fullWindowPoll.bind(this), 500);
    this.mouseFrozenDuration = 0;
  },
  fullWindowMouseMove: function(event) {
    this.mousePosition = event.pointerY();
  },
  showControls: function() {
    this.updateProgressBarElapsedTime(); //to fix mini-pixel inconsistencies when switching from fullwindow to normal (while video is paused)
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
      MozTransform:'translate(0px,0px)',
      opacity:0,
      bottom:'0px'
    });
    this.controls.hide().removeClassName('full').addClassName('small');
    // this.controls.up().removeClassName('fullwindow');
    
    // stop controls dragger
    this.controlsDragger.destroy();
    
    this.mode = "normal";
    
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
    
    if (this.progressSliderForAntiqueBrowsers) {
      this.progressSliderForAntiqueBrowsers.recomputeTrackLength();
      this.updateProgressBarIndicator();
    }
  },
  fullWindowKeyDown: function(event) {
    switch(event.keyCode) {
      case Event.KEY_ESC: //27
        event.stop();
        this.exitFullWindow();
        break;
      case 32: //spacebar
        event.stop();
        this.playPause();
        break;
      // case Event.KEY_LEFT: //37
      //   this.fastBackward.bind(this);
      //   this.showControls();
      //   break;
      // case Event.KEY_RIGHT: //39
      //   this.fastForward.bind(this);
      //   this.showControls();
      //   break;
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
      // WORKAROUND for make the live fullwindow-resizing work
      //  on current Safari for Mac (v4.0.4)
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
    var h = Math.floor(secs / 3600);
    secs %= 3600;
    var m = Math.floor(secs / 60);
    var s = Math.floor(secs % 60);
    
    h = h>0 ? ( h<10 ? '0'+h : h )+':' : '';
    m = m>0 ? ( m<10 ? '0'+m : m )+':' : '00:';
    s = s>0 ? ( s<10 ? '0'+s : s ) : '00';
    
    return h+m+s;
    
    // OLD
    // var hours = Math.floor(secs / (60 * 60));
    // var minDivisor = secs % (60 * 60);
    // var minutes = Math.floor(minDivisor / 60);
    // var secDivisor = minDivisor % 60;
    // var seconds = Math.ceil(secDivisor);
    // if (minutes < 10) {
    //   minutes = "0" + minutes;
    // }
    // if (seconds < 10) {
    //   seconds = "0" + seconds;
    // }
    // return minutes + ":" + seconds;
  }
});

function ddd(){console.log.apply(console, arguments);}