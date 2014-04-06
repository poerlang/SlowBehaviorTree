package behavior.ui.other
{
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	public class RectSprite extends Sprite
	{
		public var color:uint;
		public static var lightUpNum:uint = 90;
		public var w:int;
		public var h:int;
		public var pad:int;
		public function RectSprite(_w:int,_h:int,pad:int,color:uint)
		{
			this.pad = pad;
			this.h = _h;
			this.w = _w;
			this.color = color;
			draw();
		}
		public function draw(useLightUpColor=false):void{
			var c:uint = color;
			if(useLightUpColor){
				var r:uint = ((color & 0xff)			+lightUpNum) & 0xffffff;
				var g:uint = ((color >> 8 & 0xff)		+lightUpNum) & 0xffffff;
				var b:uint = ((color >> 16)				+lightUpNum) & 0xffffff;
				c = r<<16|g<<8|b;
			}

			graphics.clear();
			graphics.beginFill(c);
			graphics.drawRect(pad,pad,w-pad*2,h-pad*2);
			graphics.endFill();
		}
		public function lightUp(timeOutInSec:Number=0):void{
			draw(true);
			if(timeOutInSec>0){
				setTimeout(draw,timeOutInSec*1000);
			}
		}
		public function lightDown():void{
			draw();
		}
	}
}