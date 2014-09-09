import haxe.unit.TestRunner;
#if js
import js.Lib;
#end

class TestMain
{
	static function main(){	new TestMain(); }

	public function new()
	{
		var runner = new TestRunner();
		
		runner.add(new ash.core.AshAndFamilyIntegrationTest());
		runner.add(new ash.core.ComponentMatchingFamilyTest());
		runner.add(new ash.core.EngineTest());
		runner.add(new ash.core.EntityTest());
		runner.add(new ash.core.NodeListTest());
		runner.add(new ash.core.SystemTest());
		runner.add(new ash.fsm.ComponentInstanceProviderTest());
		runner.add(new ash.fsm.ComponentSingletonProviderTest());
		runner.add(new ash.fsm.ComponentTypeProviderTest());
		runner.add(new ash.fsm.DynamicComponentProviderTest());
		runner.add(new ash.fsm.EngineStateMachineTest());
		runner.add(new ash.fsm.EntityStateMachineTest());
		runner.add(new ash.fsm.EntityStateTest());
		runner.add(new ash.fsm.SystemInstanceProviderTest());
		runner.add(new ash.fsm.SystemMethodProviderTest());
		runner.add(new ash.fsm.SystemSingletonProviderTest());
		runner.add(new ash.fsm.SystemStateTest());
		runner.add(new ash.signals.SignalTest());
		runner.add(new ash.tools.ComponentPoolTest());
		runner.add(new ash.tools.ListIteratingSystemTest());
		runner.run();
		
		#if js
		if (runner.result.success)
			untyped __js__("phantom.exit(0);");
		else
			untyped __js__("phantom.exit(1);");
		#end
		
		#if (!flash && !js)
		Sys.exit(runner.result.success ? 0 : 1);
		#end
		
		
	}

}
