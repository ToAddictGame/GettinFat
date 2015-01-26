package objects
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	
	import flash.geom.Point;
	
	import Screen.InGame;
	
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
			var xPos:int;
			var yPos:int;
			
			if(beenHit == false){
				
				switch(this.bugNumber)
				{
					//RANDOM MOVEMENT
					case 1:
						xPos = Math.floor(Math.random() * (stage.stageWidth - 0 + 1)) + 0;
						yPos = Math.floor(Math.random() * (stage.stageHeight - 0 + 1)) + 0;			
						
								
								
						break;
					
					//PROXIMITY MOVEMENT
					case 2:
						xPos = 0;
						yPos = 0;
						break;
					
					//STRAUGHT TO CHARACTER
					case 3:
						
						//addEventListener(Event.ENTER_FRAME, chaseCharacter);
						xPos = InGame.character.x;
						yPos = InGame.character.y;
						
						break;
					
					//CROSS STAGE
					case 4:
						xPos = 0;
						yPos = 0;
						break;
				}
				
				var disX:int = xPos - this.x;
				var disY:int = yPos  - this.y;;
				
				var radiansDegrees:Number = Math.atan2(disY,disX);
				this.rotation = radiansDegrees+deg2rad(90);	
				TweenLite.to(this,speed,{x: xPos, y: yPos, ease:Linear.easeNone, onComplete:MoveBug});	
			}			
		}
		
		private function chaseCharacter(e:Event):void
		{
			this.x = this.x + ((InGame.character.x - this.x)/50);
			this.y = this.y + ((InGame.character.y - this.y)/50);
			var radiansDegrees:Number = Math.atan2(InGame.character.x,InGame.character.y);
			this.rotation = radiansDegrees+deg2rad(90);
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