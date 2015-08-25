package testing.actions {
	import asunit.framework.TestCase;
	import actions.*;

	public class MoveTest extends TestCase {
		private var _instance:Move;

		/**
 		 * Constructor
 		 *
 		 * @param testMethod Name of the method to test
 		 */
 		public function MoveTest(testMethod:String) {
 			super(testMethod);
 		}

		/**
	 	 * Prepare for test, create instance of class that we are testing.
	 	 * Invoked by TestCase.runMethod function.
	 	 */
		protected override function setUp():void {
	 		_instance = new Move();
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
	 		assertTrue("Move not instantiated", _instance is Move);
	 	}

		/**
	 	 * Test action being performed
	 	 */
	 	public function testPerformAction():void {
			var you = new Survivor();
			you.x = 120;
			you.y = 120;
			you.speed = 50;
			_instance.performAction(you);
			assertTrue("You stayed still", (you.x != 120) || (you.y !=120));
	 	}

		/**
	 	 * Test that you don't move if you have 0 speed
	 	 */
	 	public function testNoSpeed():void {
			var you = new Survivor();
			you.x = 120;
			you.y = 120;
			you.speed = 0;
			_instance.performAction(you);
			assertTrue("You moved", you.x == 120 && you.y ==120);
	 	}

	}
}