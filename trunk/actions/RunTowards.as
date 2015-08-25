package actions{
	public class RunTowards implements IAction {
		private var move:Move;
		
		public function RunTowards(){
			move = new Move();
		}
		public function performAction(you, opponent=null):void {
			if (opponent)
			{
				you.setDirection(you.getAngleTo(opponent));
				you.speed = you.getRunSpeed();
				move.performAction(you);
			}
		}
	}
}