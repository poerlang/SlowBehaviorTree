package behavior.ui.other
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class ArrowContainer extends Sprite
	{
		private static var dic:Dictionary = new Dictionary();
		private static var one:ArrowContainer;
		public function ArrowContainer()
		{
			one = this;
		}
		
		public static function draw(ob:*,p1:Point,p2:Point):void
		{
			var s:Sprite = dic[ob];
			if(!s){
				s = new Sprite();
				dic[ob] = s;
				one.addChild(s);
			}
			s.graphics.clear();
			s.graphics.lineStyle(1,0x000000,0.7);
			s.graphics.moveTo(p1.x,p1.y);
			s.graphics.lineTo(p2.x,p2.y);
		}
		public static function removeArrowOf(ob:*):void
		{
			if(dic[ob]){
				var s:Sprite = dic[ob];
				one.removeChild(s);
				delete dic[ob];
			}
		}
	}
}