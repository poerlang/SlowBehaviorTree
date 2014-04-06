package behavior.ai
{
	public class God
	{
		public function God(){
			select = new Select();
		}
		public var select:Select;
		private var _nodeNow:AINode;

		public function get nodeNow():AINode
		{
			return _nodeNow;
		}

		public function set nodeNow(value:AINode):void
		{
			_nodeNow = value;
		}

		public function update(dt:Number):void{
			if(nodeNow){
				nodeNow.update(dt);
			}
		}
	}
}