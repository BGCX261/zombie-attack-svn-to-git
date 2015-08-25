package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.text.*;
	import flash.media.*;
	import flash.net.*;
	import actions.*;
	import gameitems.*;
	
	public class NPC extends Sprite 
	{
		public var stepSize:int = 2;

		var nameText:TextField = new TextField();
		var statsText:TextField = new TextField();

		public var viewDist = 80;
		var hearDist = 80;
		
		public var room;
		var neighbours:Array;
		
		public var items:Array = new Array();
		private var maxItems:int = 2;
		
		var direction:Number = 0;
		var oldDirection:Number = 0;
				
		public var isometricSprite:MovieClip;
		
		public var maxHealth = 200;
		public var health = 200;
				
		private var maxSpeed = 100; // percent		
		public var speed = 0; // percent

		var runTowards:IAction = new RunTowards();
		var turnTowards:IAction = new TurnTowards();
		var groupWith:IAction = new GroupWith();
		var attack:IAction = new Attack();
		var runAway:IAction = new RunAway();
		var randomMovement:IAction = new RandomMovement();
		var shove:IAction = new Shove();
		var takeItem:IAction = new TakeItem();

		var isAttacked = false;
		public var isAlive = true;
				
		var soundChannel:SoundChannel = null;
		var dieSound = new Sound();
		
		var visibleSurvivors:Array;
		var visibleZombies:Array;
		var visibleItems:Array;
		var hearableSurvivors:Array;
		var hearableZombies:Array;
		var hearableNoises:Array;

		var closestVisibleSurvivor = null;
		var closestVisibleZombie = null;
		var closestVisibleItem = null;
		var closestHearableSurvivor = null;
		var closestHearableZombie = null;
		var closestHearableThing = null;
		var closestHearableNoise = null;

		public function NPC()
		{
			initSprite();
		}
		
		public function initSprite()
		{
		}

		public function setScale(scale)
		{
			this.scaleX = this.scaleY = scale;
		}
		
		function destroy()
		{
			room.remove(this);
		}
		
		public function setRoom(room=null) 
		{
			this.room = room;
			if (room)
			{
				setScale(room.scale);
			}
		}
				
		public function step(event:TimerEvent)
		{
			this.think(event);
		}
				
		public function getDirection():Number
		{
			return this.direction;
		}

		public function setDirection(value:Number):void
		{
			this.direction = value;
			var frameNumber = this.getFrameNumber();
			if (isometricSprite)
			{
				isometricSprite.gotoAndStop(frameNumber);			
			}
		}

		public function getFrameNumber():uint
		{
			var normalDirection:Number = this.direction % 360;
			normalDirection += 360;
			var frameNumber:uint = Math.abs(((normalDirection % 360) / 45)) + 1;
			switch( frameNumber ) {
				case 1:
					return 6;
					break;
				case 2:
					return 5;
					break;
				case 3:
					return 4;
					break;
				case 4:
					return 3;
					break;
				case 5:
					return 2;
					break;
				case 6:
					return 1;
					break;
				case 7:
					return 8;
					break;
				case 8:
					return 7;
					break;				
			}
			return frameNumber;
		}
		
		public function set npcName(value:String):void 
		{
			this.name = value;
			nameText.text = this.name;
		}
		
		public function getWalkSpeed():Number
		{
			return this.getRunSpeed() * 0.7;
		}
		
		public function getRunSpeed():Number
		{
			return maxSpeed * (health / maxHealth);
		}
		
		public function getItems(itemType)
		{
			var itemsInHand:Array = new Array();
			for (var i = 0; i < items.length; i++)
			{
				if (items[i].name == itemType)
				{
					itemsInHand.push(items[i]);
				}
			}
			return itemsInHand;
		}
		
		public function hasItemType(item)
		{
			for (var i = 0; i < items.length; i++)
			{
				if (items[i].name == item.name)
				{
					return true;
				}
			}
			return false;
		}
		
		public function canTakeItem(item)		
		{			
			var canTake = false;
			if (item.canBeTaken)
			{
				if (!this.hasItemType(item) || item.maxInInventory > 1)
				{
					canTake = true;
				}
			}
			return canTake;
		}											

		public function updateHearableThings()
		{
			getHearableThings();
			
			closestHearableSurvivor = this.getClosest(hearableSurvivors);
			closestHearableZombie = this.getClosest(hearableZombies);
			closestHearableNoise = this.getClosest(hearableNoises);
			closestHearableThing = (closestHearableNoise ? closestHearableNoise : closestHearableSurvivor); // hears noise over survivors
		}
		
		public function updateVisibleThings()
		{
			getVisibleThings();
			
			closestVisibleSurvivor = getClosest(visibleSurvivors);
			closestVisibleZombie = getClosest(visibleZombies);									
			closestVisibleItem = getClosest(visibleItems);
		}
		
		public function getVisibleThings()
		{
			visibleSurvivors = new Array();
			visibleZombies = new Array();
			visibleItems = new Array();
			
			neighbours = room.proximityManager.getNeighbors(this);
			for (var i:uint = 0; i < neighbours.length; i++) 
			{
				var s:Sprite = neighbours[i] as Sprite;				
				if (s is Survivor && s != this)
				{
					var survivor:Survivor = s as Survivor;					
					if (canSee(survivor) && survivor.isAlive)
					{
						visibleSurvivors.push(survivor);
					}
				}
				else if (s is Zombie && s != this)
				{
					var zombie:Zombie = s as Zombie;					
					if(canSee(zombie) && zombie.isAlive)
					{
						visibleZombies.push(zombie);
					}
				}
				else if (s is AGameItem)
				{
					var item:AGameItem = s as AGameItem;
					if(canSee(s))
					{
						visibleItems.push(s);
					}
				}
			}
		}
		
		public function getHearableThings()
		{
			hearableSurvivors = new Array();
			hearableZombies = new Array();
			hearableNoises = new Array();
			
			neighbours = room.proximityManager.getNeighbors(this);
			for (var i:uint = 0; i < neighbours.length; i++) 
			{
				var s:Sprite = neighbours[i] as Sprite;
				if (s is Survivor && s != this)
				{
					var survivor:Survivor = s as Survivor;
					if (isWithinRadius(survivor, hearDist) && survivor.isAlive)
					{
						hearableSurvivors.push(survivor);
					}
				}
				else if (s is Zombie && s != this)
				{
					var zombie:Zombie = s as Zombie;
					if (isWithinRadius(zombie, hearDist) && zombie.isAlive)
					{
						hearableZombies.push(zombie);
					}
				}
				else if (s is Noise)
				{
					if (isWithinRadius(s, hearDist))
					{
						hearableNoises.push(s);
					}
				}
			}
		}

		public function getClosest(npcs)
		{
			if (npcs.length == 0)
			{
				return null;
			}
			var closest = npcs[0];
			var closestDistance = this.getDistanceTo(closest);
			for (var i = 0; i < npcs.length; i++)
			{
				var s = npcs[i];
				var distance = this.getDistanceTo(s);
				
				if (distance < closestDistance)
				{
					closest = s;
					closestDistance = distance;
				}
			}
			return closest;
		}
				
		public function think(event:TimerEvent)
		{
			randomMovement.performAction(this);
		}

		public function getDistanceTo(sprite)
		{
			var dx = Math.abs(sprite.x - this.x);
			var dy = Math.abs(sprite.y - this.y);
			var currentDist:Number = Math.floor(Math.sqrt(dx*dx+dy*dy));
			return currentDist;
		}

		public function canSee(sprite)
		{
			return this.isWithinSemiCircle(sprite, this.viewDist);
		}
		
		public function isWithinRadius(sprite, radius)
		{
			var currentDist:Number = this.getDistanceTo(sprite);
			return (currentDist <= radius);
		}
		
		public function isWithinSemiCircle(sprite, radius)
		{
			var currentDist:Number = this.getDistanceTo(sprite);
			var isWithinViewRadius = (currentDist <= radius);
			var leftViewAngle = this.direction - 90;
			var rightViewAngle = this.direction + 90;
			var angleToSprite = this.getAngleTo(sprite);
			var isWithinViewField = (angleToSprite > leftViewAngle && angleToSprite < rightViewAngle);
			return (isWithinViewRadius && isWithinViewField);
		}
		
		public function getAngleTo(sprite)
		{		
			var dx:Number = sprite.x - this.x;
			var dy:Number = sprite.y - this.y; 
			var angle = Math.atan2(dy, dx);
			var degrees = angle * 180 / Math.PI;
			return degrees;
		}

		public function getAngleFrom(sprite)
		{
			var dx:Number = this.x - sprite.x;
			var dy:Number = this.y - sprite.y; 
			var angle = Math.atan2(dy, dx);
			var degrees = angle * 180 / Math.PI;
			return degrees;
		}

		public function doMovementWrap()
		{
			if (this.x >= (this.room.rectangle.x + this.room.rectangle.width))
			{
				this.x = this.room.rectangle.x;
			}
			else if (this.x <= this.room.rectangle.x)
			{
				this.x = this.room.rectangle.x + this.room.rectangle.width;
			}
			if (this.y >= (this.room.rectangle.y + this.room.rectangle.height))
			{
				this.y = this.room.rectangle.y;
			}
			else if (this.y <= this.room.rectangle.y)
			{
				this.y = this.room.rectangle.y + this.room.rectangle.height;
			}			
		}
		
		public function applyBoundary()
		{
			var xBound = this.room.rectangle.x + this.room.rectangle.width;
			var yBound = this.room.rectangle.y + this.room.rectangle.height;
			var xDist = (this is Zombie ? this.width - 10 : this.width);
			var yDist = (this is Zombie ? this.height - 10 : this.height);
			var foundBoundary = true;
			if (this.x + xDist / 2 > xBound)
			{
				this.x = xBound - (xDist / 2);
			}
			else if (this.x - xDist / 2 < this.room.rectangle.x)
			{
				this.x = this.room.rectangle.x + (xDist / 2);
			}
			if (this.y + yDist / 2 > yBound)
			{
				this.y = yBound - (yDist / 2);
			}
			else if (this.y - yDist / 2 < this.room.rectangle.y)
			{
				this.y = this.room.rectangle.y + (yDist / 2);
			}
			else
			{
				foundBoundary = false;				
			}
			return foundBoundary;
		}		
		
		public function inspect()
		{
			trace("x=" + this.x + " y=" + this.y + " speed="+this.speed + " health="+this.health);
		}
		
		public function decreaseHealth(amount)
		{
			health -= amount;
			health = this.health < 0 ? 0 : this.health;
		}

		public function increaseHealth(amount)
		{
			health += amount;
			health = Math.min(this.maxHealth, this.health);
		}

		public function die()
		{		
			trace(name + " was killed");
			isAlive = false;
			dropItems();
		}
		
		public function add(item:AGameItem):Boolean 
		{
			var hasSpace = (items.length < maxItems)
			if(hasSpace){
				items.push(item);
			}
			return hasSpace;
		}
		
		public function dropItems()
		{
			trace(this.name+" should drop "+items.length+" items");
			while (items.length > 0)
			{
				items.pop().dropItem(this);
			}
		}
		
		public function remove(item:AGameItem)
		{
			var outputItemArray = new Array();
			for each (var heldItem in items)
			{
				if(heldItem!=item)
				{
					outputItemArray.push(heldItem);
				}
			}
			items = outputItemArray;
		}

	}
	
}