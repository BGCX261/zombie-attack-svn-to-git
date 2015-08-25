package testing{
	import asunit.textui.TestRunner;

	public class AsUnitTestRunner extends TestRunner {
		public function AsUnitTestRunner() {
			trace("In thing");
			start(AllTests, null, TestRunner.SHOW_TRACE);
		}
	}
}