package actions{
	public class TurnTowards implements IAction {
		
		public function TurnTowards(){
		}
		public function performAction(you, opponent=null):void {
			if (opponent)
			{
				you.setDirection(you.getAngleTo(opponent));
			}
		}
	}
}