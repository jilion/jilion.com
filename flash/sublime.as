import flash.events.MouseEvent;
import flash.events.Event;
stage.scaleMode = StageScaleMode.NO_SCALE; // tell the stage not to scale our items  
stage.align = StageAlign.TOP_LEFT; // set the stage to center in the top left of the .swf file  
FilterShortcuts.init();  // initialize the filter shortcuts for our tweener class

var videoSound:SoundTransform;

var videoBackground:PlayerBackground = new PlayerBackground();
videoBackground.width = stage.stageWidth;
videoBackground.height = stage.stageHeight;
addChild(videoBackground);

var videoBlackBox:VideoBlackBox = new VideoBlackBox();
videoBlackBox.width = stage.stageWidth;
videoBlackBox.height = stage.stageHeight;
videoBlackBox.x = 0;
videoBlackBox.y = 0;
videoBlackBox.scaleX = 1.0;
videoBlackBox.scaleY = 1.0;
addChild(videoBlackBox);

var video:Video = new Video(stage.stageWidth, stage.stageHeight);
video.x = 0;
video.y = 0;
videoBlackBox.addChild(video);
video.scaleX = 1.0;
video.scaleY = 1.0;

var nc:NetConnection = new NetConnection();  //  variable for a new NetConnection
nc.connect(null);  //  set the nc variable to null

var ns:NetStream = new NetStream(nc);  // create a variable for a new NetStream connection & connect it to the nc variable
ns.addEventListener(NetStatusEvent.NET_STATUS, myStatusHandler);  //  add a listener to the NetStream to listen for any changes that happen with the NetStream
ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);  //  add a listener to the NetStream for any errors that may happen

video.attachNetStream(ns);  // attach the NetStream variable to the video object
ns.bufferTime = 5;  // set the buffer time to 5 seconds

ns.play("video.mp4");

var videoInfo:VideoInfo = new VideoInfo();
var fullControls:FullControls = new FullControls(this.stage, ns, videoInfo);
var normalControls:NormalControls = new NormalControls(this.stage, ns, videoInfo, fullControls);

function asyncErrorHandler(Event:AsyncErrorEvent):void {
  //trace(event.text);
}  

function myStatusHandler(event:NetStatusEvent):void {
  //trace(event.info.code);
  switch(event.info.code)  {
    case "NetStream.Buffer.Full":
      ns.bufferTime = 10;
      break;
    case "NetStream.Buffer.Empty":
      ns.bufferTime = 10;
      break;  
    case "NetStream.Play.Start":
      ns.bufferTime = 10;
      normalControls.setupPlayStartUI();
      fullControls.setupPlayStartUI();
      break;
    case "NetStream.Seek.Notify":
      ns.bufferTime = 10;
      break;
    case "NetStream.Seek.InvalidTime":
      ns.bufferTime = 10;
      break;
    case "NetStream.Play.Stop":
      ns.seek(0);
      normalControls.videoEndReached();
      fullControls.videoEndReached();
      break;
  }
}

stage.addEventListener(Event.RESIZE, resizeHandler);

function resizeHandler(e:Event):void {
  videoBackground.width = stage.stageWidth;
  videoBackground.height = stage.stageHeight;
  if (video.videoWidth >= video.videoHeight) {
    var scaledHeight = (video.videoHeight/video.videoWidth)*stage.stageWidth;
    video.width = stage.stageWidth;
    video.height = scaledHeight;
    videoBlackBox.width = stage.stageWidth;
    videoBlackBox.height = scaledHeight;
    videoBlackBox.y = (stage.stageHeight - videoBlackBox.height)/2;
  } else if (video.videoHeight > video.videoWidth) {
    var scaledWidth = (video.videoWidth/video.videoHeight)*stage.stageHeight;
    video.height = stage.stageHeight;
    video.width = scaledWidth;
    videoBlackBox.height = stage.stageHeight;
    videoBlackBox.width = scaledWidth;
    videoBlackBox.x = (stage.stageWidth - videoBlackBox.width)/2;
  }
  fullControls.updateControlsPosition(stage);
}

function mouseOn(evt:MouseEvent){
  normalControls.show();
  stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseOn);
}

function mouseOff(evt:Event){
  normalControls.hide();
  stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseOn);
}

stage.addEventListener(Event.MOUSE_LEAVE, mouseOff);
