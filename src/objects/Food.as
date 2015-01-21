package objects
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	
	public class Food extends Sprite
	{
		private var bugImage:Image;
		private var bugNumber:int;
		private var speed:int;
		public var beenHit:Boolean;
		
		public function Food(_number:int, _speed:int = 2)
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.bugNumber = _number;
			this.speed = _speed;
			this.beenHit = false;
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
			bugImage = new Image(Assets.getTexture("bug"+this.bugNumber));
			bugImage.x = bugImage.x - bugImage.width/2;
			bugImage.y = bugImage.y - bugImage.height/2;			
			this.addChild(bugImage);
			
			MoveBug();
			
		}
		
		private function MoveBug():void
		{
			if(beenHit == false){
				var xPos:int = Math.floor(Math.random() * (stage.stageWidth - 0 + 1)) + 0;
				var yPos:int = Math.floor(Math.random() * (stage.stageHeight - 0 + 1)) + 0;			
				var disX:int = xPos - this.x;
				var disY:int = yPos  - this.y;;
				var radiansDegrees:Number = Math.atan2(disY,disX);
				this.rotation = radiansDegrees+deg2rad(90);			
				
				TweenLite.to(this,speed,{x: xPos, y: yPos, ease:Linear.easeNone, onComplete:MoveBug});	
			}			
		}
		
		public function moveToMouth(location:Point):void
		{
			TweenLite.to(this,0.5,{x: location.x, y: location.y, ease:Back.easeIn, onComplete:destroyThis});	
		}
		
		private function destroyThis():void
		{
			this.dispatchEvent(new Event("FINISH_EATING",true));
			this.parent.removeChild(this);
		}
		
		private function update(e:Event):void
		{
			
		}
		
		
		
		
		
	}
}