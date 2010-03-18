package jilion.sublimevideo {
  import caurina.transitions.*; 
  import caurina.transitions.properties.FilterShortcuts;
  import flash.display.*;
  import flash.events.*;
  import flash.net.*;
  import flash.utils.*;
  import flash.text.*;
  import flash.geom.Rectangle;
  import flash.ui.Keyboard;
  import flash.ui.Mouse;
  import flash.external.ExternalInterface;

  public class FullControls extends SublimeControls {
    public function FullControls(stage:Stage, ns:NetStream, videoInfo:VideoInfo) {
      
      stage.addEventListener(KeyboardEvent.KEY_UP, function(keyEvent:KeyboardEvent){
        if (keyEvent.keyCode == Keyboard.ESCAPE) {
          closeFull(stage);
        }
      });
      
      fullControlsWrap = new FullControlsWrap();
      fullControlsWrap.alpha = 0;
      fullControlsWrap.width = 334;
      fullControlsWrap.height = 94;
      fullControlsWrap.x = (stage.stageWidth/2)-fullControlsWrap.width;
      fullControlsWrap.y = stage.stageHeight;
      fullControlsWrap.addEventListener(MouseEvent.MOUSE_DOWN, function (e:MouseEvent):void {
        if (e.eventPhase == 2) e.currentTarget.startDrag();
      });
      fullControlsWrap.addEventListener(MouseEvent.MOUSE_UP, function (e:MouseEvent):void {
        if (e.eventPhase == 2) e.currentTarget.stopDrag();
      });
      stage.addChild(fullControlsWrap);
      
      playBtn = new FullPlayButton();
      playBtn.x = 153;
      playBtn.y = 23;
      playBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
        playBtnClick();
      }); 
      fullControlsWrap.addChild(playBtn);
      
      pauseBtn = new FullPauseButton();
      pauseBtn.x = 156;
      pauseBtn.y = 23;
      pauseBtn.visible = false;
      pauseBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
        pauseBtnClick()
      });
      fullControlsWrap.addChild(pauseBtn);
      
      var fullCloseFullWindowAndFullScreenBtn:FullCloseFullWindowAndFullScreen = new FullCloseFullWindowAndFullScreen();
      fullCloseFullWindowAndFullScreenBtn.x = fullControlsWrap.width-fullCloseFullWindowAndFullScreenBtn.width-32;
      fullCloseFullWindowAndFullScreenBtn.y = 26;
      fullControlsWrap.addChild(fullCloseFullWindowAndFullScreenBtn);

      fullCloseFullWindowAndFullScreenBtn.addEventListener(MouseEvent.CLICK, function(event:MouseEvent){
        closeFull(stage);
      });
      
      super(stage, ns, videoInfo, fullControlsWrap);
      
      videoElapsedTime.x = 17;
      videoElapsedTime.y = fullControlsWrap.height-35;
      videoRemainingTime.x = (fullControlsWrap.width-videoRemainingTime.width)-17;
      videoRemainingTime.y = fullControlsWrap.height-35;
      videoProgressBarBackground.y = fullControlsWrap.height-31;
      videoProgressBarBuffered.y = fullControlsWrap.height-31;
      videoProgressBarElapsedTime.y = fullControlsWrap.height-31;
      progressBarIndicator.y = fullControlsWrap.height-32;
      bounds = new Rectangle(66,fullControlsWrap.height-32,videoProgressBarBackground.width-10,0);
    }
    
    public var playBtn:FullPlayButton;
    public var pauseBtn:FullPauseButton;
    public var fullControlsWrap:FullControlsWrap;
    public var normalControls:NormalControls;
    public var mousePosition:Number;
    public var poller;
    public var latestPolledMousePosition:Number;
    public var frozenDuration:Number = 0;
    
    public function setupPlayStartUI():void {  
      playBtn.visible = false;
      pauseBtn.visible = true;
      progressBarIndicator.visible = true;
    }
    
    public function videoEndReached():void {  
      netStream.pause();
      playBtn.visible = true;
      pauseBtn.visible = false;
    }
    
    public function setPlayPauseUI(playPause:Boolean):void {  
      // playPause == true => play, playPause == false => pause
      playBtn.visible = !playPause;
      pauseBtn.visible = playPause;
    }
    
    public function playBtnClick():void {
      netStream.resume();
      this.setPlayPauseUI(true);
      poller = setInterval(fullControlsPoll, 500);
      normalControls.setPlayPauseUI(true);
    }

    public function pauseBtnClick():void {
      netStream.pause();
      this.setPlayPauseUI(false);
      normalControls.setPlayPauseUI(false);
    }

    public function hide():void {
      Tweener.addTween(fullControlsWrap, { alpha:0, time:0.5 });
    }

    public function show(nc:NormalControls):void {
      if (!normalControls) {
        normalControls = nc;
      }
      
      fullControlsWrap.visible = true;
      fullControlsWrap.alpha = 1;
      
      theStage.addEventListener(KeyboardEvent.KEY_DOWN, spaceBarControls);
      theStage.addEventListener(MouseEvent.MOUSE_MOVE, setMousePosition);
      if (pauseBtn.visible == true) poller = setInterval(fullControlsPoll, 500);
    }
    
    public function closeFull(stage:Stage):void {
      frozenDuration = 0;
      fullControlsWrap.visible = false;
      if (stage.displayState == StageDisplayState.NORMAL) {
        ExternalInterface.call("exitSublimeVideoFullWindow()");
        Mouse.show();
      }
      else if (stage.displayState == StageDisplayState.FULL_SCREEN) {
        stage.displayState = StageDisplayState.NORMAL;
        Mouse.show();
      }
      normalControls.normalControlsBackground.visible = true;
      normalControls.wrapper.visible = true;
      theStage.removeEventListener(KeyboardEvent.KEY_DOWN, spaceBarControls);
      theStage.removeEventListener(MouseEvent.MOUSE_MOVE, setMousePosition);
      clearInterval(poller);
      normalControls.goToFullScreen = false;
      normalControls.isFullWindow = false;
    }
    
    public function spaceBarControls(keyEvent:KeyboardEvent):void {
      if (keyEvent.keyCode == 32) {
        if (playBtn.visible == true) {
          playBtnClick();
        } else {
          pauseBtnClick();
        }
      }
    }
    
    public function updateControlsPosition(stage:Stage) {
      var xValue = (stage.stageWidth-fullControlsWrap.width)/2;
      var yValue = stage.stageHeight-fullControlsWrap.height-80;
      if (xValue >= 0) {
        fullControlsWrap.x = xValue;
      } else {
        fullControlsWrap.x = 0;
      }
      if (yValue >= 0) {
        fullControlsWrap.y = yValue;
      } else {
        fullControlsWrap.y = 0;
      }
    }
    
    public function setMousePosition(event:MouseEvent):void {
      mousePosition = event.stageX*event.stageY;
    }
    
    public function fullControlsPoll():void {
      if (latestPolledMousePosition == mousePosition) {
        if (playBtn.visible == true) {
          clearInterval(poller);
          Tweener.addTween(fullControlsWrap, { alpha:1, time:0.5 });
        }
        frozenDuration += 500;
      } else {
        mousePosition = 0;
        latestPolledMousePosition = mousePosition;
        frozenDuration = 0;
        if (fullControlsWrap.alpha == 0) Tweener.addTween(fullControlsWrap, { alpha:1, time:0.5 });
        if (theStage.displayState == StageDisplayState.FULL_SCREEN) Mouse.show();
      }
      
      if (frozenDuration > 3000) { 
        if (pauseBtn.visible == true) {
          Tweener.addTween(fullControlsWrap, { alpha:0, time:0.5 });
          if (theStage.displayState == StageDisplayState.FULL_SCREEN) Mouse.hide();
        } else if (theStage.displayState == StageDisplayState.FULL_SCREEN) {
          Mouse.show();
        }
      }
    }
  }
}
