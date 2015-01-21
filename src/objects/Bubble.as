package objects
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import Screen.InGame;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Bubble extends Sprite
	{
		private var bubble:Image;
		public  var bubbleScale:Number;
		
	
		
		public function Bubble()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			bubble = new Image(Assets.getTexture("bolha"));
			bubble.x = bubble.x - bubble.width/2;
			bubble.y = bubble.y - bubble.height/2;			
				
			this.addChild(bubble);		
			
			init();		
			
		}
		
		public function init():void
		{
			this.scaleX = 0.1;
			this.scaleY = 0.1;		
			
			bubbleScale = 0.1;
			bubble.visible = false;		
			
			this.visible = false;
			TweenLite.to(this,0,{scaleX:bubbleScale, scaleY:bubbleScale});
		}
		
		
		
		public function grow():void
		{
			this.visible = true;
			bubble.visible = true;
			bubbleScale += 0.002;			
			TweenLite.to(this,0.5,{scaleX:bubbleScale, scaleY:bubbleScale});			
		}
		
		/*public function smashEffect():void
		{
			this.visible = true;
			bubble.visible = false;
			bubbleFootprint.visible = true;
			bubbleFootprint.alpha = 0;
			smashinBubble = true;
			TweenMax.to(bubbleFootprint, 0.05, {alpha:10.8, repeat:6, yoyo:true, onComplete:init});	
			this.dispatchEvent(new Event("SMASH",true));
		}*/
			
			
	}
}