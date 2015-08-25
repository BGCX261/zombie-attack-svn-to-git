package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.text.*;
	import flash.media.*;
	import flash.net.*;
	import actions.*;
	
	public class Zombie extends NPC 
	{		
		var lEye:Sprite = new Sprite();
		var rEye:Sprite = new Sprite();
		var line:Sprite = new Sprite();
		var view:Sprite = new Sprite();
		var hearingField:Sprite = new Sprite();
		private var healthCounter:uint = 0;
		
		var groanSounds = new Array();
		var currentGroan = null;
	
		public function Zombie()
		{
			super();
						
			dieSound = new ZombieDeathSound();
			
			groanSounds.push(new ZombieGroan1());
			groanSounds.push(new ZombieGroan2());
			groanSounds.push(new ZombieGroan3());
			groanSounds.push(new ZombieGroan4());
//			groanSounds.push(new ZombieGroan5());
			
			stepSize = 1;
			hearDist = 180;
		}

		public override function initSprite()
		{
			super.initSprite();
			
			this.isometricSprite = new ZombieSprite();
			if (isometricSprite)
			{
				addChild(this.isometricSprite);
			
				nameText.autoSize = TextFieldAutoSize.LEFT;
				nameText.x -= (this.isometricSprite.width / 2) - 30;
				nameText.y -= (this.isometricSprite.height / 2) + 55;
				addChild(nameText);
				nameText.scaleX = nameText.scaleY = 2.0;

				statsText.autoSize = TextFieldAutoSize.LEFT;
				statsText.x -= (this.isometricSprite.width / 2) - 30;
				statsText.y -= (this.isometricSprite.height / 2) + 25;
				addChild(statsText);			
				statsText.scaleX = statsText.scaleY = 2.0;
			}
		}
		
		function getRandomGroanSound()
		{
			var index = (int)(Math.random() * groanSounds.length);
			return groanSounds[index];			
		}		


		
		public override function think(event:TimerEvent)
		{									
			this.updateHearableThings();
			this.updateVisibleThings();

			var groanChance = 0.005;
			
			if (closestVisibleSurvivor)
			{
				if (getDistanceTo(closestVisibleSurvivor) <= 30)
				{
					groanChance = 0.01;
					attack.performAction(this, closestVisibleSurvivor);
				}
				else
				{
					groanChance = 0.005;
					runTowards.performAction(this, closestVisibleSurvivor);					
				}
			}
			else if (closestHearableThing)// can they hear a survivor?
			{
				if (Math.random() < 0.7) // probably run towards them
				{
					runTowards.performAction(this, closestHearableThing);
					groanChance = 0.005;
				}
			}			
			else
			{
				speed = getWalkSpeed();
				if (closestVisibleZombie)
				{
					groupWith.performAction(this, closestVisibleZombie);
				}
				else
				{
					super.think(event);
				}
			}
			var foundBoundary = applyBoundary();

			if (foundBoundary && !closestVisibleSurvivor)
			{
				this.setDirection(this.getDirection() + 180);
			}			
			
			healthCounter++;
			if (healthCounter > 100)
			{
				decreaseHealth(1);
				healthCounter = 0;
			}
			
			if (health <= 0)
			{
				die();
			}
			
			if (Math.random() <= groanChance)
			{
				if (currentGroan == null)
				{
//					trace(name+" groans");//TMP
					currentGroan = getRandomGroanSound();
					soundChannel = currentGroan.play();
					soundChannel.addEventListener(Event.SOUND_COMPLETE, resetCurrentGroan);
				}
			}
			
			statsText.text = "H: "+this.health+ " S: "+this.getRunSpeed();// + "%";
		}
		
		function resetCurrentGroan(event)
		{
//			trace("current groan reset");//TMP
			currentGroan = null;
		}

		public override function die()
		{			
			ZombieAttack.scoreBox.decrementScore(100);
			
			this.isometricSprite.gotoAndStop(2);
			this.isometricSprite.rotation = 90;
			
			dieSound.play();
			super.die();
		}
	}
}