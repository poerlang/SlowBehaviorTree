package behavior.ai
{
	public class Select
	{
		public function And(childs:Vector.<AINode>):int{
			for (var i:int = 0; i < childs.length; i++) 
			{
				if(childs[i].state == AINode.FAIL){
					return AINode.FAIL;
				}
				if(!childs[i].hasRun){
					childs[i].parent.running_sub = childs[i];
					return AINode.WAITSUB;
				}
			}
			return AINode.SUCCESS;
		}
		public function Or(childs:Vector.<AINode>):int{
			for (var i:int = 0; i < childs.length; i++) 
			{
				if(childs[i].state == AINode.SUCCESS){
					return AINode.SUCCESS;
				}
				if(!childs[i].hasRun){
					childs[i].parent.running_sub = childs[i];
					return AINode.WAITSUB;
				}
			}
			return AINode.FAIL;
		}
	}
}