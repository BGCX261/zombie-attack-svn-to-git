package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.text.*;
	import flash.media.*;
	import flash.net.*;
	import actions.*;
	
	public class Survivor extends NPC {
			
		var origin:Sprite = new Sprite();
		var line:Sprite = new Sprite();
		var view:Sprite = new Sprite();
		var iCanSee:TextField = new TextField();
		
		public var circle1:Sprite = new Sprite();

		var diameter = 30;
		
		public var maxBravery = 200;
		public var bravery = 200;

		public function Survivor()
		{
			super();
			dieSound = new Scream();
		}

		public override function initSprite() 
		{
			super.initSprite();
			
			this.viewDist = 150;
			circle1.graphics.beginFill(0x0000F5);
			circle1.graphics.drawCircle(0, 0, diameter);
			
			origin.graphics.beginFill(0x03D49E);
			origin.graphics.drawCircle(0, 0, 1);
			
			line.graphics.beginFill(0x000000);
			line.graphics.drawRect(0, 0, diameter, 1);
			line.graphics.endFill();
			
			view.graphics.lineStyle(1, 0xDDDDDD);
			view.graphics.drawCircle(0, 0, viewDist);
			view.graphics.drawRect(0, -this.viewDist, 1, this.viewDist*2);
			
			iCanSee.y = 30;

			statsText.autoSize = TextFieldAutoSize.LEFT;
			statsText.x -= (this.circle1.width / 2) - 30;
			statsText.y -= (this.circle1.height / 2) + 25;
			statsText.scaleX = statsText.scaleY = 2.0;			
			
//			addChild(view);
			addChild(circle1);
			addChild(origin);
			addChild(line);
			addChild(statsText);
//			addChild(nameText);
//			addChild(iCanSee);
		}
		
		public override function setDirection(value:Number):void
		{
			this.direction = value;
			this.rotation = value;
//			trace(this.name+": direction: "+direction);//TMP
		}
		
		public override function think(event:TimerEvent)
		{
			this.updateHearableThings();
			this.updateVisibleThings();
			
			this.calculateBravery();
						
			var shotgunShells = getItems('ShotgunShells');
			if(shotgunShells.length > 0)
			{
				shotgunShells[0].useItem(this, null);
			}
						
			if (closestVisibleZombie)
			{
				var distance = getDistanceTo(closestVisibleZombie);
				var isAttacked = (distance <= 20);
				
				if (isAttacked)
				{
					//@todo: if brave enough and has a weapon
					// pick weapon with shortest range within attack range and use it
					if (hasAWeapon())
					{
						attack.performAction(this,closestVisibleZombie);
					}
					
					if (Math.random() < 0.7)
					{
//						currentAction = 'shove';//TMP
						shove.performAction(this,closestVisibleZombie);
					}
				}
				
				if (bravery > 100)
				{
					for (var i = 0; i < items.length; i++)
					{
						if (items[i].isWeapon && items[i].weaponRange >= distance)
						{							
							attack.performAction(this, closestVisibleZombie);
							break;
						}
					}
					
					if(bravery > 180) //is super brave, run towards, possibly shouting
					{
						runTowards.performAction(this, closestVisibleZombie);
					}
					else
					{
						runAway.performAction(this, closestVisibleZombie);
					}
				}
				else
				{
					runAway.performAction(this, closestVisibleZombie);
				}
				
			}
			else if (closestVisibleItem && this.canTakeItem(closestVisibleItem))
			{
				runTowards.performAction(this,closestVisibleItem);				
				takeItem.performAction(this,closestVisibleItem);
			}
			else if (closestHearableZombie)// can they hear a zombie?
			{
//				currentAction = 'runaway from hearable';//TMP
				runAway.performAction(this,closestHearableZombie);
			}
			else
			{
				if (closestVisibleSurvivor) // no zombies, group with other survivors
				{
//					trace(this.name + " grouping with "+closestVisibleSurvivor.name);//TMP
//					currentAction = 'groupwith';//TMP
					groupWith.performAction(this, closestVisibleSurvivor);
				}
				else if (closestHearableSurvivor)
				{
					turnTowards.performAction(this,closestHearableSurvivor);
				}
				else
				{
					super.think(event);
				}
			}
//			this.doMovementWrap();
			var foundBoundary = this.applyBoundary();
			
			if (foundBoundary)
			{
				this.setDirection(this.getDirection() + 180);
			}			
			
			statsText.text = "H: "+this.health+ " S: "+this.getRunSpeed()+" Br: "+this.bravery;// + "%";			
//			trace(statsText.text);//TMP
		}
		
		public function calculateBravery()
		{
			bravery = (maxBravery / 2); // reset to half max
			
			bravery -= (maxHealth - health) * 0.5; // scared if hurt
						
			if (visibleZombies.length == 0) // braver if no zombies
			{
				bravery += 20;
			}
			else // more scared if more zombies
			{
				bravery -= (10 * visibleZombies.length);
			}

			if (hearableZombies.length == 0) // braver if no zombies
			{
				bravery += 20;
			}
			else // more scared if more zombies
			{
				bravery -= (5 * visibleZombies.length);				
			}
			
			// more scared the closer a zombie is
			if (closestVisibleZombie)
			{
				var dist = this.getDistanceTo(closestVisibleZombie);
				if (dist > 0)
				{
					bravery -= (1/dist * maxBravery);
				}
			}
			
			if (hearableSurvivors.length > 0) // braver if more suvivors
			{
				bravery += (5 * hearableSurvivors.length);
			}

			if (visibleSurvivors.length > 0) // braver if more suvivors
			{
				bravery += (10 * visibleSurvivors.length);
			}
			
			if (this.hasAWeapon()) // braver if carrying weapon
			{
				bravery += 20;
			}
			
			bravery = Math.min(maxBravery, bravery);
			//trace(this.name + " bravery: "+ bravery);//TMP
		}
		
		/**
		 * inflict damage on a survivor and maybe change into a zombie
		 */
		public override function decreaseHealth(amount)
		{
			super.decreaseHealth(amount);
			if (this.health <= 0)
			{
				var chanceOfTurning:Number = Math.random();
//				trace(name + " has a "+ chanceOfTurning + " chance of being killed");
				if (chanceOfTurning > 0.3) // brain eaten
				{
					die();
				}
				else
				{
					turnIntoAZombie();
				}
			}
		}
				
		public function turnIntoAZombie()
		{
			die();
			room.replaceMeWithZombie(this);
        }
		
		
		public override function die()
		{
			if (this.hasAWeapon())
			{
				ZombieAttack.scoreBox.incrementScore(200);
			}
			else
			{
				ZombieAttack.scoreBox.incrementScore(100);				
			}

			dieSound.play();
			
			circle1.graphics.beginFill(0x17B585); // sickly green
			circle1.graphics.drawCircle(0, 0, this.diameter);					
			circle1.graphics.endFill();					

			super.die();
		}
		
		public function hasAWeapon()
		{
			for each(var item in items)
			{
				if(item.isWeapon)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function getWeapon()
		{
			var weapon = null;
			
			for each(var item in items)
			{
				if(item.isWeapon)
				{
					weapon = item;
					break;
				}
			}
			
			return weapon;
		}
	}
}