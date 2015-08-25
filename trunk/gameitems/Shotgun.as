package gameitems{
	import flash.display.*;
	import flash.media.*;
	import flash.net.*;
	
	public class Shotgun extends AGameItem {
		
		private var maxShells:int = 6;
		public var shells:int;
		
		public function Shotgun(){
			init();
		}

		public override function init() 
		{
			super.init();
			canBeTaken = true;
			maxInInventory = 2;
			shells = maxShells;
			weaponRange = 80;
			this.name = 'Shotgun';
			useSound = new ShotgunSound();
		}
		
		public override function initSprite()
		{
			this.mainSprite = new ShotgunSprite();
//			mainSprite.graphics.beginFill(0xF500F5);
//			mainSprite.graphics.drawCircle(0, 0, 8);		
			super.initSprite();
		}
		
		public override function useItem(you, opponent=null):void
		{
			var dist = you.getDistanceTo(opponent);
			
			if (dist <= weaponRange)
			{
				super.useItem(you, opponent);
				
				if (opponent && shells > 0)
				{
					var damage = 20 * you.health/dist;
					opponent.decreaseHealth(damage);
					shells--;
					trace(you.name+" attacking with shotgun, damage: "+damage+", shells left:"+shells);
					
					if(shells==0)
					{
//						you.circle1.graphics.beginFill(0x550055);
//						you.circle1.graphics.drawCircle(0, 0, 12);					
//						you.circle1.graphics.endFill();
					}
					
					if (dist<=60)
					{
						var shove_distance = 100;
						
						var angle:Number = you.getAngleTo(opponent) + (Math.random() * 80 - 40);
						you.setDirection(angle);
						var shove:Number = shove_distance * you.health/you.maxHealth;
						var dy:Number  = shove * Math.sin(angle * Math.PI/180);
						var dx:Number  = shove * Math.cos(angle * Math.PI/180);				
						opponent.x += dx;
						opponent.y += dy;
					}
					
					// recoil ?
					
					useSound.play();
				}			
			}
		}
		
		public override function takeItem(you):void
		{
			if (you.canTakeItem(this))
			{
//				you.circle1.graphics.beginFill(0xF500F5);
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
		
		public function addShell()
		{
			if(shells < maxShells)
			{
				shells++;
				return true;
			}
			return false;
		}
	}
}