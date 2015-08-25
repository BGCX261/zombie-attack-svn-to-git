package gameitems{
	import flash.display.*;
	import flash.media.*;
	import flash.net.*;
	
	public class ShotgunShells extends AGameItem {
		
		public var shells:int = 6;
		
		public function ShotgunShells(){
			this.init();
		}

		public override function init() 
		{
			super.init();
			canBeTaken = true;
			maxInInventory = 3;
			isWeapon = false;
			name = 'ShotgunShells';
		}
		
		public override function initSprite()
		{
			this.mainSprite = new ShellsSprite();
//			mainSprite.graphics.beginFill(0x976868);
//			mainSprite.graphics.drawCircle(0, 0, 8);
			super.initSprite();
		}
		
		public override function useItem(you, opponent=null):void
		{
			super.useItem(you, opponent);

			var shotguns = you.getItems('Shotgun');
			for each (var shotgun in shotguns)
			{
				while (shells > 0 && shotgun.addShell())
				{
					trace("Reloading shotgun");
					shells--;
				}
				if (shells == 0)
				{
					break;
				}
			}
			if (shells == 0)
			{
				you.remove(this);
			}
		}
		
		public override function takeItem(you):void
		{
			if (you.canTakeItem(this))
			{			
				you.circle1.graphics.beginFill(0x976868);
				you.circle1.graphics.drawCircle(0, 0, 12);					
				you.circle1.graphics.endFill();
	
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