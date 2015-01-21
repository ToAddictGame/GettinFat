package objects
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	public class MainCharacter extends Sprite
	{
		private var character:Image;	
		private var characterEating:Image;
		
		private var fatScale:Number;
		
		public function MainCharacter()
		{
			super();
			
			
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			character = new Image(Assets.getTexture("character"));
			character.x = character.x - character.width/2;
			character.y = character.y - character.height/2;			
			this.addChild(character);	
			
			characterEating = new Image(Assets.getTexture("characterEating"));
			characterEating.x = characterEating.x - characterEating.width/2;
			characterEating.y = characterEating.y - characterEating.height/2;
			this.addChild(characterEating);
			init();
			
		
		}
		public function init():void
		{
			characterEating.visible = false;
			this.scaleX = this.scaleY =1;
			this.fatScale = 1;
			
		}
		
		public function getFat():void
		{
			this.fatScale += 0.01;
			this.scaleX = this.scaleY = fatScale;		
		}
		
		
		public function eat():void
		{
			character.visible = false;
			characterEating.visible = true;
		}
		
		public function walk():void
		{
			character.visible = true;
			characterEating.visible = false;
		}
		
		public function jump():void
		{
			TweenMax.to(this,0.5,{scaleX:1.5 , scaleY: 1.5,repeat:1, yoyo:true,onComplete:sendEvent});	
			
		}		
		public function sendEvent():void
		{
			this.dispatchEvent(new Event("JUMPING",true));
		}
	}
}