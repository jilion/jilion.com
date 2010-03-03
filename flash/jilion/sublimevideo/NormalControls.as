package jilion.sublimevideo {
  import caurina.transitions.*; 
  import caurina.transitions.properties.FilterShortcuts;
  import flash.display.*;
  import flash.events.*;
  import flash.net.*;
  import flash.utils.*;
  import flash.text.*;

  public class NormalControls extends SublimeControls {
    public function NormalControls(stage:Stage, ns:NetStream) {
      
      normalControlsBackground = new NormalControlsBackground();
      normalControlsBackground.width = stage.stageWidth;
      normalControlsBackground.height = 25;
      normalControlsBackground.x = 0;
      normalControlsBackground.y = stage.stageHeight;
      stage.addChild(normalControlsBackground);
      
      wrapper = new Sprite();
      wrapper.graphics.beginFill(0x000000,0);
      wrapper.graphics.drawRect(0, 0, stage.stageWidth, 25);
      wrapper.graphics.endFill();
      wrapper.x = 0;
      wrapper.y = stage.stageHeight-25;
      stage.addChild(wrapper);
      
      playBtn = new NormalPlayButton();
      playBtn.x = 6;
      playBtn.y = 7;
      playBtn.addEventListener(MouseEvent.CLICK, playBtnClick); 
      wrapper.addChild(playBtn);
      
      pauseBtn = new NormalPauseButton();
      pauseBtn.x = 5;
      pauseBtn.y = 7;
      pauseBtn.addEventListener(MouseEvent.CLICK, pauseBtnClick);
      wrapper.addChild(pauseBtn);
      
      super(stage, ns, wrapper);
    }
    
    public var playBtn:NormalPlayButton;
    public var pauseBtn:NormalPauseButton;
    public var normalControlsBackground:NormalControlsBackground;
    public var wrapper:Sprite;
    
    public function setupPlayStartUI():void {  
      playBtn.visible = false;
      pauseBtn.visible = true;
    }
  
    public function playBtnClick(event:MouseEvent):void {  
      netStream.resume();  //  tell the NetStream to resume playback
      playBtn.visible = false;
      pauseBtn.visible = true;
    }

    public function pauseBtnClick(event:MouseEvent):void {  
      netStream.pause();  //  tell the NetStream to pause playback  
      playBtn.visible = true;
      pauseBtn.visible = false;
    }

    public function hide():void {
      Tweener.addTween(normalControlsBackground, { alpha:0, time:0.5 });
      Tweener.addTween(wrapper, { alpha:0, time:0.5 });
    }

    public function show():void {
      Tweener.addTween(normalControlsBackground, { alpha:1, time:0.5 });
      Tweener.addTween(wrapper, { alpha:1, time:0.5 });
    }

  }

  

/*  public class FullWindowControls extends SublimeControls {
    public function FullWindowControls() {
      super();
      playBtn = playBtn_fs_mc;  //  targets the play button in the player

    }
  }

*/
}
