package behavior.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import behavior.ai.AINode;
	import behavior.ui.other.ArrowContainer;
	import behavior.ui.other.DragSprite;
	import behavior.ui.other.RectSprite;

	public class UINode extends DragSprite
	{
		public static var LastSelUINode:UINode;
		public static var container:Sprite;
		public static var typeArr:Array = ["And","Or"];
		public var isRoot:Boolean;
		public var ai:AINode;
		public var sel:String;
		public var childs:Vector.<UINode> = new Vector.<UINode>();
		public var w:int = 60;
		public var h:int = 20;
		public var pad:int = 2;
		public var pos:Number = .3;
		public var colorBg:uint = 0x333333;
		public var colorBgLeft:uint = 0x777777;
		public var colorBgRight:uint = 0x999999;
		public var txt:TextField;
		public var parentUINode:UINode;
		private var bg:RectSprite;
		private var bgLeft:RectSprite;
		private var bgRight:RectSprite;
		private var lastPos:Point = new Point();
		private var lastParentPos:Point = new Point();
		public function UINode(parentUINode:UINode=null,ai:AINode=null,sel:String = "")
		{
			this.sel = sel;
			this.parentUINode = parentUINode;
			this.ai = ai;
			if(parentUINode == null){
				isRoot = true;
				this.ai = new AINode();
				this.sel = "Or";
			}
			this.ai.ui = this;
			draw();
		}
		public function addSubNode(sel:String):UINode{
			var subAI:AINode = new AINode(ai,sel);
			ai.addChild(subAI);
			var node:UINode = new UINode(this,subAI,sel);
			node.x = int(this.x + (Math.random()*60-30));
			node.y = int(this.y + 70 + (Math.random()*40-20));
			childs.push(node);
			if(this.parent){
				this.parent.addChild(node);
				node.drawArrow();
			}
			return node;
		}
		public function removeChildNode(child:UINode):void
		{
			if(ai)ai.removeChild(child.ai);
			child.ai = null;
			LastSelUINode=null;
			child.onRemoveEvent();
			ArrowContainer.removeArrowOf(child);
			var len:int = child.childs.length;
			while(len>0){
				child.removeChildNode(child.childs[len-1]);
				len--;
			}
			var index:int = childs.indexOf(child);
			if(index!=-1)childs.splice(index,1);
			if(container && container == child.parent)container.removeChild(child);
		}
		public function lightDown():void
		{
			bg.lightDown();
		}
		public function hasChild():Boolean{
			return childs.length>0;
		}
		public function lightUp(timeOut:Number = 0):void{
			bgLeft.lightUp(timeOut);
		}
		override protected function onAdd(e:Event):void
		{
			super.onAdd(e);
			drawArrow();
			drawChildArrow();
		}
		override protected function onMouseDown(e:MouseEvent):void
		{
			super.onMouseDown(e);
			bg.lightUp();
			if(LastSelUINode && LastSelUINode!=this){
				LastSelUINode.lightDown();
			}
			LastSelUINode = this;
		}
		override protected function onMove(e:MouseEvent):void
		{
			super.onMove(e);
			if(isDrag){
				drawArrow();
				drawChildArrow();
			}
		}
		override protected function onMouseUp(e:MouseEvent):void
		{
			super.onMouseUp(e);
			drawArrow();
			drawChildArrow();
		}
		public function drawChildArrow():void{
			if(hasChild()){
				for (var i:int = 0; i < childs.length; i++) 
				{
					if(childs[i].parent == null){
						container.addChild(childs[i]);
					}
					childs[i].drawArrow();
				}
			}
		}
		public function drawArrow():void{
			if(!parentUINode){
				return;
			}
			if(lastPos.x!=this.x || lastPos.y!=this.y || lastParentPos.x!=parentUINode.x || lastParentPos.y!=parentUINode.y){
				lastParentPos = new Point(parentUINode.x,parentUINode.y);
				lastPos = new Point(this.x,this.y);
				
				var mid1:Point = new Point(lastParentPos.x+(parentUINode.width>>1),lastParentPos.y+parentUINode.height);
				var mid2:Point = new Point(lastPos.x+(this.width>>1),this.y);
				ArrowContainer.draw(this,mid1,mid2);
			}
		}
		public function draw():void
		{
			while(numChildren)removeChildAt(0);
			
			bg = new RectSprite(w,h,0,colorBg); 								addChild(bg);
			bgLeft = new RectSprite(w*pos,h,pad,colorBgLeft); 				addChild(bgLeft);
			bgRight = new RectSprite(w-bgLeft.width-pad,h,pad,colorBgRight); 	addChild(bgRight);
			
			bgRight.x = bgLeft.x+bgLeft.width+pad;
			
			txt = new TextField();
			txt.x = bgRight.x+pad;
			txt.y = bgRight.y+pad;
			txt.width = bgRight.width;
			txt.height = bgRight.height;
			txt.selectable = false;
			var f:TextFormat = new TextFormat();
			f.font = "Consolas";
			f.size = 11;
			txt.defaultTextFormat = f;
			this.name = sel+":"+Number(Math.random()*100).toFixed(0);
			txt.text = name;
			ai.name = name;
			addChild(txt);
		}
	}
}