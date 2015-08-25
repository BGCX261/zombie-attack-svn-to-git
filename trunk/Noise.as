package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.text.*;
	
	public class Noise extends Sprite 
	{
		//private var timer:Timer;
		//private var clockSpeed:int = 30;

		var maxRadius = 200;
		var radius = 200;

		var room;
				
		var circle:Sprite = new Sprite();
				
		public function Noise()
		{
			init();	
			initSprite();
		}

		public function initSprite()
		{
			circle.graphics.lineStyle(1, 0xAAFFAA);
			circle.graphics.drawCircle(0, 0, this.radius);
			addChild(circle);
		}
		
		function destroy()
		{
			/*this.timer.stop();
			this.removeEventListener(TimerEvent.TIMER, step);
			this.timer = null;*/
			if (room)
			{
				room.remove(this);
			}
		}
		
		public function init() 
		{
			/*timer = new Timer(this.clockSpeed);
			timer.addEventListener(TimerEvent.TIMER, step);
			timer.start();*/
		}
				
		public function setRoom(room){
			this.room = room;
		}
		
		public function step(event:TimerEvent)
		{
			this.radius -= 10;
			
			circle.scaleX = circle.scaleY = (radius / maxRadius);

			if (this.radius <= 0)
			{
				this.destroy();
			}
		}
		

	}
	
}