package testing.actions {
	import asunit.framework.TestCase;
	import actions.*;
	import gameitems.*;

	public class AttackTest extends TestCase {
		private var _instance:Attack;

		/**
 		 * Constructor
 		 *
 		 * @param testMethod Name of the method to test
 		 */
 		public function AttackTest(testMethod:String) {
 			super(testMethod);
 		}

		/**
	 	 * Prepare for test, create instance of class that we are testing.
	 	 * Invoked by TestCase.runMethod function.
	 	 */
		protected override function setUp():void {
	 		_instance = new Attack();
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
	 		assertTrue("Attack instantiated", _instance is Attack);
	 	}

		/**
	 	 * Test action being performed
	 	 */
	 	public function testZombieAttacksSurvivor():void {
			var zombie = new Zombie();
			var survivor = new Survivor();
			_instance.performAction(zombie, survivor);
			survivor.inspect();
			assertTrue("You attacked", survivor.health < 200);
	 	}

		public function testSurvivorAttacksZombie():void {
			var zombie = new Zombie();
			var survivor = new Survivor();
			var shotgun = new Shotgun();
			survivor.add(shotgun);
			_instance.performAction(survivor, zombie);
			assertTrue("You attacked", zombie.health < 200);
	 	}

		public function testZombieAttacksZombie():void {
			var zombie1 = new Zombie();
			var zombie2 = new Zombie();
			_instance.performAction(zombie1, zombie2);
			assertTrue("You attacked", zombie2.health < 200);
	 	}

		public function testSurvivorAttacksSurvivor():void {
			var survivor1 = new Survivor();
			var survivor2 = new Survivor();
			var shotgun = new Shotgun();
			survivor1.add(shotgun);
			_instance.performAction(survivor1, survivor2);
			assertTrue("You attacked", survivor2.health < 200);
	 	}

	}
}