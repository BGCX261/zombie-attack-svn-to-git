package actions{
	public class Shove implements IAction {
		private static const SHOVE_DISTANCE = 50;
		
		public function Shove(){
		}
		public function performAction(you, opponent=null):void {
			if (opponent)
			{
				if (you.getDistanceTo(opponent)<=30)
				{
					var angle:Number = getAngleTowards(opponent, you) + (Math.random() * 80 - 40);
					you.setDirection(angle);
					var shove:Number = SHOVE_DISTANCE * you.health/you.maxHealth;
					var dy:Number  = shove * Math.sin(angle * Math.PI/180);
					var dx:Number  = shove * Math.cos(angle * Math.PI/180);				
					opponent.x += dx;
					opponent.y += dy;
				}
			}
		}
		private function getAngleTowards(opponent, you):Number
		{
			var dx:Number = opponent.x - you.x;
			var dy:Number = opponent.y - you.y; 
			var angle = Math.atan2(dy, dx);
			var degrees = angle * 180 / Math.PI;
			return degrees;
		}
	}
}