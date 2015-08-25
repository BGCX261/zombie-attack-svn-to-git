package {
	
	import gameitems.*;
	
	public class GameItemFactory 
	{
		public function GameItemFactory()
		{
		}
		
		public function getItem()
		{
			var mySelection = Math.ceil(Math.random()*3);
			switch(mySelection)
			{
				case 1:
					return new Shotgun();
					break;
				case 2:
					return new ShotgunShells();
					break;
				case 3:
					return new Axe();
					break;
			}
		}
	}
}