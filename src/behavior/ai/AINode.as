package behavior.ai
{
	import behavior.ui.UINode;

	public class AINode
	{
		private function selectSub():void
		{
			running_sub = null;
			state = selectFunction(childs);
			if(state!=WAITSUB){
				stepNow = STEP_TYPE_NO_SUB_CAN_RUN;
			}
		}

		public function update(dt:Number):void{
			time += dt;//累积时间，直到超过waitTime，才能进入下一个step
			if( time < waitTime ){//没有超过waitTime，则强制【等待，返回】
				return;
			}
			switch(stepNow)
			{
				case "":
				{
					running_sub = null;
					state = WAITSUB;
					stepNow = STEP_TYPE_ENTER;
					rndChilds();
					return;
				}
				case STEP_TYPE_RUN://如果上一步是进入，接下来就是【选择子节点】
				{
					doJob();
					return;
				}
				case STEP_TYPE_ENTER://如果上一步是进入，接下来就是【选择子节点】
				{
					if(childs.length==0 && !isRoot){
						stepNow = STEP_TYPE_RUN;
						stepNow = STEP_TYPE_WILL_RETURN;
					}else{
						stepNow = STEP_TYPE_SEL_SUB_NODE;
						selectSub();
					}
					return;
				}
				case STEP_TYPE_SEL_SUB_NODE://如果上一步是选择子节点，接下来就是【运行子节点】
				{
					state = WAITSUB;
					stepNow = STEP_TYPE_RUN_AND_WAIT_SUB_NODE;
					god.nodeNow = running_sub;
					return;
				}
				case STEP_TYPE_WILL_RETURN://如果上一步是即将返回，接下来就是真正的返回。
				{
					hasRun = true;
					if(parent){
						god.nodeNow = parent;//返回父节点
						parent.stepNow = STEP_TYPE_SUB_RETURN;
					}
					state = SUCCESS;
					return;
				}
				case STEP_TYPE_SUB_RETURN://如果上一步是子节点返回，接下来就是	【选择子节点】
				{
					state = WAITSUB;
					stepNow = STEP_TYPE_SEL_SUB_NODE;
					selectSub();
					return;
				}
				case STEP_TYPE_NO_SUB_CAN_RUN://子节点都运行过了，目前没有节点可运行
				{
					hasRun = true;
					if(isRoot){
						stepNow = STEP_TYPE_RETURN_TO_ROOT;
					}else{
						stepNow = STEP_TYPE_WILL_RETURN;
					}
					return;
				}
				case STEP_TYPE_RETURN_TO_ROOT://回到根节点，即将整棵树的状态并重新运行。
				{
					reset();
					return;
				}
				default:
				{
					return;
				}
			}
		}
		
		public function doJob():void
		{
			stepNow = STEP_TYPE_WILL_RETURN;
		}
		public function AINode(_parent:AINode = null,sel:String="")
		{
			parent = _parent;
			this.sel = sel;
			if(sel=="") sel = "Or";
			if(!_parent){
				isRoot = true;
				root = this;
				god = new God();
				god.nodeNow = this;
			}else{
				god = parent.god;
				root = parent.root;
			}
			selectFunction = god.select[sel];
		}
		
		public function get stepNow():String
		{
			return _stepNow;
		}

		public function set stepNow(value:String):void
		{
			trace(this.name+"  "+value);
			//重置时间
			time = 0;
			_stepNow = value;
			if(ui){
				ui.lightUp(1);
			}
		}
		public function addChild(child:AINode):AINode{
			if(childs.indexOf(child)==-1){
				childs.push(child);
			}
			rndChilds();
			return child;
		}
		public function removeChild(child:AINode):AINode{
			child.dispose();
			var index:int = childs.indexOf(child);
			if(index!=-1){
				childs.splice(index,1);
			}
			rndChilds();
			return child;
		}
		
		private function rndChilds():void
		{
			if(rnd){
				childs.sort(sortFunction);
			}
		}
		public function sortFunction(a:AINode,b:AINode):Boolean{
			return Math.random()>.5;
		}
		
		private function reset():void
		{
			if(isRoot)trace("==========================重置所有数据=============================");
			state = -1;
			hasRun = false;
			running_sub = null;
			time=0;
			_stepNow = "";
			for (var i:int = 0; i < childs.length; i++) 
			{
				childs[i].reset();
			}
		}
		private function dispose():void
		{
			state = -1;
			hasRun = false;
			running_sub = null;
			time=0;
			_stepNow = "";
			parent = null;
			if(god.nodeNow==this){
				if(root){
					if(god.nodeNow!=root){
						root.reset();
						god.nodeNow=root;
					}
				}
			}
			root = null;
			god = null;
			name = null;
			_stepNow = null;
			ui = null;
			selectFunction = null;
			sel = null;
			for (var i:int = 0; i < childs.length; i++) 
			{
				childs[i].dispose();
			}
			childs = null;
		}
		public var parent:AINode;
		private var childs:Vector.<AINode> = new Vector.<AINode>();
		public var running_sub:AINode;
		public var god:God;
		public var name:String;
		private var rnd:Boolean;
		public static var FRAME_STEP:int = 2;//每隔多少帧运行一次god的Update
		private var waitTime:Number = 0.2;//需要等待进入下一步的总时间（秒）
		private var time:Number = 0;//当前累积已经等待的时间（秒）
		public static const STEP_TYPE_ENTER:String = "进入节点";
		public static const STEP_TYPE_SEL_SUB_NODE:String = "选择子节点";
		public static const STEP_TYPE_NO_SUB_CAN_RUN:String = "无节点可运行，或已经满足返回条件";
		public static const STEP_TYPE_RUN_AND_WAIT_SUB_NODE:String = "运行并等待子节点";
		public static const STEP_TYPE_WILL_RETURN:String = "即将返回上层节点";
		public static const STEP_TYPE_RUN:String = "正在执行";
		public static const STEP_TYPE_SUB_RETURN:String = "子节点返回";
		public static const STEP_TYPE_RETURN_TO_ROOT:String = "回到根节点，即将整棵树的状态并重新运行";
		public static const STEP_TYPE_EXIT:String = "退出节点";
		public static const RUNNING :int = 1;//只在叶子节点使用
		public static const SUCCESS :int = 2;
		public static const FAIL 	:int = 3;
		public static const WAITSUB :int = 4;
		private var _stepNow:String = "";//当前Step
		public var ui:UINode;
		public var selectFunction:Function;
		public var hasRun:Boolean;
		public var state:int = -1;// RUNNING 1    SUCCESS 2     FAIL 3     WAITSUB 4
		public var root:AINode;
		private var isRoot:Boolean;
		private var sel:String;
	}
}