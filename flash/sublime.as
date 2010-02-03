stage.scaleMode = StageScaleMode.NO_SCALE; // tell the stage not to scale our items  
stage.align = StageAlign.TOP_LEFT; // set the stage to center in the top left of the .swf file  
FilterShortcuts.init();  // initialize the filter shortcuts for our tweener class
var debug:TextField = debug_txt;

debug.text = "";

var videoInterval = setInterval(videoStatus, 100);
var amountLoaded:Number;
var duration:Number;
var scrubInterval;
var videoSound:SoundTransform;
var volumeBounds:Rectangle;

var videoBackground:MovieClip = background_mc;
videoBackground.width = stage.stageWidth;
videoBackground.height = stage.stageHeight;

var controlsSmall:MovieClip = controlsSmall_mc;  //  targets the small controls wrapper
controlsSmall.width = stage.stageWidth;
controlsSmall.height = 25;
controlsSmall.x = 0;
controlsSmall.y = stage.stageHeight;
	
var playBtn:MovieClip = playBtn_mc;  //  targets the play button in the player
playBtn.mouseChildren = false;  //  makes the elements inside the targeted movie clip unselectable  
playBtn.buttonMode = true;  // gives the hand cursor when you hover over the movieclip
playBtn.addEventListener(MouseEvent.CLICK, playBtnClick);  //  add a click listener to the playBtn
playBtn.x = 6;
playBtn.y = stage.stageHeight-18;

var pauseBtn:MovieClip = pauseBtn_mc;  //  targets the pause button in the player
pauseBtn.mouseChildren = false;  //  makes the elements inside the targeted movie clip unselectable  
pauseBtn.buttonMode = true;  // gives the hand cursor when you hover over the movieclip
pauseBtn.addEventListener(MouseEvent.CLICK, pauseBtnClick);  //  add a click listener to the playBtn
pauseBtn.x = 5;
pauseBtn.y = stage.stageHeight-18;

var videoElapsedTime:TextField = elapsedTime_txt;  //  targets the dynamic text layer that will display the elapsed time played
videoElapsedTime.text = "00:00";  
videoElapsedTime.x = 19;
videoElapsedTime.y = stage.stageHeight-20;

var videoProgressBarBackground:MovieClip = progress_bar_back_mc;  //  targets the progress bar background
videoProgressBarBackground.width = stage.stageWidth-132;
videoProgressBarBackground.x = 66;
videoProgressBarBackground.y = stage.stageHeight-16;

var videoProgressBarBuffered:MovieClip = progress_bar_buffered_mc;  //  targets the progress bar buffered
videoProgressBarBuffered.width = 0;
videoProgressBarBuffered.x = 66;
videoProgressBarBuffered.y = stage.stageHeight-16;

var videoProgressBarElapsedTime:MovieClip = progress_bar_elapsed_time_mc;  //  targets the progress bar elapsed time
videoProgressBarElapsedTime.width = 0;
videoProgressBarElapsedTime.x = 66;
videoProgressBarElapsedTime.y = stage.stageHeight-16;

var progressBarIndicator:MovieClip = progress_bar_indicator_mc; //  targets the progress bar indicator
progressBarIndicator.x = 62;
progressBarIndicator.y = stage.stageHeight-17;

//var videoThumb:MovieClip = player_mc.videoTrack_mc.videoThumb_mc;  //  targets the video scrubber thumb  
//var volumeThumb:MovieClip = player_mc.volumeSlider_mc.volumeThumb_mc;  // targets the volume scrubber thumb  
//var volumeTrack:MovieClip = player_mc.volumeSlider_mc.volumeTrackFull_mc;  //  targets the volume scrubber track percentage bar


var videoBlackBox:MovieClip = videoBlackBox_mc;  //  targets the black background box in the player  

videoBlackBox.width = stage.stageWidth;
videoBlackBox.height = stage.stageHeight;
videoBlackBox.x = 0;
videoBlackBox.y = 0;
videoBlackBox.scaleX = 1.0;
videoBlackBox.scaleY = 1.0;

var video:Video = new Video(stage.stageWidth, stage.stageHeight);  //  create a new Video item and set its width and height  
video.x = 0;  //  position the video's x position  
video.y = 0;  //  position the video's y position  
videoBlackBox.addChild(video);  //  add the video item to the videoBlackBox movieclip in the player_mc movieclip
video.scaleX = 1.0;
video.scaleY = 1.0;

var nc:NetConnection = new NetConnection();  //  variable for a new NetConnection  
nc.connect(null);  //  set the nc variable to null  
var ns:NetStream = new NetStream(nc);  // create a variable for a new NetStream connection & connect it to the nc variable  
ns.addEventListener(NetStatusEvent.NET_STATUS, myStatusHandler);  //  add a listener to the NetStream to listen for any changes that happen with the NetStream  
ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);  //  add a listener to the NetStream for any errors that may happen  
  
video.attachNetStream(ns);  // attach the NetStream variable to the video object  
var newMeta:Object = new Object();  // create a new object to handle the metaData  
newMeta.onMetaData = onMetaData;  //  when we recieve MetaData, attach it to the newMeta object  
ns.client = newMeta;  // attach the NetStream.client to the newMeta variable  
ns.bufferTime = 5;  // set the buffer time to 5 seconds

function asyncErrorHandler(Event:AsyncErrorEvent):void  {
    //trace(event.text);
}  

function myStatusHandler(event:NetStatusEvent):void  {
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
			playBtn.visible = false;
			pauseBtn.visible = true;
        break;
        case "NetStream.Seek.Notify":
            ns.bufferTime = 10;
        break;
        case "NetStream.Seek.InvalidTime":
            ns.bufferTime = 10;
        break;
        case "NetStream.Play.Stop":
            ns.pause();
/*			ns.seek(0);*/
        break;  
    }  
}

ns.play("video.mp4");  //  tell the netstream what video to play and play it
//ns.play("http://mirror.bigbuckbunny.de/peach/bigbuckbunny_movies/big_buck_bunny_480p_h264.mov");  //  tell the netstream what video to play and play it

function onMetaData(newMeta:Object):void {  
    //trace("Metadata: duration=" + newMeta.duration + " width=" + newMeta.width + " height=" + newMeta.height + " framerate=" + newMeta.framerate);  // traces what it says  
    duration = newMeta.duration;  // set the duration variable to the newMeta's duration  
}

function playBtnClick(event:MouseEvent):void {  
    ns.resume();  //  tell the NetStream to resume playback
	playBtn.visible = false;
	pauseBtn.visible = true;
}

function pauseBtnClick(event:MouseEvent):void {  
    ns.pause();  //  tell the NetStream to pause playback  
	playBtn.visible = true;
	pauseBtn.visible = false;
}

function stopBtnClick(event:MouseEvent):void {  
    ns.pause();  //  tell the NetStream to pause playback  
    ns.seek(0);  //  tell the NetStream to go to the first frame of the video  
}

function videoStatus():void {
    amountLoaded = ns.bytesLoaded / ns.bytesTotal;
	checkTime();
	videoProgressBarBuffered.width = amountLoaded * videoProgressBarBackground.width;
	videoProgressBarElapsedTime.width = ns.time / duration * videoProgressBarBackground.width + 5;
	progressBarIndicator.x = ns.time / duration * videoProgressBarBackground.width + 66;
}

function checkTime():void {
	
	var secs:Number = ns.time;
	
	var hours:Number = Math.floor(secs / (60 * 60));
	var minDivisor:Number = secs % (60 * 60);
	var minutes:Number = Math.floor(minDivisor / 60);
    var secDivisor:Number = minDivisor % 60;
    var seconds:Number = Math.ceil(secDivisor);
	var sMinutes:String = String(minutes);
	var sSeconds:String = String(seconds);
    if (minutes < 10) {
      sMinutes = "0" + String(minutes);
    }
    if (seconds < 10) {
      sSeconds = "0" + String(seconds);
    }

	videoElapsedTime.text = sMinutes + ":" + sSeconds;
}; 
