package testing {
	import asunit.framework.TestCase;

	public class ZombieTest extends TestCase {
		private var _instance:Zombie;

		/**
 		 * Constructor
 		 *
 		 * @param testMethod Name of the method to test
 		 */
 		public function ZombieTest(testMethod:String) {
 			super(testMethod);
 		}

		/**
	 	 * Prepare for test, create instance of class that we are testing.
	 	 * Invoked by TestCase.runMethod function.
	 	 */
		protected override function setUp():void {
	 		_instance = new Zombie();
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
	 		assertTrue("Zombie instantiated", _instance is Zombie);
	 	}
		
		public function atLeastYouveGotYourHealth():void {

		}

	}
}