package jilion.sublimevideo {
  import caurina.transitions.*; 
  import caurina.transitions.properties.FilterShortcuts;
  import flash.display.*;
  import flash.events.*;
  import flash.net.*;
  import flash.utils.*;
  import flash.text.*;
  import flash.geom.Rectangle;
  
  [Embed(systemFont="Helvetica Neue", fontName="HelveticaNeueBold", fontWeight="bold", advancedAntiAliasing="true", mimeType="application/x-font", unicodeRange="U+0030-U+003A,U+002D")]
  
  public class SublimeControls {
    public function SublimeControls(stage:Stage, ns:NetStream, vi:VideoInfo, wrapper:MovieClip) {
            
      var timerTextFormat:TextFormat = new TextFormat();
      timerTextFormat.color = 0xD5D5D5;
      timerTextFormat.font = "HelveticaNeueBold";
      timerTextFormat.size = 10;
      timerTextFormat.align = "center";
      
      videoElapsedTime = new TextField();
      videoElapsedTime.width = 46;
      videoElapsedTime.height = 16;
      videoElapsedTime.x = 19;
      videoElapsedTime.y = 5;
      videoElapsedTime.selectable = false;
      videoElapsedTime.embedFonts = true;
      videoElapsedTime.defaultTextFormat = timerTextFormat;
      videoElapsedTime.text = "00:00";
      wrapper.addChild(videoElapsedTime);

      videoRemainingTime = new TextField();
      videoRemainingTime.width = 46;
      videoRemainingTime.height = 16;
      videoRemainingTime.x = wrapper.width-66;
      videoRemainingTime.y = 5;
      videoRemainingTime.selectable = false;
      videoRemainingTime.embedFonts = true;
      videoRemainingTime.defaultTextFormat = timerTextFormat;
      videoRemainingTime.text = "00:00";
      wrapper.addChild(videoRemainingTime);
      
      videoProgressBarBackground = new ProgressBarBackground();
      videoProgressBarBackground.width = wrapper.width-132;
      videoProgressBarBackground.x = 66;
      videoProgressBarBackground.y = 9;
      wrapper.addChild(videoProgressBarBackground);
      
      videoProgressBarBuffered = new ProgressBarBuffered();
      videoProgressBarBuffered.width = 0;
      videoProgressBarBuffered.x = 66;
      videoProgressBarBuffered.y = 9;
      videoProgressBarBuffered.addEventListener(MouseEvent.MOUSE_DOWN, videoProgressBarDown);
      wrapper.addChild(videoProgressBarBuffered);

      videoProgressBarElapsedTime = new ProgressBarElapsedTime();
      videoProgressBarElapsedTime.width = 0;
      videoProgressBarElapsedTime.x = 66;
      videoProgressBarElapsedTime.y = 9;
      videoProgressBarElapsedTime.addEventListener(MouseEvent.MOUSE_DOWN, videoProgressBarDown);
      wrapper.addChild(videoProgressBarElapsedTime);

      progressBarIndicator = new ProgressBarIndicator();
      progressBarIndicator.x = 62;
      progressBarIndicator.y = 8;
      progressBarIndicator.visible = false;
      progressBarIndicator.addEventListener(MouseEvent.MOUSE_DOWN, videoScrubberDown);
      wrapper.addChild(progressBarIndicator);
      
      bounds = new Rectangle(66,8,videoProgressBarBackground.width-10,0);
      
      wrap = wrapper;
      netStream = ns;
      theStage = stage;
      
      videoInfo = vi;
      
      var newClient:Object = new Object();
      newClient.onMetaData = function(client:Object){
        videoInfo.setDuration(client.duration);
      };
      netStream.client = newClient;
    }
        
    public var netStream:NetStream;
    public var theStage:Stage;
    public var wrap:MovieClip;
    public var videoProgressBarBackground:ProgressBarBackground;
    public var videoProgressBarBuffered:ProgressBarBuffered;
    public var videoProgressBarElapsedTime:ProgressBarElapsedTime;
    public var videoRemainingTime:TextField;
    public var videoElapsedTime:TextField;
    public var progressBarIndicator:ProgressBarIndicator;

    public var videoInfo:VideoInfo;
    public var videoDuration:Number;

    public var videoInterval = setInterval(videoStatus, 100);
    public var amountLoaded:Number;
    public var bounds:Rectangle;
    public var scrubInterval;
    
    public function videoStatus():void {
      
      if (!videoDuration) {
        videoDuration = videoInfo.duration;
      }
      //trace(videoInfo.duration);
      amountLoaded = netStream.bytesLoaded / netStream.bytesTotal;

      videoElapsedTime.text = secondsToTime(netStream.time);
      videoRemainingTime.text = "-" + secondsToTime(videoDuration-netStream.time);
      
      //videoProgressBarBuffered.width = amountLoaded * videoProgressBarBackground.width;
      Tweener.addTween(videoProgressBarBuffered, { width:amountLoaded * videoProgressBarBackground.width, time:1 });

      var r:Number = netStream.time * (videoProgressBarBackground.width-10) / videoDuration;
      videoProgressBarElapsedTime.width = r + 5;
      if (r > 0) progressBarIndicator.x = r + 66;
    }
    
    public function videoScrubberDown(event:MouseEvent):void {
      clearInterval(videoInterval);  //  clear our videoInterval so we can scrub
      scrubInterval = setInterval(scrubTimeline, 10);  //  sets the scrubTimeline listener to update the video  
      progressBarIndicator.startDrag(false, bounds);  //  starts to drag the videoThumb within the bounds we set
      theStage.addEventListener(MouseEvent.MOUSE_UP, stopScrubbingVideo);  //  add listener to the stage to listen for when we release the mouse
    }
    
    public function stopScrubbingVideo(event:MouseEvent):void {  
      theStage.removeEventListener(MouseEvent.MOUSE_UP, stopScrubbingVideo);  // removes this listener when we release the mouse  
      clearInterval(scrubInterval);  //  clears the scrubInterval listener so the video will resume playback  
      videoInterval = setInterval(videoStatus, 100);  //  set the videoStatus interval to move the videoThumb with the video playback percentage  
      progressBarIndicator.stopDrag();  //  tells the videoThumb to stop draggin with our mouse  
    }
    
    public function scrubTimeline():void {
      netStream.seek(Math.floor((progressBarIndicator.x-66)*(videoDuration/(videoProgressBarBackground.width-10))));  //  seeks the video to the frame related to the videoThumb's x location on the scrubber track
      videoProgressBarElapsedTime.width = progressBarIndicator.x-61;
      videoElapsedTime.text = secondsToTime(netStream.time);
      videoRemainingTime.text = "-" + secondsToTime(videoDuration-netStream.time);
    }
    
    public function videoProgressBarDown(event:MouseEvent):void {
      var clickedPos:Number;
      if (wrap.x > 0) {
        clickedPos = theStage.mouseX-wrap.x-71;
      } else {
        clickedPos = theStage.mouseX-71;
      }
      
      var pos:Number;
      if (clickedPos < 5) {
        pos = 0;
      }
      else if (clickedPos > videoProgressBarBackground.width-5) {
        pos = videoProgressBarBackground.width-10;
      }
      else {
        pos = clickedPos-5;
      }
      progressBarIndicator.x = pos+71;
      scrubTimeline();
    }
    
    public function secondsToTime(secs):String {
      var secs:Number = secs;
      var h:Number = Math.floor(secs / 3600);
      secs = secs % (60 * 60);
      var m:Number = Math.floor(secs / 60);
      var s:Number = Math.floor(secs % 60);

      var hString:String = String(h);
      var mString:String = String(m);
      var sString:String = String(s);
      hString = h>0 ? ( h<10 ? '0'+hString : hString )+':' : '';
      mString = m>0 ? ( m<10 ? '0'+mString : mString )+':' : '00:';
      sString = s>0 ? ( s<10 ? '0'+sString : sString ) : '00';

      return hString+mString+sString;
    }
    
  }
}
