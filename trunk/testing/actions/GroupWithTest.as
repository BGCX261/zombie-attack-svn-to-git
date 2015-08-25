package testing.actions {
	import asunit.framework.TestCase;
	import actions.*;

	public class GroupWithTest extends TestCase {
		private var _instance:GroupWith;

		/**
 		 * Constructor
 		 *
 		 * @param testMethod Name of the method to test
 		 */
 		public function GroupWithTest(testMethod:String) {
 			super(testMethod);
 		}

		/**
	 	 * Prepare for test, create instance of class that we are testing.
	 	 * Invoked by TestCase.runMethod function.
	 	 */
		protected override function setUp():void {
	 		_instance = new GroupWith();
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
	 		assertTrue("GroupWith instantiated", _instance is GroupWith);
	 	}

		/**
	 	 * Test action being performed
	 	 */
	 	public function testPerformAction():void {
			var opponent = new Zombie();
			var you = new Zombie();
			opponent.x = 100;
			opponent.y = 100;
			you.x = 120;
			you.y = 120;
			var before:Number = you.getDistanceTo(opponent);
			_instance.performAction(you, opponent);
			var after:Number = you.getDistanceTo(opponent);			
			assertTrue("You grouped with", after<before);
	 	}

		public function testNoOpponent():void {
			var you = new Zombie();
			_instance.performAction(you, null);	
			assertTrue("Didn't die", true);
	 	}

	}
}