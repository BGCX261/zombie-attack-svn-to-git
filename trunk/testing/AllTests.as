package testing{
	import asunit.framework.TestSuite;
	import testing.actions.*;

	public class AllTests extends TestSuite {
		public function AllTests() {
	 		super();
	 		objectTests();
			actionTests();
		}
		public function objectTests() {
			addTest(new NoiseTest("testInstantiated"));
			
			addTest(new NPCTest("testInstantiated"));
			addTest(new NPCTest("testInflictDamage"));
			addTest(new NPCTest("testGetFrameNumber_1"));
			addTest(new NPCTest("testNPCHasShotgun"));
			addTest(new NPCTest("testLoadFullShotgun"));
			addTest(new NPCTest("testLoadEmptyShotgun"));
			addTest(new NPCTest("testRemoveItemFromInventory"));
			addTest(new NPCTest("testLoadTwoShotguns"));
			
			addTest(new RoomTest("testInstantiated"));
			
			addTest(new SurvivorTest("testInstantiated"));
			addTest(new SurvivorTest("testTurnedToZombie"));
			
			addTest(new ZombieTest("testInstantiated"));
			addTest(new ZombieTest("atLeastYouveGotYourHealth"));
		}
		public function actionTests() {
			addTest(new ShoveTest("testInstantiated"));
			addTest(new ShoveTest("testPerformAction"));
			addTest(new ShoveTest("testNoOpponent"));

			addTest(new MoveTest("testInstantiated"));
			addTest(new MoveTest("testPerformAction"));
			addTest(new MoveTest("testNoSpeed"));
			
			addTest(new RunAwayTest("testInstantiated"));
			addTest(new RunAwayTest("testPerformAction"));
			addTest(new RunAwayTest("testNoOpponent"));

			addTest(new RunTowardsTest("testInstantiated"));
			addTest(new RunTowardsTest("testPerformAction"));
			addTest(new RunTowardsTest("testNoOpponent"));
			
			addTest(new GroupWithTest("testInstantiated"));
			addTest(new GroupWithTest("testPerformAction"));
			addTest(new GroupWithTest("testNoOpponent"));
			
			addTest(new AttackTest("testInstantiated"));
			addTest(new AttackTest("testZombieAttacksSurvivor"));
			addTest(new AttackTest("testSurvivorAttacksZombie"));
			addTest(new AttackTest("testZombieAttacksZombie"));
			addTest(new AttackTest("testSurvivorAttacksSurvivor"));
		}
	}
}