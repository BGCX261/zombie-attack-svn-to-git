package gameitems{
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	
	public class Axe extends AGameItem {
		
		var soundChannel = null;
		var prepareSound = null;
		
		public function Axe(){
			this.init();
		}

		public override function init() 
		{
			super.init();
			canBeTaken = true;
			maxInInventory = 1;
			weaponRange = 30;
			name = 'Axe';			
			prepareSound = new WeaponSwingSound();
			useSound = new AxeChopSound();
		}
		
		public override function initSprite()
		{
			mainSprite = new AxeSprite();
//			mainSprite.graphics.beginFill(0xF50000);
//			mainSprite.graphics.drawCircle(0, 0, 8);
			super.initSprite();
		}
		
		public override function useItem(you, opponent=null):void
		{
			var dist = you.getDistanceTo(opponent);
			
			if (dist <= weaponRange)
			{
				super.useItem(you, opponent);
				
				if (opponent)
				{
					opponent.decreaseHealth(100 * you.health/you.maxHealth);
					
					if (dist<=30)
					{
						var shove_distance = 25;
						
						var angle:Number = you.getAngleTo(opponent) + (Math.random() * 80 - 40);
						you.setDirection(angle);
						var shove:Number = shove_distance * you.health/you.maxHealth;
						var dy:Number  = shove * Math.sin(angle * Math.PI/180);
						var dx:Number  = shove * Math.cos(angle * Math.PI/180);				
						opponent.x += dx;
						opponent.y += dy;
					}		
				}
				
				soundChannel = prepareSound.play();
				soundChannel.addEventListener(Event.SOUND_COMPLETE, playUseSound);
			}
		}
		
		function playUseSound(event)
		{
			return useSound.play();
		}
		
		public override function takeItem(you):void
		{
			if (you.canTakeItem(this))
			{			
//				you.circle1.graphics.beginFill(0xF50000); // red
//				you.circle1.graphics.drawCircle(0, 0, 12);					
//				you.circle1.graphics.endFill();
				super.takeItem(you);
			}
		}
		
		public override function dropItem(you):void
		{
			super.dropItem(you);			
		}
		
		public override function draw(graphics:Graphics):void
		{
			super.draw(graphics);						
		}				
	}
}