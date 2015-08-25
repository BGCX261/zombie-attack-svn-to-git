package gameitems{
	import flash.display.*;
	
	public interface IGameItem {
		
		function useItem(you, opponent=null):void;
		
		function takeItem(you):void;
		
		function dropItem(you):void;
		
		function draw(graphics:Graphics):void;

	}
	
}