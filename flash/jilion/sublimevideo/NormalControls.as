package jilion.sublimevideo {
  import caurina.transitions.*; 
  import caurina.transitions.properties.FilterShortcuts;
  import flash.display.*;
  import flash.events.*;
  import flash.net.*;
  import flash.utils.*;
  import flash.text.*;
  import flash.ui.Keyboard;
  import flash.external.ExternalInterface;

  public class NormalControls extends SublimeControls {
    public function NormalControls(stage:Stage, ns:NetStream, videoInfo:VideoInfo, fc:FullControls) {
      
      normalControlsBackground = new NormalControlsBackground();
      normalControlsBackground.width = stage.stageWidth;
      normalControlsBackground.height = 25;
      normalControlsBackground.x = 0;
      normalControlsBackground.y = stage.stageHeight;
      stage.addChild(normalControlsBackground);
      
      wrapper = new MovieClip();
      wrapper.graphics.beginFill(0x000000,0);
      wrapper.graphics.drawRect(0, 0, stage.stageWidth, 25);
      wrapper.graphics.endFill();
      wrapper.x = 0;
      wrapper.y = stage.stageHeight-25;
      stage.addChild(wrapper);
      
      playBtn = new NormalPlayButton();
      playBtn.x = 6;
      playBtn.y = 7;
      playBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
        playBtnClick();
      }); 
      wrapper.addChild(playBtn);
      
      pauseBtn = new NormalPauseButton();
      pauseBtn.x = 5;
      pauseBtn.y = 7;
      pauseBtn.visible = false;
      pauseBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
        pauseBtnClick();
      });
      wrapper.addChild(pauseBtn);
      
      fullWindowAndFullScreenBtn = new NormalFullWindowandFullScreenButton();
      fullWindowAndFullScreenBtn.x = wrapper.width-21;
      fullWindowAndFullScreenBtn.y = 7;
      wrapper.addChild(fullWindowAndFullScreenBtn);
      
      ExternalInterface.addCallback( "togglefullWindowAndFullScreenBtn", togglefullWindowAndFullScreenBtn);
      
      fullWindowAndFullScreenBtn.addEventListener(MouseEvent.CLICK, openFull);
      
      thisNormalControls = this;
      
      fullControls = fc;
      
      super(stage, ns, videoInfo, wrapper);
    }
    
    public var playBtn:NormalPlayButton;
    public var pauseBtn:NormalPauseButton;
    public var normalControlsBackground:NormalControlsBackground;
    public var wrapper:MovieClip;
    public var fullWindowAndFullScreenBtn:NormalFullWindowandFullScreenButton;
    public var fullControls:FullControls;
    public var thisNormalControls:NormalControls;
    public var goToFullScreen:Boolean = false;
    
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
      fullControls.setPlayPauseUI(true);
    }
    
    public function pauseBtnClick():void {
      netStream.pause();
      this.setPlayPauseUI(false);
      fullControls.setPlayPauseUI(false);
    }
    
    public function hide():void {
      Tweener.addTween(normalControlsBackground, { alpha:0, time:0.5 });
      Tweener.addTween(wrapper, { alpha:0, time:0.5 });
    }
    
    public function show():void {
      Tweener.addTween(normalControlsBackground, { alpha:1, time:0.5 });
      Tweener.addTween(wrapper, { alpha:1, time:0.5 });
    }
    
    public function openFull(event:MouseEvent):void {
      if (goToFullScreen) {
        theStage.displayState = StageDisplayState.FULL_SCREEN;
      } else {
        ExternalInterface.call("SVfullWindow()");
      }
      normalControlsBackground.visible = false;
      wrapper.visible = false;
      fullControls.show(thisNormalControls);
    }
    
    function togglefullWindowAndFullScreenBtn(fullScreen:Boolean):void {
      if (fullScreen) {
        fullWindowAndFullScreenBtn.gotoAndStop(2);
        goToFullScreen = true;
      } else {
        fullWindowAndFullScreenBtn.gotoAndStop(1);
        goToFullScreen = false;
      }
    }

  }

}
