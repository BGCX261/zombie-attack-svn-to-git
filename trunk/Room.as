package {
	import flash.display.*;
	import com.gskinner.sprites.ProximityManager;
	
	public class Room extends Sprite {

		var rectangle = new Sprite();
		public var proximityManager:ProximityManager;
		public var scale:Number = 0.5;
				
		public function Room() {
			init();	
		}
		
		public function init() {
			this.proximityManager = new ProximityManager(90);
			initSprite();
		}
		
		public function initSprite()
		{
			this.x = 98;
			rectangle.graphics.lineStyle(2, 0xCCCCCC);
			rectangle.graphics.drawRect(2, 2, 900 - 4, 800 - 4);
			rectangle.graphics.endFill();
			addChild(rectangle);
		}

		public function clearContents()
		{
			for (var i = this.numChildren-1; i >= 0; i--)
			{
				if (getChildAt(i) != rectangle)
				{
					trace("removing child "+i+" "+getChildAt(i).name);//TMP
					removeChild(getChildAt(i));
				}
			}
		}
		
		public function add(child)
		{
			proximityManager.addItem(child);
			addChild(child);
			child.setRoom(this);
		}
		
		public function remove(child)
		{
			proximityManager.removeItem(child);
			removeChild(child);
			child.setRoom(null);
		}
		
		public function replaceMeWithZombie(survivor:NPC)
		{
			var zombie = new Zombie();
			zombie.setDirection(survivor.getDirection());
			zombie.x = survivor.x;
			zombie.y = survivor.y;
			zombie.npcName = survivor.name+" (infected)";
			
//			trace(survivor.name + " turned into a zombie");
//			trace("child #"+this.getChildIndex(survivor));
			
			survivor.destroy();
			
			add(zombie);
		}
	}
}