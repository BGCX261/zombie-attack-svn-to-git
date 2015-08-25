package testing.actions {
	import asunit.framework.TestCase;
	import actions.*;

	public class ShoveTest extends TestCase {
		private var _instance:Shove;

		/**
 		 * Constructor
 		 *
 		 * @param testMethod Name of the method to test
 		 */
 		public function ShoveTest(testMethod:String) {
 			super(testMethod);
 		}

		/**
	 	 * Prepare for test, create instance of class that we are testing.
	 	 * Invoked by TestCase.runMethod function.
	 	 */
		protected override function setUp():void {
	 		_instance = new Shove();
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
	 		assertTrue("Shove instantiated", _instance is Shove);
	 	}

		/**
	 	 * Test action being performed
	 	 */
	 	public function testPerformAction():void {
			var opponent = new Zombie();
			var you = new Survivor();
			opponent.x = 100;
			opponent.y = 100;
			you.x = 120;
			you.y = 120;
			you.inspect();
			var before:Number = you.getDistanceTo(opponent);
			_instance.performAction(you, opponent);
			var after:Number = you.getDistanceTo(opponent);
			assertTrue("You didn't shove!", after>before);
	 	}

		public function testTooFarToShove():void {
			var opponent = new Zombie();
			var you = new Survivor();
			opponent.x = 100;
			opponent.y = 100;
			you.x = 220;
			you.y = 120;
			var before:Number = you.getDistanceTo(opponent);
			_instance.performAction(you, opponent);
			var after:Number = you.getDistanceTo(opponent);
			assertTrue("You shoved!", after==before);
	 	}

		public function testNoOpponent():void {
			var you = new Survivor();
			var beforeX:Number = you.x;
			var beforeY:Number = you.y;
			_instance.performAction(you, null);
			assertTrue("You stayed put", you.x == beforeX || you.y == beforeY);
	 	}

	}
}