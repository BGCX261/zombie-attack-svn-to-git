package {
	import flash.display.*;
	import flash.utils.Timer;	
	import flash.events.TimerEvent;
	import gameitems.*;
	
	public class ItemList extends Sprite {
		
		var list:Sprite;
		var listTimer:Timer;
		var requestDelay:Number = 3000;
		var itemArray:Array;
		public var factory:GameItemFactory;
		
		public function ItemList() {
			init();	
		}
		
		public function init() {
			initSprite();
			factory = new GameItemFactory();
			itemArray = new Array();
			refresh();
		}
		
		public function initSprite()
		{
			list = new Sprite();
			list.graphics.lineStyle(2, 0xCCCCCC);
			list.graphics.drawRect(-(50-2), 2, 100 - 4, 800 - 4);
			list.graphics.endFill();
			list.x = 50-2;
			addChild(list);
		}
		
		private function initTimer()
		{
			listTimer = new Timer(this.requestDelay);
			listTimer.addEventListener(TimerEvent.TIMER, listStep);
			listTimer.start();
		}
		
		public function getNextItem()
		{
			var returnItem = itemArray.shift();
			refresh();
			return returnItem;
		}
		
		private function listStep(event:TimerEvent)
		{
			if (itemArray.length <= 5)
			{
				itemArray.push(factory.getItem());
			}
			refresh();
		}
		
		private function refresh()
		{
			var startHeight = 0;
			for each (var item:Sprite in itemArray)
			{
				startHeight += item.height+10;
				item.y = startHeight;
				list.addChild(item);
			}
		}
		
		public function reset()
		{
			listTimer.stop();
			
			while(itemArray.length > 0)
			{
				list.removeChild(itemArray.pop());
			}
		}
		
		public function start()
		{
			initTimer();
		}
	}
}