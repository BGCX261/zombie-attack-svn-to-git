package actions{
	import gameitems.*;
	public class TakeItem implements IAction {
		public function TakeItem(){
		}

		public function performAction(you, opponent=null):void {
			takeItem(you, opponent);
		}
		
		public function takeItem(you, item):void {
			if (item is AGameItem && item.canBeTaken)
			{
				var dist = you.getDistanceTo(item);
				
				if (dist <= 5)
				{
					item.takeItem(you);
				}
			}
		}
	}
}
