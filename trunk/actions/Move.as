package actions{
	public class Move implements IAction {
		
		public function Move(){
		}
		public function performAction(you, opponent=null):void {

			var dX = Math.cos(you.getDirection() * (Math.PI / 180));
			var dY = Math.sin(you.getDirection() * (Math.PI / 180));
			
			var step = (you.stepSize / 100) * you.speed;

			you.x += dX * step;
			you.y += dY * step;
		}
	}
}