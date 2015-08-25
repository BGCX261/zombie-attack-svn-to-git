package actions{
	public class RunAway implements IAction {
		private var move:Move;
		
		public function RunAway(){
			move = new Move();
		}
		public function performAction(you, opponent=null):void {
			if (opponent)
			{
				you.setDirection(you.getAngleFrom(opponent));
				you.speed = you.getRunSpeed();
				move.performAction(you);
			}
		}
	}
}