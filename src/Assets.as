package
{
	import flash.display.Bitmap;
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class Assets
	{
		//IMAGES
		
		[Embed(source="../media/bg.jpg")]
		public static const bg:Class;
		
		[Embed(source="../media/character.png")]
		public static const character:Class;
		
		[Embed(source="../media/characterEating.png")]
		public static const characterEating:Class;		
		
		[Embed(source="../media/bolha.png")]
		public static const bolha:Class;
		
		[Embed(source="../media/bolhaFootprint.png")]
		public static const bolhaArea:Class;
		
		[Embed(source="../media/bug1.png")]
		public static const bug1:Class;
		
		[Embed(source="../media/bug2.png")]
		public static const bug2:Class;
		
		[Embed(source="../media/bug3.png")]
		public static const bug3:Class;
		
		[Embed(source="../media/bug4.png")]
		public static const bug4:Class;		
		
		[Embed(source="../media/playButton.png")]
		public static const playButton:Class;
		
		[Embed(source="../media/highscoreBoard.png")]
		public static const highScoreBoard:Class;
		
		
		private static var gameTexture:Dictionary = new Dictionary();
		
		public static function getTexture(name:String):Texture
		{
			
			if(gameTexture[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTexture[name] = Texture.fromBitmap(bitmap);
				
			}
			return gameTexture[name];
		}
		
		//FONTS 
		
		[Embed(source="../media/Fonts/font.png")]
		public static const FontTexture:Class;
		
		[Embed(source="../media/Fonts/font.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		public static var myFont:BitmapFont;
		
		public static function getFont():BitmapFont
		{
			var fontTexture:Texture = Texture.fromBitmap(new FontTexture());
			var fontXml:XML = XML(new FontXml());
			
			var font:BitmapFont = new BitmapFont(fontTexture,fontXml);
			TextField.registerBitmapFont(font);
			
			return font;
			
			
		}
		
		
	}
}