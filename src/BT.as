package
{
	import com.bit101.components.ComboBox;
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import behavior.ai.AINode;
	import behavior.ui.UINode;
	import behavior.ui.other.ArrowContainer;

	public class BT extends Sprite
	{
		private var mLastFrameTimestamp:Number;
		public function BT()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			ui();
			test();
			mLastFrameTimestamp = getTimer() / 1000.0;
			stage.addEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		private function ui():void
		{
			Style.embedFonts = false;
			Style.fontName = "Consolas";
			Style.fontSize = 12;
			var menu:HBox = new HBox(this);
			type = new ComboBox(menu,0,0,"",UINode.typeArr); type.selectedIndex = 0;
			new PushButton(menu,0,0,"添加",onAddNode);
			new PushButton(menu,0,0,"删除",onDelNode);
		}
		
		private function onDelNode(e:Event):void
		{
			if(UINode.LastSelUINode){
				if(UINode.LastSelUINode.parentUINode){
					UINode.LastSelUINode.parentUINode.removeChildNode(UINode.LastSelUINode);
				}
			}
		}
		private function onAddNode(e:Event):void
		{
			var sel:String = type.selectedItem as String;
			if(UINode.LastSelUINode){
				UINode.LastSelUINode.addSubNode(sel);
			}
		}
		private function test():void
		{
			addChild(new ArrowContainer());
			UINode.container = this;
			
			UIRoot = new UINode();		UIRoot.x = 100; UIRoot.y = 100;
			UIRoot.lightUp();
			
			addChild(UIRoot);
		}
		public var frameCount:int;
		private var type:ComboBox;

		private var UIRoot:UINode;
		protected function onFrame(event:Event):void
		{
			frameCount++;
			if(frameCount % AINode.FRAME_STEP!=0)return;
			
			var now:Number = getTimer() / 1000.0;
			var passedTime:Number = now - mLastFrameTimestamp;
			mLastFrameTimestamp = now;
			
			UIRoot.ai.god.update(passedTime);
		}
	}
}