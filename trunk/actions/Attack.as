package actions{
	import flash.events.*;
	import flash.media.*;
	
	public class Attack implements IAction {

		var soundChannel = null;
		var currentSound = null;
		var zombieHitSound = null;
		var survivorShoveSound = null; // not yet used
		
		public function Attack(){
			
			zombieHitSound = new ZombieAttackHitSound();
		}
		
		public function performAction(you, opponent=null):void {
			
			you.setDirection(you.getAngleTo(opponent));

			if (you is Zombie)
			{
				if (currentSound == null)
				{
					currentSound = zombieHitSound;
					soundChannel = zombieHitSound.play();
					soundChannel.addEventListener(Event.SOUND_COMPLETE, resetSound);					
				}
				
				if(!opponent.isAlive)
				{
//					trace(you.name + " got his 10 bonus health points for killing " + opponent.name);
					you.increaseHealth(10);
				}else{
					opponent.decreaseHealth(1);
					you.increaseHealth(1);
				}
			}
			else if (you is Survivor)
			{
				if(you.hasAWeapon())
				{
					you.getWeapon().useItem(you, opponent);
				}
			}
		}
		
		private function resetSound(event)
		{
			currentSound = null;
		}
	}
}