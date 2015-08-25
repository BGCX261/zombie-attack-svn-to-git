package actions{
	public class RandomMovement implements IAction {
		private var move:Move;
		
		public function RandomMovement(){
			move = new Move();
		}
		public function performAction(you, opponent=null):void {
			if (Math.random() <= 0.1)
			{
				var direction = you.getDirection() + Math.random()*60-30;
				//trace("RandomMovement - direction: "+ you.getDirection());//TMP
				
				you.setDirection(direction);
			}
			you.speed = you.getRunSpeed() * Math.random()*3;
			move.performAction(you);
		}
	}
}