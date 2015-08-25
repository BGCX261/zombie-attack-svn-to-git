package testing {
	import asunit.framework.TestCase;
	import gameitems.*;

	public class SurvivorTest extends TestCase {
		private var _instance:Survivor;

		/**
 		 * Constructor
 		 *
 		 * @param testMethod Name of the method to test
 		 */
 		public function SurvivorTest(testMethod:String) {
 			super(testMethod);
 		}

		/**
	 	 * Prepare for test, create instance of class that we are testing.
	 	 * Invoked by TestCase.runMethod function.
	 	 */
		protected override function setUp():void {
	 		_instance = new Survivor();
	 	}

		/**
	 	 * Clean up after test, delete instance of class that we were testing.
	 	 */
	 	protected override function tearDown():void {
	 		_instance = null;
	 	}

		/**
	 	 * Test of whether or not class properly instantiated
	 	 */
	 	public function testInstantiated():void {
	 		assertTrue("Survivor instantiated", _instance is Survivor);
	 	}
		
		public function testTurnedToZombie():void {
			var room = new Room();
			room.add(_instance);
			var index = room.getChildIndex(_instance);
			room.replaceMeWithZombie(_instance);			
			assertTrue("Zombified", room.getChildAt(index) is Zombie);
		}
		
		public function testBravery():void {
			var shotgun = new Shotgun();
			_instance.add(shotgun);
			_instance.calculateBravery();
			assertTrue("Scared", _instance.bravery == 120);
		}

	}
}