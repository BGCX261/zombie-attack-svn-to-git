package actions{
	public class GroupWith implements IAction {
		private var move:Move;
		
		public function GroupWith (){
			move = new Move();
		}
		public function performAction(you, opponent=null):void {
			if (opponent)
			{	
				var newDirection:Number = you.getAngleTo(opponent);

				newDirection += (20 * Math.random()) - 10;
				you.speed = you.getWalkSpeed();
				
				var distance = you.getDistanceTo(opponent);
				var distPercent = (distance / you.viewDist);
				var offset = 90 * (1 - distPercent);

				newDirection += offset;
				you.setDirection(newDirection);
				
				move.performAction(you);
			}
		}
	}
}