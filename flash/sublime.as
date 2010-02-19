stage.scaleMode = StageScaleMode.NO_SCALE; // tell the stage not to scale our items  
stage.align = StageAlign.TOP_LEFT; // set the stage to center in the top left of the .swf file  
FilterShortcuts.init();  // initialize the filter shortcuts for our tweener class

var videoInterval = setInterval(videoStatus, 100);
var amountLoaded:Number;
var duration:Number;
var scrubInterval;
var videoSound:SoundTransform;

var videoBackground:PlayerBackground = new PlayerBackground();
videoBackground.width = stage.stageWidth;
videoBackground.height = stage.stageHeight;
addChild(videoBackground);

var normalControls:NormalControls = new NormalControls(this.stage);