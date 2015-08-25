package testing {
	import asunit.framework.TestCase;
	import gameitems.*;

	public class NPCTest extends TestCase {
		private var _instance:NPC;

		/**
 		 * Constructor
 		 *
 		 * @param testMethod Name of the method to test
 		 */
 		public function NPCTest(testMethod:String) {
 			super(testMethod);
 		}

		/**
	 	 * Prepare for test, create instance of class that we are testing.
	 	 * Invoked by TestCase.runMethod function.
	 	 */
		protected override function setUp():void {
	 		_instance = new NPC();
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
	 		assertTrue("NPC instantiated", _instance is NPC);
	 	}
		
		/**
		 * Test whether the NPC can be damaged
		 */
	 	public function testInflictDamage():void {
			var before:Number = _instance.health
			_instance.decreaseHealth(1);
	 		assertTrue("NPC damaged", _instance.health < before);
	 	}
		
		public function testGetFrameNumber_1():void {
			_instance.setDirection(270);
			var number = _instance.getFrameNumber();
			trace(number);//TMP
			assertEquals("Wrong frame number", number, 8);
		}
		
		public function testNPCHasShotgun():void {			
			var shotgun = new Shotgun();
			_instance.add(shotgun);
			
			var shotguns = _instance.getItems("Shotgun");
			
			assertTrue("No shotgun found", shotguns.length > 0);
		}
		
		public function testLoadFullShotgun():void {
			var shotgun = new Shotgun();
			var shotgunShellsBefore = shotgun.shells;
			_instance.add(shotgun);
			
			var shotgunShells = new ShotgunShells();
			var ammoShellsBefore = shotgunShells.shells;
			
			shotgunShells.useItem(_instance, null);
			assertEquals("Shotgun shells not the same", shotgun.shells, shotgunShellsBefore);
			assertEquals("Ammo shells not the same", shotgunShells.shells, ammoShellsBefore);
			
		}
		
		public function testLoadEmptyShotgun():void {
			var shotgun = new Shotgun();
			shotgun.shells = 0;
			
			var shotgunShells = new ShotgunShells();
			var ammoShellsBefore = shotgunShells.shells;

			_instance.add(shotgun);			
			_instance.add(shotgunShells);
			
			shotgunShells.useItem(_instance, null);
			assertEquals("Shotgun shells didn't fully load.", ammoShellsBefore, shotgun.shells);
			assertTrue("Ammo shells not empty", shotgunShells.shells == 0);
		}
		
		public function testRemoveItemFromInventory():void {
			var shotgun = new Shotgun();
			
			_instance.add(shotgun);
			var numberOfItems = _instance.items.length;
			
			_instance.remove(shotgun);
			
			assertEquals("No object removed", _instance.items.length, numberOfItems -1);
		}
		public function testLoadTwoShotguns():void {
			var shotgun1 = new Shotgun();
			shotgun1.shells = 2;
			var shotgun2 = new Shotgun();
			shotgun2.shells = 4;
			var shotgunShellsBefore = shotgun1.shells + shotgun2.shells;
			
			var shotgunShells = new ShotgunShells();
			var ammoShellsBefore = shotgunShells.shells;

			_instance.add(shotgun1);			
			_instance.add(shotgun2);
			_instance.add(shotgunShells);
			
			shotgunShells.useItem(_instance, null);
			assertEquals("Shotgun shells didn't fully load.", ammoShellsBefore + shotgunShellsBefore, shotgun1.shells + shotgun2.shells);
			assertTrue("Ammo shells not empty", shotgunShells.shells == 0);
		}
	}
}