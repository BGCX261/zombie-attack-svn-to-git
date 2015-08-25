package gameitems {
	import flash.display.*;

	public class AGameItem extends Sprite implements IGameItem {
		
		var mainSprite:Sprite = new Sprite();
		var room = null;
		public var canBeTaken = false;
		public var maxInInventory = 0;
		public var isWeapon = true;
		public var weaponRange = 0;
		var useSound = null;
		
		public function init() 
		{
			this.initSprite();
		}
		
		public function setRoom(room=null)
		{
			this.room = room;
			setScale();
		}

		public function setScale()
		{
			if (room)
			{
				this.scaleX = this.scaleY = room.scale;
			}
		}
		
		public function initSprite()
		{
			addChild(mainSprite);
		}

		public function useItem(you, opponent=null):void
		{
//			trace(you.name + " used " + this.name + " on " + opponent.name + " health is now " + opponent.health);
		}
		
		public function takeItem(you):void
		{
//			trace(you.name+" has taken an item: "+this.name);//TMP
			if (room && you.add(this))
			{
				room.remove(this);
				this.x = 0;
				this.y = 0;
				you.circle1.addChild(this);
			}
			
		}
		
		public function dropItem(you):void
		{			
			if (you.room)
			{
				trace("item parent: "+this.parent.name);
				trace(you.name+" dropped "+this.name);//TMP
				
				this.x = you.x +(Math.random() * 50 - 25);
				this.y = you.y +(Math.random() * 50 - 25);
				you.room.add(this);
				
				trace("item parent: "+this.parent.name);
			}
		}
		
		public function draw(graphics:Graphics):void
		{
			
		}
	}
}